import 'dart:ui';
import 'package:spritewidget/spritewidget.dart';
import 'game_config.dart';
import 'game_state.dart';
import 'arrow_pad.dart';
import 'utils.dart';

// TODO size parameterize
const _fieldSize = 1024.0;

class OstleWorld extends NodeWithSize {

  OstleWorld(
    GameConfig gameConfig,
    GameState gameState,
    ImageMap imageMap,
  ): super(Size(_fieldSize, _fieldSize)) {

    double d = _fieldSize / gameState.tileCount;

    // 1. background
    Node background = _BackgroundNode(gameConfig, gameState, this.size);
    background.zPosition = 1.0;
    this.addChild(background);

    // 2. 25 tiles
    for (int i = 0; i < gameState.tileCount; i += 1) {
      for (int j = 0; j < gameState.tileCount; j += 1) {
        Sprite tile = (Sprite.fromImage(imageMap['assets/ostle_tile.png'])
          ..position = Offset((i + 0.5) * d, (j + 0.5) * d)
          ..size = Size(d + 1, d + 1)
          ..zPosition = 2.0
        );
        this.addChild(tile);
      }
    }

    // 3. 10 square pieces
    // 4. 1 hole piece
    gameState.board.forEach((coord, piece) {
      piece.node = (piece.build(d)
        ..pivot = Offset(0.5, 0.5)
        ..userInteractionEnabled = true
        ..zPosition = 3.0
      );
      piece.setNodePosition(false);
      this.addChild(piece.node);
    });

    // 5. arrow pad
    gameState.arrowPad = ArrowPad(d, imageMap, gameState);
    gameState.arrowPad.zPosition = 4.0;
    this.addChild(gameState.arrowPad);
  }
}

class _BackgroundNode extends NodeWithSize with ClickableNodeMixin {
  GameState _state;
  _BackgroundNode(GameConfig gameConfig, this._state, Size size) : super(size) {
    this.addChild(GradientNode(
      size,
      gameConfig.backgroundGradients[0],
      gameConfig.backgroundGradients[1],
    ));
    this.userInteractionEnabled = true;
  }

  @override
  void onClick(Offset boxPosition) {
    this._state.cancelHighlight();
  }
}
