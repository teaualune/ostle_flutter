import 'utils.dart';

class BoardConfig {
  int tileCount;
  List<OstleCoord> holeOstleCoords;
  int winCount;
  BoardConfig(this.tileCount, this.holeOstleCoords, this.winCount);
}

final basicBoardConfig = new BoardConfig(5, [OstleCoord(2, 2)], 2);

final extendedBoardConfig = new BoardConfig(7, [
  OstleCoord(3, 2),
  OstleCoord(3, 4),
], 3);
