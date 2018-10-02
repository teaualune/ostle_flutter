import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:spritewidget/spritewidget.dart';
import 'utils.dart';

abstract class PieceNodeCallback {
  void onClickPiece();
}

class PieceNode extends NodeWithSize with ClickableNodeMixin {
  static final _shrinkRatio = 0.8;
  static final Paint _highlightPaint= (Paint()
    ..color = Color(0xccffffff)
  );

  double frameSize;
  Paint _paint;
  Color _paintColor;
  bool highlighted;
  PieceNodeCallback callback;

  PieceNode(this.frameSize, Color color, this.callback) : super(Size.square(frameSize)) {
    this._paintColor = color;
    this._paint = (Paint()
      ..color = color
    );
    this.highlighted = false;
  }

  double get _radius => 0.5 * this.frameSize;
  Offset get _center => Offset(this._radius, this._radius);

  set opacity(double o) {
    int alpha = (255.0 * o).round();
    this._paint.color = this._paintColor.withAlpha(alpha);
  }

  @override
  void onClick(Offset boxPosition) {
    this.callback.onClickPiece();
  }

  void animateTo(Offset dest, double interval) {
    this.actions.run(OstleSpriteWidgetUtils.createMoveAction(
      this,
      this.position,
      dest,
      interval,
    ));
  }

  void animateToAndDisappear(Offset dest, double interval) {
    this.actions.run(ActionSequence([
      OstleSpriteWidgetUtils.createMoveAction(
        this,
        this.position,
        dest,
        interval,
      ),
      ActionTween<double>(
        (opacity) {
          this.opacity = opacity;
        },
        1.0,
        0.0,
        interval,
      ),
      ActionCallFunction(() {
        this.removeFromParent();
      }),
    ]));
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
            radius: this._radius * (PieceNode._shrinkRatio + 0.16),
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
        this._radius * (PieceNode._shrinkRatio + 0.16),
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
