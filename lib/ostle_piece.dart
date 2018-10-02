import 'dart:ui';
import 'piece_node.dart';
import 'utils.dart';

enum PieceType { player1, player2, hole }

abstract class OstlePieceCallback {
  void onClick(OstleCoord coord);
  void onSwipeAt(OstleCoord coord, PieceDirection direction);
}

abstract class OstlePiece implements PieceNodeCallback {
  Color color;
  PieceType type;
  PieceNode node;
  OstleCoord coord;
  OstlePieceCallback callback;

  PieceNode build(double frameSize);

  @override
  void onClickPiece() {
    this.callback.onClick(this.coord);
  }

  @override
  void onSwipePiece() {}

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
}

class SquarePiece extends OstlePiece {
  // SquarePiece(Color color, PieceType type) : super(color, type);

  @override
    PieceNode build(double frameSize) {
      return SquarePieceNode(frameSize, this.color, this);
    }
}

class HolePiece extends OstlePiece {
  // HolePiece(Color color) : super(color, PieceType.hole);

  @override
    PieceNode build(double frameSize) {
      return HolePieceNode(frameSize, this.color, this);
    }
}
