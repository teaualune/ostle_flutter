import 'dart:ui';
import 'package:spritewidget/spritewidget.dart';

class PieceNode extends NodeWithSize {
  static final _shrinkRatio = 0.8;
  static final Paint _highlightPaint = Paint()..
    color = Color(0xccffffff);

  double frameSize;
  Paint _paint;
  bool highlighted;

  PieceNode(this.frameSize, Color color) : super(Size.square(frameSize)) {
    this._paint = Paint()..
      color = color;
    this.highlighted = false;
  }
}

class SquarePieceNode extends PieceNode {

  static final _radius = 15.0;

  SquarePieceNode(double frameSize, Color color) : super(frameSize, color);

  @override
  void paint(Canvas canvas) {

    this.applyTransformForPivot(canvas);

    if (highlighted) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCircle(
            center: Offset.zero,
            radius: 0.5 * this.frameSize * (PieceNode._shrinkRatio + 0.1),
          ),
          Radius.circular((SquarePieceNode._radius + 1)),
        ),
        PieceNode._highlightPaint,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCircle(
          center: Offset.zero,
          radius: 0.5 * this.frameSize * PieceNode._shrinkRatio,
        ),
        Radius.circular(SquarePieceNode._radius),
      ),
      this._paint,
    );
  }
}

class HolePieceNode extends PieceNode {

  HolePieceNode(double frameSize, Color color) : super(frameSize, color);

  @override
  void paint(Canvas canvas) {

    this.applyTransformForPivot(canvas);

    if (highlighted) {
      canvas.drawCircle(
        Offset.zero,
        0.5 * this.frameSize * (PieceNode._shrinkRatio + 0.1),
        PieceNode._highlightPaint,
      );
    }

    canvas.drawCircle(
        Offset.zero,
        0.5 * this.frameSize * PieceNode._shrinkRatio,
        this._paint,
      );
  }
}
