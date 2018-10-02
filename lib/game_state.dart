import 'game_config.dart';
import 'ostle_piece.dart';
import 'utils.dart';

class PlayerState {
  int takenPieces = 0;
  bool active = false;
}

class GameState implements OstlePieceCallback {
  int tileCount;
  PlayerState player1; // upper side
  PlayerState player2; // lower side

  Map<OstleCoord, OstlePiece> board = Map<OstleCoord, OstlePiece>();

  OstleCoord highlighted;

  GameState(GameConfig gameConfig) {
    this.tileCount = gameConfig.boardConfig.tileCount;

    this.player1 = PlayerState();
    this.player2 = PlayerState();

    for (int i = 0; i < tileCount; i += 1) {
      OstleCoord coord = OstleCoord(0, i);
      board[coord] = OstlePiece.create(
        color: gameConfig.player1Color,
        type: PieceType.player1,
        coord: coord,
        callback: this,
      );

      coord = OstleCoord(tileCount - 1, i);
      board[coord] = OstlePiece.create(
        color: gameConfig.player2Color,
        type: PieceType.player2,
        coord: coord,
        callback: this,
      );
    }

    for (OstleCoord coord in gameConfig.boardConfig.holeOstleCoords) {
      board[coord] = OstlePiece.create(
        color: gameConfig.holeColor,
        type: PieceType.hole,
        coord: coord,
        callback: this,
      );
    }
  }

  void _markAsHighlighted(OstleCoord coord, bool highlighted) {
    OstlePiece target = this.board[coord];
    if (target == null) return;
    print('_markAsHighlighted($coord, $highlighted)');
    if (highlighted) {
      this.highlighted = coord;
      // TODO hook swipe listener?
    } else {
      // TODO unhook swipe listener?
    }
    target.node.highlighted = highlighted;
  }

  @override
  void onClick(OstleCoord coord) {
    OstlePiece target = this.board[coord];
    if (target == null) return;
    OstlePiece highlighting = this.board[this.highlighted];
    if (highlighting == null) {
      // highlight target
      this._markAsHighlighted(coord, true);
    } else {
      if (coord == this.highlighted) {
        // cancel highlight
        this._markAsHighlighted(this.highlighted, false);
        this.highlighted = null;
      } else {
        // highlight target, cancel highlight
        this._markAsHighlighted(this.highlighted, false);
        this._markAsHighlighted(coord, true);
      }
    }
  }

  @override
  void onSwipeAt(OstleCoord coord, PieceDirection direction) {
    //
  }
}