import 'dart:ui';
import 'package:spritewidget/spritewidget.dart';
import 'ostle_coord.dart';
import 'utils.dart';

abstract class ArrowPadCallback {
  void onClickPad(PieceDirection direction);
}

class ArrowPad extends Node {

  double _tileSize;

  Map<PieceDirection, _Arrow> arrows;

  ArrowPad(this._tileSize, ImageMap imageMap, ArrowPadCallback callback) {
    Image image = imageMap['assets/arrow-01.png'];
    this.arrows = {
      PieceDirection.up: _Arrow(PieceDirection.up, callback, image, this._tileSize),
      PieceDirection.right: _Arrow(PieceDirection.right, callback, image, this._tileSize),
      PieceDirection.down: _Arrow(PieceDirection.down, callback, image, this._tileSize),
      PieceDirection.left: _Arrow(PieceDirection.left, callback, image, this._tileSize),
    };
    arrows.forEach((_, node) {
      this.addChild(node);
    });
    this.visible = false;
  }

  void show(OstleCoord coord, List<PieceDirection> validDirections) {
    this.position = Offset(
      this._tileSize * (coord.col + 0.5),
      this._tileSize * (coord.row + 0.5),
    );
    this.visible = true;
    this.arrows.forEach((_, node) {
      node.visibleAndInteractable = false;
    });
    for (PieceDirection d in validDirections) {
      this.arrows[d].visibleAndInteractable = true;
    }
  }

  void hide() {
    this.visible = false;
    this.arrows.forEach((_, node) {
      node.visibleAndInteractable = false;
    });
  }
}

class _Arrow extends NodeWithSize with ClickableNodeMixin {

  static double _shrinkRatio = 0.6;

  PieceDirection direction;
  ArrowPadCallback _callback;

  _Arrow(
    this.direction,
    this._callback,
    Image image,
    double tileSize,
  ) : super(Size.square(tileSize * _Arrow._shrinkRatio)) {
    Sprite sprite = Sprite.fromImage(image);
    sprite.size = this.size;
    this.addChild(sprite);

    this.pivot = Offset(0.5, 0.5);
    switch(this.direction) {
      case PieceDirection.right:
      this.rotation = 90.0;
      this.position = Offset(tileSize, 0.0);
      break;
      case PieceDirection.down:
      this.rotation = 180.0;
      this.position = Offset(0.0, tileSize);
      break;
      case PieceDirection.left:
      this.rotation = -90.0;
      this.position = Offset(-tileSize, 0.0);
      break;
      case PieceDirection.up:
      this.position = Offset(0.0, -tileSize);
      break;
      default:
    }

    this.visibleAndInteractable = false;
  }

  set visibleAndInteractable(bool b) {
    this.visible = b;
    this.userInteractionEnabled = b;
  }

  @override
  void onClick(Offset boxPosition) {
    if (!this.visible) return;
    this._callback.onClickPad(this.direction);
  }
}
