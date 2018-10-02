import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

/// https://github.com/spritewidget/spritewidget/blob/master/example/weather/lib/weather_demo.dart
class GradientNode extends NodeWithSize {
  GradientNode(Size size, this.colorTop, this.colorBottom) : super(size);

  Color colorTop;
  Color colorBottom;

  @override
  void paint(Canvas canvas) {
    applyTransformForPivot(canvas);

    Rect rect = Offset.zero & size;
    Paint gradientPaint = new Paint()..shader = new LinearGradient(
      begin: FractionalOffset.topLeft,
      end: FractionalOffset.bottomLeft,
      colors: <Color>[colorTop, colorBottom],
      stops: <double>[0.0, 1.0]
    ).createShader(rect);

    canvas.drawRect(rect, gradientPaint);
  }
}

abstract class ClickableNodeMixin extends Node {

  int _firstPointer;

  void onClick(Offset boxPosition);
  
  @override
  bool handleEvent(SpriteBoxEvent event) {
    if (event.type == PointerDownEvent) {
      this._firstPointer = event.pointer;
    } else if (event.type == PointerUpEvent) {
      if (event.pointer == this._firstPointer) {
        this.onClick(event.boxPosition);
      }
      this._firstPointer = null;
    }
    return true;
  }
}

class OstleSpriteWidgetUtils {
  static ActionTween<Offset> createMoveAction(
    Node node,
    Offset origin, dest,
    double interval,
  ) => ActionTween<Offset>(
    (offset) {
      node.position = offset;
    },
    origin,
    dest,
    interval,
  );
}
