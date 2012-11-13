part of gameclient;

class App {
  void run(){
    var game = new Game();
    var gameView = new GameView(game);
    document.body.elements.add(gameView.drawBoard(null));
  }
}
