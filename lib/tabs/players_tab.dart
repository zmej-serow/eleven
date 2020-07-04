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
                appState.getPlayers[index].name ?? "",  // ????????
                style: Theme.of(context).textTheme.headline5,
              ),
              trailing: Icon(Icons.delete),
              onTap: () => appState.removePlayer(appState.getPlayers[index].name)
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 0, thickness: 1);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String name = await newPlayerName(context);
          if (name != "") appState.addPlayer(Player(name, []));
        },
        child: Icon(Icons.person_add),
      ),
    );
  }

  Future<String> newPlayerName(BuildContext context) async {
    String playerName;
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter player's name"),
            content: TextField(
                autofocus: true,
                onChanged: (s) => playerName = s,
                decoration: InputDecoration(),
                onSubmitted: (s) => Navigator.of(context).pop(s)
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () => Navigator.of(context).pop(""),
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(playerName),
              ),
            ],
          );
        }
    );
  }
}