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
      
      if(!dataMap.containsKey('color')){
        return _sendBadRequest(res);
      }
      var color = int.parse(dataMap['color']);
      var game = new Game();
      var player = new Player(color);
      game.players.add(player);
      _games.insert(game.toJson());
      
      res.outputStream.writeString(JSON.stringify(game));
      res.outputStream.close();
    };
  }

  void _joinGame(HttpRequest req, HttpResponse res){
    res.outputStream.writeString("join game");
    res.outputStream.close();
  }

  void _gameInfo(HttpRequest req, HttpResponse res){
    res.outputStream.writeString("game info");
    res.outputStream.close();
  }

  void _gameMove(HttpRequest req, HttpResponse res){
    res.outputStream.writeString("game move");
    res.outputStream.close();
  }
  
  
  
}
