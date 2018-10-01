import 'dart:ui';
import 'package:spritewidget/spritewidget.dart';

// TODO

enum PieceType { player1, player2, hole }

class OstlePiece {
  Color color;
  PieceType type;
  OstlePiece(this.color, this.type);
  Node node;
}

class SquarePiece extends OstlePiece {
  SquarePiece(Color color, PieceType type) : super(color, type);
}

class HolePiece extends OstlePiece {
  HolePiece(Color color) : super(color, PieceType.hole);
}
