import 'package:flutter/material.dart';
import 'package:eleven/players_tab.dart';

class Scores extends StatefulWidget {
  @override
  ScoresState createState() {
    return ScoresState();
  }
}

class ScoresState extends State<Scores> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var player in PlayersSelection().players) Expanded(
          child: Text(player.name)
        )
      ],
    );
  }
}