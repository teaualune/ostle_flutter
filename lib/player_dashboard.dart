import 'package:flutter/material.dart';

class PlayerDashboard extends StatelessWidget {

  final bool active;
  final int takenCount;
  final Color playerColor;
  final Color opponentColor;

  PlayerDashboard({
    this.active,
    this.takenCount,
    this.playerColor,
    this.opponentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
          colors: [
            this.playerColor,
            this.playerColor.withAlpha(200),
          ],
        )
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 24.0,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Your Turn",
            style: TextStyle(
              fontSize: 16.0,
              color: this.active ? const Color(0xffeeeeee) : const Color(0x44222222),
            ),
          ),
          Row(), // TODO taken count
        ],
      ),
    );
  }

}