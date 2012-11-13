library gameserver;

import "dart:io";
import "dart:core";
import "dart:json";
import "package:uuid/uuid.dart";
import 'package:mongo_dart/mongo_dart.dart';

import '../lib/gamelib.dart';

const UUID_REGEX = "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}";

class GameServer {
  DbCollection _games;
  HttpServer _server;
  
  GameServer(port,dbConnString){
    Db db = new Db(dbConnString);
    db.open();
    _games = db.collection("games");
    
    _server = new HttpServer();
    _server.listen('127.0.0.1', port);
    _server.defaultRequestHandler = (HttpRequest request, HttpResponse response) => _send404(response);
    _server.addRequestHandler((req) => req.method == "POST" && req.path == "/api/game/create", _createGame);
    _server.addRequestHandler((req) => req.method == "POST" && new RegExp("^/api/game/$UUID_REGEX/player/join\$").hasMatch(req.path), _joinGame);
    _server.addRequestHandler((req) => req.method == "PUT" && new RegExp("^/api/game/$UUID_REGEX/player/$UUID_REGEX/move\$").hasMatch(req.path), _gameMove);
    _server.addRequestHandler((req) => new RegExp("^/api/game/$UUID_REGEX\$").hasMatch(req.path), _gameInfo);

  }
  
  void _send404(HttpResponse response){
    response.statusCode = HttpStatus.NOT_FOUND;
    response.outputStream.writeString(JSON.stringify({'Error':'404'}));
    response.outputStream.close();
  }
  
  void _sendBadRequest(HttpResponse response){
    response.statusCode = HttpStatus.BAD_REQUEST;
    response.outputStream.writeString(JSON.stringify({'Error':'400'}));
    response.outputStream.close();
  }

  void _createGame(HttpRequest req, HttpResponse res){
    var dataMap = {};
    var data = new List<int>();
    req.inputStream.onData = () {
      data.addAll(req.inputStream.read());
      String dataString = new String.fromCharCodes(data);
      dataMap = JSON.parse(dataString);
      
      if(!dataMap.containsKey('color') || !dataMap.containsKey('name')){
        return _sendBadRequest(res);
      }
      var color = int.parse(dataMap['color']);
      var name = dataMap['name'];
      var game = new Game();
      var player = new Player(color,name);
      game.addPlayer(player);
      _games.insert(game.toJson());
      
      res.outputStream.writeString(JSON.stringify({
        "game_id":game.id,
        "player_id":player.id
      }));
      res.outputStream.close();
    };
  }

  void _joinGame(HttpRequest req, HttpResponse res){
    var game_id = new RegExp("^/api/game/($UUID_REGEX)/player/join\$").firstMatch(req.path).group(1);
    var result = _games.findOne({'id':game_id});
    result.then((Map data){
      var game = new Game.fromMap(data);
      
      var dataMap = {};
      var dataStream = new List<int>();
      req.inputStream.onData = () {
        dataStream.addAll(req.inputStream.read());
        String dataString = new String.fromCharCodes(dataStream);
        dataMap = JSON.parse(dataString);
        
        if(!dataMap.containsKey('color') || !dataMap.containsKey('name')){
          return _sendBadRequest(res);
        }
        var color = int.parse(dataMap['color']);
        var name = dataMap['name'];
        var player = new Player(color,name);
        var error = game.addPlayer(player);
        if(error != null){
          res.outputStream.writeString(JSON.stringify({
            'Error': error
          }));
          res.outputStream.close();
          return;
        }
        _games.update({'id':game_id}, game.toMap());
        res.outputStream.writeString(JSON.stringify({
          "player_id": player.id
        }));
        res.outputStream.close();

      };
    });
  }

  void _gameInfo(HttpRequest req, HttpResponse res){
    var game_id = new RegExp("^/api/game/($UUID_REGEX)\$").firstMatch(req.path).group(1);
    var result = _games.findOne({'id':game_id});
    result.then((Map data){
      var game = new Game.fromMap(data);
      res.outputStream.writeString(JSON.stringify(game));
      res.outputStream.close();
    });
  }

  void _gameMove(HttpRequest req, HttpResponse res){
    var matches = new RegExp("^/api/game/($UUID_REGEX)/player/($UUID_REGEX)/move\$").firstMatch(req.path);
    var game_id = matches.group(1);
    var player_id = matches.group(2);
    var result = _games.findOne({'id':game_id});
    result.then((Map data){
      var game = new Game.fromMap(data);
      if(game.getCurrentPlayer().id != player_id){
        res.outputStream.writeString(JSON.stringify({
          'Error': "It's not your turn"
        }));
        res.outputStream.close();
        return;
      }
      
      var dataMap = {};
      var dataStream = new List<int>();
      req.inputStream.onData = () {
        dataStream.addAll(req.inputStream.read());
        String dataString = new String.fromCharCodes(dataStream);
        dataMap = JSON.parse(dataString);
        var error = game.makeMove(dataMap);
        if(error != null){
          res.outputStream.writeString(JSON.stringify({
            'Error': error
          }));
          res.outputStream.close();
          return;
        }
        _games.update({'id':game_id}, game.toMap());
        res.outputStream.writeString(JSON.stringify({
          'Success': true
        }));
        res.outputStream.close();
      };
    });
  }
  
  
  
}
