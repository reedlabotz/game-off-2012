library gameclient;

import '../lib/gamelib.dart';

import 'dart:html';
import 'dart:math';

part 'App.dart';
part 'GameView.dart';

void main() {
  var app = new App();
  app.run();
}