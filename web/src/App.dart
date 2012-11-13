part of gitoniaclient;

class App {
  void run(){
    var mainView = new MainView();
    document.body.elements.add(mainView.draw());
  }
}
