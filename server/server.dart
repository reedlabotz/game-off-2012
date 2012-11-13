import "dart:io";
import "dart:core";
import "package:uuid/uuid.dart";
import 'package:mongo_dart/mongo_dart.dart';

import 'GameServer.dart';

void main() {
  var gameServer = new GameServer(7000,"mongodb://127.0.0.1/gamedb");
  print("Listening on 7000");
}

