import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';
import 'game_config.dart';
import 'game_state.dart';
import 'ostle_world.dart';
import 'player_dashboard.dart';

class MainPage extends StatefulWidget {
  MainPage({ Key key }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  ImageMap _assets;
  OstleWorld _world = OstleWorld();
  GameState _state;
  GameConfig _config;

  PlayerState _winner;

  Future<Null> _loadAssets(AssetBundle bundle) async {
    _assets = ImageMap(bundle);
    await _assets.load(<String>[
      'assets/ostle_tile.png',
    ]);
  }

  @override
  void initState() {
    super.initState();
    this._loadAssets(rootBundle).then((_) {
      this.restart();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this._state == null) {
      return new Container(
        decoration: new BoxDecoration(
          color: const Color(0xff444444),
        ),
      );
    }

    var mainStructure = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.rotationZ(pi),
              child: PlayerDashboard(
                active: this._state.player1.active,
                takenCount: this._state.player1.takenPieces,
                playerColor: this._config.player1Color,
                opponentColor: this._config.player2Color,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1.0,
            child: SpriteWidget(this._world),
          ),
          Expanded(
            child: PlayerDashboard(
              active: this._state.player2.active,
              takenCount: this._state.player2.takenPieces,
              playerColor: this._config.player2Color,
              opponentColor: this._config.player1Color,
            ),
          ),
        ],
      ),
    ];

    if (this._winner != null) {
      bool needRotate = this._winner == this._state.player1;
      mainStructure.add(Container(
        decoration: BoxDecoration(
          color: Color(0x88000000),
        ),
        child: GestureDetector(
          onTap: this.restart,
          child: Center(
            child: Transform(
              alignment: FractionalOffset.center,
              transform: needRotate ? Matrix4.rotationZ(pi) : Matrix4.identity(),
              child: Text(
                "You Win!",
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
      ),
      child: Stack(
        children: mainStructure,
      ),
    );
  }

  void restart() {
    this.setState(() {
      // TODO read config or state from persistent storage
      this._config = GameConfig.defaultConfig();
      this._state = GameState(this._config);
      this._world.initializeWorld(this._config, this._state, this._assets);
      this._winner = null;
    });
    this.changeTurn();
  }

  void changeTurn([bool player1Active]) {
    if (player1Active == null) {
      player1Active = randomBool();
    }
    this.setState(() {
      this._state.player1.active = player1Active;
      this._state.player2.active = !player1Active;
    });
  }

  void takePiece(PlayerState player) {
    this.setState(() {
      player.takenPieces += 1;
    });

    if (player.takenPieces == this._config.boardConfig.winCount) {
      this.win(player);
    }
  }

  void win(PlayerState player) {
    this.setState(() {
      this._winner = player;
      this._state.player1.active = false;
      this._state.player2.active = false;
    });
  }
}
