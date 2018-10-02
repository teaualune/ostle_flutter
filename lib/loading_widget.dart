import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xff444444),
        ),
        child: Center(
          child: Text(
            "Loading...",
            style: TextStyle(
              color: Color(0x88dddddd),
              fontSize: 12.0,
            ),
          ),
        ),
      );
  }
}
