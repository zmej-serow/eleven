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
              automaticallyImplyLeading: false,
              pinned: true,
              backgroundColor: Theme.of(context).accentColor,
              titleSpacing: 0,
              title: Row(
                children: [
                  for (var player in appState.getPlayers) Expanded(
                      child: Text(
                          player.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
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
                              child: scoresColumn(player))
                        ]
                    )
                )
            )
          ]
      );
  }

  Widget scoresColumn(Player player) {
    final appState = Provider.of<AppState>(context);
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
            onLongPress: () => editScore(player, index, scores[index]),
            title: Text(
                scores[index].toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
            ),
          );
      },
    );
  }

  void editScore(Player player, int index, int oldScore) async {
    int newScore = await showDialog(
        context: this.context,
        child: scoreDialog(context, oldScore)
    );
    if (newScore != null) {
      Provider.of<AppState>(context, listen: false).editScore(player, index, newScore);
    }
  }

  void addScore() async {
    int score = await showDialog(
        context: this.context,
        child: scoreDialog(context, null)
    );
    if (score != null) {
      Provider.of<AppState>(context, listen: false).addScore(score);
    }
  }

  int parseInput(input) {
    return input.contains(RegExp(r"\d"))
        ? input.split("*").fold(1, (a, b) => a * (int.tryParse(b) ?? 1))
        : null;
  }

  Widget scoreDialog(BuildContext context, int score) {
    String dialogText = score == null ? "Enter score" : "Edit score";
    TextEditingController initialValue = score == null ? null : TextEditingController(text: score.toString());

    return AlertDialog(
      title: Text(dialogText),
      content: TextField(
          controller: initialValue,
          autofocus: true,
          keyboardType: TextInputType.phone,
          inputFormatters: [WhitelistingTextInputFormatter(RegExp(r"\d|\*"))],
          decoration: InputDecoration(),
          onSubmitted: (input) => Navigator.of(context).pop(parseInput(input))
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
