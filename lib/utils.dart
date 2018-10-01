import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class OstleCoord {
  int row = 0;
  int col = 0;
  OstleCoord(this.row, this.col);
  operator ==(dynamic another) {
    if (another is OstleCoord) {
      return this.row == another.row && this.col == another.col;
    } else {
      return false;
    }
  }

  @override
    int get hashCode => this.row * 255 + this.col;
}

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
