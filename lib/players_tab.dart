import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eleven/app_state.dart';
import 'package:eleven/models/players.dart';

class PlayersSelection extends StatefulWidget {
  @override
  PlayersSelectionState createState() => PlayersSelectionState();
}

class PlayersSelectionState extends State<PlayersSelection> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (var player in appState.getPlayers) PlayerNameDisplay(player.name),
            Padding(padding: EdgeInsets.all(10.0)),
            RaisedButton(
              child: Text(
                "Add player",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              onPressed: createPlayer,
            )
          ],
        ),
      ),
    );
  }

  void createPlayer() async {
    String name = await showDialog(
        context: this.context,
        child: playerNameDialog(context)
    );
    if (name != null && name != "")
      Provider.of<AppState>(context, listen: false).addPlayer(Player(name, []));
  }

  Widget playerNameDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Enter player's name"),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(),
        onSubmitted: (s) => Navigator.of(context).pop(s)
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class PlayerNameDisplay extends StatelessWidget {
  final String name;

  const PlayerNameDisplay(this.name);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.lightBlueAccent),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(name),
            RaisedButton(
                child: Icon(Icons.delete),
                onPressed: () => appState.removePlayer(name),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
            )
          ]
        ),
      ),
    );
  }
}