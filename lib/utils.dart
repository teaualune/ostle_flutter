import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

enum PieceDirection { up, right, down, left }

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

  OstleCoord operator +(dynamic another) {
    if (another is OstleCoord) {
      return OstleCoord(this.row + another.row, this.col + another.col);
    } else {
      return this;
    }
  }

  OstleCoord operator -(dynamic another) {
    if (another is OstleCoord) {
      return OstleCoord(this.row - another.row, this.col - another.col);
    } else {
      return this;
    }
  }

  @override
  int get hashCode => this.row * 255 + this.col;

  @override
  String toString() => '$row-$col';

  bool isOutside(int tileCount) =>
    this.row < 0 ||
    this.row > tileCount - 1 ||
    this.col < 0 ||
    this.col > tileCount - 1;

  static final OstleCoord zero = OstleCoord(0, 0);

  static final OstleCoord _up = OstleCoord(-1, 0);
  static final OstleCoord _right = OstleCoord(0, 1);
  static final OstleCoord _down = OstleCoord(1, 0);
  static final OstleCoord _left = OstleCoord(0, -1);

  static OstleCoord of(PieceDirection direction) {
    switch(direction) {
      case PieceDirection.up:
        return _up;
      case PieceDirection.right:
        return _right;
      case PieceDirection.down:
        return _down;
      case PieceDirection.left:
        return _left;
      default:
        return zero;
    }
  }

  static final List<PieceDirection> allDirections = [
    PieceDirection.up,
    PieceDirection.right,
    PieceDirection.down,
    PieceDirection.left,
  ];
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

abstract class ClickableNodeMixin extends Node {

  int _firstPointer;

  void onClick(Offset boxPosition);
  
  @override
  bool handleEvent(SpriteBoxEvent event) {
    if (event.type == PointerDownEvent) {
      this._firstPointer = event.pointer;
    } else if (event.type == PointerUpEvent) {
      print(this.runtimeType);
      if (event.pointer == this._firstPointer) {
        this.onClick(event.boxPosition);
      }
      this._firstPointer = null;
    }
    return true;
  }
}
