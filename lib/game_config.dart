import 'package:flutter/material.dart';
import 'board_config.dart';

class GameConfig {
  Color player1Color;
  Color player2Color;
  Color holeColor;
  BoardConfig boardConfig;

  // TODO customizable
  List<Color> backgroundGradients = [
    Color(0xff5ebbd5),
    Color(0xff4aaafb),
  ];

  // TODO customizable
  static GameConfig defaultConfig() {
    GameConfig config = GameConfig();
    config.player1Color = Color(0xffebdf33);
    config.player2Color = Color(0xff962820);
    config.holeColor = Color(0xff333333);
    config.boardConfig = basicBoardConfig;
    return config;
  }

  static GameConfig grayConfig() {
    GameConfig config = GameConfig();
    config.player1Color = Color(0xffdddddd);
    config.player2Color = Color(0xff333333);
    config.holeColor = Color(0xff888888);
    config.boardConfig = basicBoardConfig;
    return config;
  }

  static GameConfig bigConfig() {
    GameConfig config = GameConfig();
    config.player1Color = Color(0xffebdf33);
    config.player2Color = Color(0xff962820);
    config.holeColor = Color(0xff333333);
    config.boardConfig = extendedBoardConfig;
    return config;
  }
}
