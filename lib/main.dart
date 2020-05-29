import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eleven/app_state.dart';
import 'package:eleven/tabs/game_tab.dart';
import 'package:eleven/tabs/players_tab.dart';
import 'package:eleven/tabs/final_score_tab.dart';

void main() {
  runApp(ChangeNotifierProvider<AppState>(
    create: (context) => AppState(),
    child: ElevenScoreKeeper(),
  ),
  );
}

class ElevenScoreKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<AppState>(context, listen: true).theme,
        home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 10,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.group)),
                  Tab(icon: Icon(Icons.equalizer)),
                  Tab(icon: Icon(Icons.grade)),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PlayersSelection(),
            Scores(),
            FinalScores(),
          ],
        ),
        drawer: Drawer(
            child: preferencesDrawer()
        ),
      ),
    );
  }

  Widget preferencesDrawer() {
    final appState = Provider.of<AppState>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text("Preferences", style: TextStyle(color: Colors.white, fontSize: 30)),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/preferences.jpg"),
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter
                )
            ),
          ),
          ListTile(
            leading: Icon(Icons.format_size),
            title: Slider(
              value: appState.prefs['textSize'] ?? 40,
              min: 18,
              max: 40,
              onChanged: (size) => Provider.of<AppState>(context, listen: false).themeTextSize(size),
            ),
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text("Main color"),
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text("Secondary color"),
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text("Interface language"),
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}