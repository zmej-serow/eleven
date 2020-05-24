import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eleven/app_state.dart';
import 'package:eleven/models/players.dart';

class FinalScores extends StatefulWidget {
  @override
  FinalScoresState createState() => FinalScoresState();
}

class FinalScoresState extends State<FinalScores> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Column(
      children: [
        for (var player in appState.getPlayers) Expanded(
            child: finalScore(player)
        )
      ],
    );
  }

  Widget finalScore(Player player) {
    return Row(
      children: [
        Text(player.name),
        Text(player.totalScore().toString())
      ],
    );
  }
}
