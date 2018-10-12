import 'dart:ui';
import 'ostle_coord.dart';
import 'piece_node.dart';

enum PieceType { player1, player2, hole }

abstract class OstlePieceCallback {
  void onClickPiece(OstleCoord coord);
}

abstract class OstlePiece implements PieceNodeCallback {

  static final _moveInterval = 0.3;

  Color color;
  PieceType type;
  PieceNode node;
  OstleCoord coord;
  OstlePieceCallback callback;

  PieceNode build(double frameSize);

  @override
  void onClickPiece() {
    this.callback.onClickPiece(this.coord);
  }

  OstlePiece();

  factory OstlePiece.create({
    Color color,
    PieceType type,
    OstleCoord coord,
    OstlePieceCallback callback,
  }) {
    OstlePiece instance;
    if (type == PieceType.hole) {
      instance = HolePiece();
    } else {
      instance = SquarePiece();
    }
    instance.color = color;
    instance.type = type;
    instance.coord = coord;
    instance.callback = callback;
    return instance;
  }

  void setNodePosition(bool animated) {
    if (this.node == null) return;
    double size = this.node.size.width;
    Offset dest = Offset(
      (this.coord.col + 0.5) * size,
      (this.coord.row + 0.5) * size,
    );
    if (animated) {
      this.node.animateTo(dest, OstlePiece._moveInterval);
    } else {
      this.node.position = dest;
    }
  }

  void runTakenAnimation(OstleCoord destCoord) {
    double size = this.node.size.width;
    this.node.animateToAndDisappear(
      Offset(
        (destCoord.col + 0.5) * size,
        (destCoord.row + 0.5) * size,
      ),
      OstlePiece._moveInterval,
    );
  }
}

class SquarePiece extends OstlePiece {

  @override
  PieceNode build(double frameSize) {
    return SquarePieceNode(frameSize, this.color, this);
  }
}

class HolePiece extends OstlePiece {

  @override
  PieceNode build(double frameSize) {
    return HolePieceNode(frameSize, this.color, this);
  }
}
