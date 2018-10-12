import 'ostle_coord.dart';

class BoardConfig {
  int tileCount;
  List<OstleCoord> holeOstleCoords;
  int winCount;
  BoardConfig(this.tileCount, this.holeOstleCoords, this.winCount);
}

final basicBoardConfig = BoardConfig(5, [OstleCoord(2, 2)], 2);

final extendedBoardConfig = BoardConfig(7, [
  OstleCoord(3, 2),
  OstleCoord(3, 4),
], 3);
