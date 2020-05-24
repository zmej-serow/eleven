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

    return
      CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.teal,
              titleSpacing: 0,
              title: Row(
                children: [
                  for (var player in appState.getPlayers) Expanded(
                      child: Text(
                        player.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                        ),
                      )
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var player in appState.getPlayers) Expanded(
                        child: scoresColumn(player, appState))
                  ]
                )
              )
            )
          ]
      );
  }

  Widget scoresColumn(Player player, AppState appState) {
    List<int> scores = player.scores;
    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      reverse: true,
      itemCount: scores.length + 1,
      separatorBuilder: (context, index) => Divider(height: 0),
      itemBuilder: (context, index) {
        if (index == scores.length)
          if (appState.isPlayerCurrent(player))
            return ListTile(
                title: FloatingActionButton(
                  mini: true,
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
                fontSize: 28.0,
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
