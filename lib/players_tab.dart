import 'package:flutter/material.dart';
import 'package:eleven/models/players.dart';

class PlayersSelection extends StatefulWidget {
  final List<Player> players = [];

  @override
  PlayersSelectionState createState() => PlayersSelectionState();
}

class PlayersSelectionState extends State<PlayersSelection> {
  playerNameDialog(BuildContext context) {
    TextEditingController _textFieldController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter player's name"),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() => widget.players.add(Player(name: _textFieldController.text)));
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (var player in widget.players) PlayerNameDisplay(player.name),
            Padding(padding: EdgeInsets.all(10.0)),
            RaisedButton(
              child: Text(
                "Add player",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              onPressed: () => playerNameDialog(context),
            )
          ],
        ),
      ),
    );
  }
}

class PlayerNameDisplay extends StatelessWidget {
  final String name;

  const PlayerNameDisplay(this.name);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.lightBlueAccent),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(name),
      ),
    );
  }
}