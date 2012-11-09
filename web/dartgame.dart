import '../src/gamelib.dart';

import 'dart:html';

void main() {
  var app = new App();
  app.run();
  
  var board = new Board();
  document.body.elements.add(board.draw());
}