import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:spritewidget/spritewidget.dart';

abstract class PieceNodeCallback {
  void onClickPiece();

  // TODO direction
  void onSwipePiece();
}

class PieceNode extends NodeWithSize {
  static final _shrinkRatio = 0.8;
  static final Paint _highlightPaint = Paint()..
    color = Color(0xccffffff);

  double frameSize;
  Paint _paint;
  bool highlighted;
  PieceNodeCallback callback;

  int _firstPointer;

  PieceNode(this.frameSize, Color color, this.callback) : super(Size.square(frameSize)) {
    this._paint = Paint()..
      color = color;
    this.highlighted = false;
  }

  double get _radius => 0.5 * this.frameSize;
  Offset get _center => Offset(this._radius, this._radius);

  @override
  bool handleEvent(SpriteBoxEvent event) {
    if (event.type == PointerDownEvent) {
      this._firstPointer = event.pointer;
    } else if (event.type == PointerUpEvent) {
      if (event.pointer == this._firstPointer) {
        this.callback.onClickPiece();
      }
      this._firstPointer = null;
    }
    return false;
  }
}

class SquarePieceNode extends PieceNode {

  static final _borderRadius = 15.0;

  SquarePieceNode(double frameSize, Color color, PieceNodeCallback callback) : super(frameSize, color, callback);

  @override
  void paint(Canvas canvas) {

    canvas.save();
    this.applyTransformForPivot(canvas);

    if (highlighted) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCircle(
            center: this._center,
            radius: this._radius * (PieceNode._shrinkRatio + 0.1),
          ),
          Radius.circular((SquarePieceNode._borderRadius + 1)),
        ),
        PieceNode._highlightPaint,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCircle(
          center: this._center,
          radius: this._radius * PieceNode._shrinkRatio,
        ),
        Radius.circular(SquarePieceNode._borderRadius),
      ),
      this._paint,
    );

    canvas.restore();
  }
}

class HolePieceNode extends PieceNode {

  HolePieceNode(double frameSize, Color color, PieceNodeCallback callback) : super(frameSize, color, callback);

  @override
  void paint(Canvas canvas) {

    canvas.save();
    this.applyTransformForPivot(canvas);

    if (highlighted) {
      canvas.drawCircle(
        this._center,
        this._radius * (PieceNode._shrinkRatio + 0.1),
        PieceNode._highlightPaint,
      );
    }

    canvas.drawCircle(
      this._center,
      this._radius * PieceNode._shrinkRatio,
      this._paint,
    );

    canvas.restore();
  }
}
