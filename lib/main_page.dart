import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';
import 'board_config.dart';
import 'game_config.dart';
import 'game_state.dart';
import 'loading_widget.dart';
import 'ostle_preferences.dart';
import 'ostle_world.dart';
import 'player_dashboard.dart';

class MainPage extends StatefulWidget {
  MainPage({ Key key }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> implements GameStateCallback {

  ImageMap _assets;
  OstleWorld _world;
  GameState _state;
  GameConfig _gameConfig;

  // TODO add extended config
  BoardConfig _boardConfig = basicBoardConfig;

  PlayerState _winner;

  Future<Null> _loadAssets(AssetBundle bundle) async {
    _assets = ImageMap(bundle);
    await _assets.load(<String>[
      'assets/arrow-01.png',
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
      return LoadingWidget();
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
                playerColor: this._gameConfig.player1Color,
                opponentColor: this._gameConfig.player2Color,
                onDialogResult: this.shouldRestart,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1.0,
            child: this._world != null ?
              ClipRect(child: SpriteWidget(this._world)) :
              LoadingWidget(),
          ),
          Expanded(
            child: PlayerDashboard(
              active: this._state.player2.active,
              takenCount: this._state.player2.takenPieces,
              playerColor: this._gameConfig.player2Color,
              opponentColor: this._gameConfig.player1Color,
              onDialogResult: this.shouldRestart,
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
          onTap: () {
            this.restart();
          },
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

    return Scaffold(body: Container(
      decoration: BoxDecoration(
        color: Colors.white70,
      ),
      child: Stack(
        children: mainStructure,
      ),
    ));
  }

  @override
    void dispose() {
    if (this._state != null) {
      this._state.clear();
    }
    super.dispose();
  }

  void shouldRestart(bool configChanged) {
    if (configChanged) {
      this.restart();
    }
  }

  void restart() {
    OstlePreferences.getGameConfigIndex().then((index) {
      this.setState(() {
        this._gameConfig = GameConfig.gameConfigs[index];
        if (this._state != null) {
          this._state.clear();
        }
        this._state = GameState(this, this._gameConfig, this._boardConfig);
        this._world = OstleWorld(this._gameConfig, this._state, this._assets);
        this._winner = null;
      });
      this.changeTurn();
    });
  }

  @override
  void changeTurn([bool player1Active]) {
    if (player1Active == null) {
      player1Active = randomBool();
    }
    this.setState(() {
      this._state.player1.active = player1Active;
      this._state.player2.active = !player1Active;
    });
  }

  @override
  void takePiece(PlayerState player) {
    this.setState(() {
      player.takenPieces += 1;
    });

    if (player.takenPieces == this._boardConfig.winCount) {
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
