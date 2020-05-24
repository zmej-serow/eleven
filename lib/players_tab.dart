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

    return Scaffold(
      body: ListView.separated(
          itemCount: appState.getPlayers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                appState.getPlayers[index].name,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.delete),
              onTap: () =>
                  appState.removePlayer(appState.getPlayers[index].name),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(height: 0, thickness: 1);
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createPlayer,
        child: Icon(Icons.person_add),
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