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
            Colors.black12,
            this.playerColor.withAlpha(128),
          ],
        )
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 24.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            "Your Turn",
            style: TextStyle(
              fontSize: 20.0,
              color: this.active ? const Color(0xffeeeeee) : const Color(0x44222222),
            ),
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: (
              List.generate(this.takenCount, (i) => Container(
                decoration: BoxDecoration(color: this.opponentColor),
                padding: EdgeInsets.only(right: 8.0),
                width: 12.0,
                height: 12.0,
              ))
            ),
          ),
        ],
      ),
    );
  }

}