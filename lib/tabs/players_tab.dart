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
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) => appState.switchPlayers(oldIndex, newIndex),
        children: appState.getPlayers
          .asMap()
          .map((index, player) => MapEntry(index, playerCard(index, player)))
          .values
          .toList(),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () async {
                appState.tossCoin();
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Player list shuffled!"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ]
                    );
                  }
                );
              },
              child: Icon(Icons.cached),
            ),
            FloatingActionButton(
              onPressed: () async {
                String name = await newPlayerName(context);
                if (name != "") appState.addPlayer(Player(name, []));
              },
              child: Icon(Icons.person_add),
            )
          ],
        ),
      )
    );
  }

  Widget playerCard(index, player) {
    final appState = Provider.of<AppState>(context);

    return Card(
        key: ValueKey(index),
        child: Row(
          children: [
            Icon(Icons.more_vert),
            Expanded(
                child:
                ListTile(
                  title: Text(
                    player.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                )
            ),
            GestureDetector(
                onTap: () => appState.removePlayer(player.name),
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.delete)
                )
            )
          ],
        )
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