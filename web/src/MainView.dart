part of gameclient;

class MainView {
  Element draw(){
    var joinGameView = new JoinGameView(null);
    return joinGameView.draw();
  }
}
