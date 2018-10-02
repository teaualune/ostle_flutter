import 'arrow_pad.dart';
import 'game_config.dart';
import 'ostle_piece.dart';
import 'ostle_coord.dart';

abstract class GameStateCallback {
  void changeTurn([bool player1Active]);
  void takePiece(PlayerState player);
}

class PlayerState {
  int takenPieces = 0;
  bool active = false;
}

class GameState implements OstlePieceCallback, ArrowPadCallback {
  int tileCount;
  PlayerState player1; // upper side
  PlayerState player2; // lower side

  Map<OstleCoord, OstlePiece> board = Map<OstleCoord, OstlePiece>();

  OstleCoord highlighted;
  ArrowPad arrowPad;

  GameStateCallback _gameStateCallback;

  GameState(this._gameStateCallback, GameConfig gameConfig) {
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

  void clear() {
    this.board.clear();
    this._gameStateCallback = null;
  }

  void _markAsHighlighted(OstleCoord coord, bool highlighted) {
    if (coord == null) return;
    OstlePiece target = this.board[coord];
    if (target == null) return;
    if (highlighted) {
      this.highlighted = coord;

      List<PieceDirection> validDirections = this._getValidDirections(coord);
      print(validDirections);

      this.arrowPad.show(
        coord,
        validDirections,
      );
    }
    target.node.highlighted = highlighted;
  }

  List<PieceDirection> _getValidDirections(OstleCoord coord) {
    OstlePiece target = this.board[coord];
    if (target == null) return [];
    return OstleCoord.allDirections.where(
      (direction) => this._isValidDirection(coord, direction),
    ).toList(growable: false);
  }

  bool _isValidDirection(OstleCoord coord, PieceDirection direction) {

    // TODO cache result, and clear cache when turn changed
    // TODO prevent looped steps

    OstlePiece target = this.board[coord];

    // 0. empty piece cannot move
    if (target == null) return false;

    // 1. edge
    if (coord.row == 0 && direction == PieceDirection.up) return false;
    if (coord.col == 0 && direction == PieceDirection.left) return false;
    if (coord.row == this.tileCount -1 && direction == PieceDirection.down) return false;
    if (coord.col == this.tileCount -1 && direction == PieceDirection.right) return false;

    // 2. can move to empty coord
    OstlePiece destination = this.board[coord + OstleCoord.of(direction)];
    if (destination == null) return true;

    // 3. cannot move to hole
    if (destination.type == PieceType.hole) return false;

    // 4. hole cannot move to square
    if (target.type == PieceType.hole && destination.type != PieceType.hole) return false;

    // 5. cannot push off same team
    if (target.type != PieceType.hole) {
      OstlePiece prevPiece = target, nextPiece;
      OstleCoord nextCoord = coord;
      while(!nextCoord.isOutside(this.tileCount)) {
        nextCoord = nextCoord + OstleCoord.of(direction);
        nextPiece = this.board[nextCoord];
        if (nextPiece == null) {
          if (nextCoord.isOutside(this.tileCount)) {
            // reach end
            break;
          } else {
          // reach empty coord
            return true;
          }
        } else if (nextPiece.type == PieceType.hole) {
          // reach hole
          break;
        }
        prevPiece = nextPiece;
      }
      // reach end or hole
      if (prevPiece.type == target.type) return false;
    }

    return true;
  }

  void cancelHighlight() {
    this._markAsHighlighted(this.highlighted, false);
    this.highlighted = null;
    this.arrowPad.hide();
  }

  @override
  void onClickPiece(OstleCoord coord) {
    OstlePiece target = this.board[coord];
    if (target == null) return;
    if (
      (target.type == PieceType.player1 && !this.player1.active) ||
      (target.type == PieceType.player2 && !this.player2.active)
    ) {
      this.cancelHighlight();
      return;
    }

    if (this.highlighted == null) {
      // highlight coord
      this._markAsHighlighted(coord, true);
      return;
    }
    OstlePiece highlighting = this.board[this.highlighted];
    if (highlighting == null) {
      // highlight target
      this._markAsHighlighted(coord, true);
    } else {
      if (coord == this.highlighted) {
        // cancel highlight
        this.cancelHighlight();
      } else {
        // highlight target, cancel highlight
        this._markAsHighlighted(this.highlighted, false);
        this._markAsHighlighted(coord, true);
      }
    }
  }

  @override
  void onClickPad(PieceDirection direction) {
    OstleCoord coord = this.highlighted;
    OstlePiece target = this.board[coord];
    if (target == null) return;
    if (!this._isValidDirection(coord, direction)) return;

    this.cancelHighlight();

    if (target.type == PieceType.hole) {
      _move(coord, direction);
    } else {
      List<OstleCoord> coords = [coord];
      OstlePiece nextPiece;
      OstleCoord nextCoord = coord;
      while(!nextCoord.isOutside(this.tileCount)) {
        nextCoord = nextCoord + OstleCoord.of(direction);
        nextPiece = this.board[nextCoord];
        if (nextPiece == null || nextPiece.type == PieceType.hole) break;
        coords.add(nextCoord);
      }

      coords.reversed.forEach((coord) {
        this._move(coord, direction);
      });
    }

    this._gameStateCallback.changeTurn(!this.player1.active);
  }

  void _move(OstleCoord coord, PieceDirection direction) {
    print('moving $coord to $direction');
    OstlePiece target = this.board[coord];
    if (target == null) return;
    target.node.highlighted = false;

    OstleCoord newCoord = coord + OstleCoord.of(direction);
    OstlePiece next = this.board[newCoord];
    if (next != null && next.type == PieceType.hole) {
      this._take(target, direction);
      return;
    }

    this.board[coord] = null;
    this.board[newCoord] = target;
    target.coord = newCoord;

    if (target is SquarePiece && newCoord.isOutside(this.tileCount)) {
      this._take(target, direction);
    } else {
      target.setNodePosition(true);
    }
  }

  void _take(SquarePiece piece, PieceDirection takenDirection) {
    OstleCoord coord = piece.coord;
    if (this.board[coord] != piece) return;
    this.board[coord] = null;
    piece.runTakenAnimation(coord + OstleCoord.of(takenDirection));

    PlayerState player = piece.type == PieceType.player1 ? this.player2 : this.player1;
    this._gameStateCallback.takePiece(player);
  }
}