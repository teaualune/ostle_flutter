import 'dart:ui';
import 'game_config.dart';
import 'ostle_piece.dart';
import 'utils.dart';

class PlayerState {
  // List<SquarePiece> pieces;
  int takenPieces = 0;
  bool active = false;

  // PlayerState(int tileCount, bool lowerSide, Color color) {
  //   // this.pieces = new List<SquarePiece>(tileCount);
  //   // int row = lowerSide ? (tileCount - 1) : 0;
  //   // for (int i = 0; i < tileCount; i += 1) {
  //   //   this.pieces[i] = SquarePiece(OstleCoord(row, i), color);
  //   // }
  //   this.takenPieces = 0;
  //   this.active = false;
  // }
}

class GameState {
  int tileCount;
  PlayerState player1; // upper side
  PlayerState player2; // lower side
  // List<HolePiece> holePieces;

  Map<OstleCoord, OstlePiece> board = Map<OstleCoord, OstlePiece>();

  GameState(GameConfig gameConfig) {
    this.tileCount = gameConfig.boardConfig.tileCount;

    this.player1 = PlayerState();
    this.player2 = PlayerState();
    // this.player1 = PlayerState(tileCount, false, gameConfig.player1Color);
    // this.player2 = PlayerState(tileCount, true, gameConfig.player2Color);

    for (int i = 0; i < tileCount; i += 1) {
      board[OstleCoord(0, i)] = SquarePiece(gameConfig.player1Color, PieceType.player1);
      board[OstleCoord(tileCount - 1, i)] = SquarePiece(gameConfig.player2Color, PieceType.player2);
    }

    // this.holePieces = [];
    for (OstleCoord coord in gameConfig.boardConfig.holeOstleCoords) {
      // this.holePieces.add(HolePiece(coord, gameConfig.holeColor));
      board[coord] = HolePiece(gameConfig.holeColor);
    }
  }
}