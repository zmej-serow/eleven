import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:eleven/app_state.dart';
import 'package:eleven/models/players.dart';

class Scores extends StatefulWidget {
  @override
  ScoresState createState() => ScoresState();
}

class ScoresState extends State<Scores> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            for (var player in appState.getPlayers) Expanded(
                child: Text(player.name, textAlign: TextAlign.center)
            )
          ],
        ),
      ),
      body: Row(
        children: [
          for (var player in appState.getPlayers) Expanded(
              child: scoresColumn(player, appState)
          )
        ],
      ),
    );
  }

  Widget scoresColumn(Player player, AppState appState) {
    List<int> scores = player.scores;
    return ListView.builder(
      itemCount: scores.length + 1,
      itemBuilder: (context, index) {
        if (index == scores.length)
          if (appState.isPlayerCurrent(player))
            return ListTile(
                title: FloatingActionButton(
                  onPressed: addScore,
                  child: Icon(Icons.add),
                )
            );
          else
            return null;
        else
          return ListTile(
            title: Text(
              scores[index].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
      },
    );
  }

  void addScore() async {
    int score = await showDialog(
        context: this.context,
        child: addScoreDialog(context)
    );
    if (score != null) {
      Provider.of<AppState>(context, listen: false).addScore(score);
    }
  }

  Widget addScoreDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Enter score"),
      content: TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          decoration: InputDecoration(),
          onSubmitted: (s) => Navigator.of(context).pop(int.tryParse(s))
      ),
      actions: [
        FlatButton(
            child: Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop()
        ),
      ],
    );
  }
}
