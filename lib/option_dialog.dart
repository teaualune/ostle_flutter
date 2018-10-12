import 'dart:async';
import 'package:flutter/material.dart';
import 'ostle_preferences.dart';

class OptionDialog extends StatefulWidget {

  final int index;

  OptionDialog({ Key key, this.index }) : super(key: key);

  @override
  _OptionDialogState createState() => _OptionDialogState(this.index);

  static Future<bool> show(BuildContext context) async {
    int index = await OstlePreferences.getGameConfigIndex();
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => OptionDialog(index: index),
    );
  }
}

class _OptionDialogState extends State<OptionDialog> {

  int index;

  _OptionDialogState(this.index);

  void _setIndex(int newValue) {
    this.setState(() {
      this.index = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Settings'),
      content: SingleChildScrollView(child: ListBody(
        children: <Widget>[
          Text('Theme'),
          Column(children: <Widget>[
            RadioListTile<int>(
              title: Text('Default', style: TextStyle(fontSize: 14.0)),
              value: 0,
              groupValue: this.index,
              onChanged: this._setIndex,
            ),
            RadioListTile<int>(
              title: Text('Mono', style: TextStyle(fontSize: 14.0)),
              value: 1,
              groupValue: this.index,
              onChanged: this._setIndex,
            ),
          ],),
          Padding(padding: EdgeInsets.only(top: 12.0), child: Text('About')),
          Text(
            'An open source game written in SpriteWidget and Flutter. The game Ostle is created by Miyabi Games.',
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      )),
      actions: <Widget>[
        FlatButton(
          child: Text('Save and Restart'),
          onPressed: () {
            OstlePreferences.setGameConfigIndex(index).then((_) {
              Navigator.of(context).pop(true);
            });
          }
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          }
        )
      ],
    );
  }
}
