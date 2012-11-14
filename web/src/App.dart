part of gitoniaclient;

class App {
  GitoniaService service;
  MainView _mainView;
  Game game;
  String playerId;
  
  App(){
    service = new GitoniaService();
    _mainView = new MainView(this);
  }
  
  void run(){
    window.on.hashChange.add((e) => route());
    route();
  }
  
  void route(){
    print("routing: ${window.location.hash}");
    if(window.location.hash == ""){
      _mainView.showJoinGame(null);
    }else if(new RegExp("^#game/${UUID_REGEX}\$").hasMatch(window.location.hash)){
      var gameId = new RegExp("^#game/(${UUID_REGEX})\$").firstMatch(window.location.hash).group(1);
      playerId = checkForActiveGame(gameId);
      if(playerId == null){
        _mainView.showJoinGame(gameId);
      }else{
        service.getGameInfo(gameId,(data){
          game = new Game.fromMap(data);
          _mainView.showGame();
        });
      }
    }
  }  
  
  String checkForActiveGame(gameId){
    if(playerId != null){
      return playerId;
    }
    List games = loadGames();
    for(var g in games){
      if(g['game_id'] == gameId){
        return g['player_id'];
      }
    }
    return null;
  }
  
  void saveGame(String gameId, String playerId){
    List games = [];
    if(window.localStorage.containsKey('games')){
      games = JSON.parse(window.localStorage['games']);
    }
    games.add({'game_id':gameId, 'player_id':playerId});
    window.localStorage['games'] = JSON.stringify(games);
  }
  
  List loadGames(){
    if(!window.localStorage.containsKey('games')){
      return [];
    }
    return JSON.parse(window.localStorage['games']);
  }
  
  void setCurrentGame(String gameId, String player_id){
    this.playerId = player_id;
    window.location.hash = "game/${gameId}";
  }
}
