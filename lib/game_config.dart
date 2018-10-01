import 'package:flutter/material.dart';
import 'board_config.dart';

class GameConfig {
  Color player1Color;
  Color player2Color;
  Color holeColor;
  BoardConfig boardConfig;

  // TODO customizable
  List<Color> backgroundGradients = [
    const Color(0xff5ebbd5),
    const Color(0xff4aaafb),
  ];

  // TODO customizable
  static GameConfig defaultConfig() {
    GameConfig config = GameConfig();
    config.player1Color = const Color(0xffebdf33);
    config.player2Color = const Color(0xff962820);
    config.holeColor = const Color(0xff333333);
    config.boardConfig = basicBoardConfig;
    return config;
  }
}
