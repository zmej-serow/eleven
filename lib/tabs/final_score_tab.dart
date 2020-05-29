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
    List<Player> sortedPlayers = [...appState.getPlayers];
    sortedPlayers.sort((a, b) => b.totalScore().compareTo(a.totalScore()));

    return Scaffold(
        body: Column(
          children: [
            for (var player in sortedPlayers) finalScore(player)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: newGame,
          backgroundColor: Colors.red,
          child: Icon(Icons.delete),
        )
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
                      style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(player.totalScore().toString(),
                      style: Theme.of(context).textTheme.headline5,
                  ),
                ]
            )
        )
    );
  }

  void newGame() async {
    bool newGame = await showDialog(
        context: this.context,
        child: newGameDialog(context)
    );
    if (newGame)
      Provider.of<AppState>(context, listen: false).newGame();
  }

  Widget newGameDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure?"),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
