import 'dart:ui';
import 'piece_node.dart';
import 'utils.dart';

enum PieceType { player1, player2, hole }

abstract class OstlePieceCallback {
  void onClickPiece(OstleCoord coord);
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

  void setNodePosition() {
    if (this.node == null) return;
    double size = this.node.size.width;
    // TODO animation
    this.node.position = Offset(
      (this.coord.col + 0.5) * size,
      (this.coord.row + 0.5) * size,
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
