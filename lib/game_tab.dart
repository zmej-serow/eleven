import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eleven/app_state.dart';

class Scores extends StatefulWidget {
  @override
  ScoresState createState() {
    return ScoresState();
  }
}

class ScoresState extends State<Scores> {
  @override
  Widget build(BuildContext context) {
  final appState = Provider.of<AppState>(context);
    return Row(
      children: [
        for (var player in appState.getPlayers) Expanded(
          child: Text(player.name)
        )
      ],
    );
  }

}
