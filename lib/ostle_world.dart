import 'dart:ui';
import 'package:spritewidget/spritewidget.dart';
import 'game_config.dart';
import 'game_state.dart';
import 'ostle_piece.dart';
import 'piece_node.dart';
import 'utils.dart';

// TODO size parameterize
const _fieldSize = 1024.0;

class OstleWorld extends NodeWithSize {

  GradientNode _backgroundNode;
  double _tileSize;

  OstleWorld(): super(const Size(_fieldSize, _fieldSize));

  void initializeWorld(GameConfig gameConfig, GameState gameState, ImageMap imageMap) {

    double d = _fieldSize / gameState.tileCount;
    this._tileSize = d;

    // 1. background
    this._backgroundNode = GradientNode(
      this.size,
      gameConfig.backgroundGradients[0],
      gameConfig.backgroundGradients[1],
    );
    this.addChild(this._backgroundNode);

    // 2. 25 tiles
    for (int i = 0; i < gameState.tileCount; i += 1) {
      for (int j = 0; j < gameState.tileCount; j += 1) {
        Sprite tile = Sprite.fromImage(imageMap['assets/ostle_tile.png']);
        tile.position = Offset((i + 0.5) * d, (j + 0.5) * d);
        tile.size = Size(d + 1, d + 1);
        this.addChild(tile);
      }
    }

    // 3. 10 square pieces
    // 4. 1 hole piece
    gameState.board.forEach((coord, piece) {
      piece.node = piece.type == PieceType.hole ?
        HolePieceNode(d, piece.color) :
        SquarePieceNode(d, piece.color);
      piece.node.position = Offset((coord.col + 0.5) * d, (coord.row + 0.5) * d);
      this.addChild(piece.node);
    });

  }
}