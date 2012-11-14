part of gitoniaclient;

class MainView {
  App _app;
  
  MainView(this._app);
  
  Element draw(){
    
  }
  
  void clearView(){
    document.body.elements.clear();
  }
  
  void showJoinGame(gameId){
    clearView();
    
    var joinGameView = new JoinGameView(_app,gameId);
    document.body.elements.add(joinGameView.draw());
  }
  
  void showGame(){
    clearView();
    
    if(_app.game == null || _app.playerId == null){
      window.location.hash = "";
    }
    
    var gameView = new GameView(_app,_app.game);
    document.body.elements.add(gameView.draw());
  }
}
