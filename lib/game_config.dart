import 'package:flutter/material.dart';

class GameConfig {
  Color player1Color;
  Color player2Color;
  Color holeColor;

  // TODO customizable
  List<Color> backgroundGradients = [
    Color(0xff5ebbd5),
    Color(0xff4aaafb),
  ];

  static GameConfig defaultConfig() => (GameConfig()
    ..player1Color = Color(0xffebdf33)
    ..player2Color = Color(0xff962820)
    ..holeColor = Color(0xff333333)
  );

  static GameConfig grayConfig() => (GameConfig()
    ..player1Color = Color(0xffdddddd)
    ..player2Color = Color(0xff333333)
    ..holeColor = Color(0xff888888)
  );

  static GameConfig bigConfig() => (GameConfig()
    ..player1Color = Color(0xffebdf33)
    ..player2Color = Color(0xff962820)
    ..holeColor = Color(0xff333333)
  );

  static List<GameConfig> gameConfigs = <GameConfig>[
    GameConfig.defaultConfig(),
    GameConfig.grayConfig(),
  ];
}
