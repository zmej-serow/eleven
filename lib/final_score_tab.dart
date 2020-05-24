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
    List<Player> sortedPlayers = appState.getPlayers;
    sortedPlayers.sort((a, b) => b.totalScore().compareTo(a.totalScore()));
    return Column(
      children: [
        for (var player in sortedPlayers) finalScore(player)
      ],
    );
  }

  Widget finalScore(Player player) {
    return Card(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(player.name,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(player.totalScore().toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
            )
        )
    );
  }
}
