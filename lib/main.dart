import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eleven/app_state.dart';
import 'package:eleven/tabs/game_tab.dart';
import 'package:eleven/tabs/players_tab.dart';
import 'package:eleven/tabs/final_score_tab.dart';

void main() {
  runApp(ElevenScoreKeeper());
}

class ElevenScoreKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChangeNotifierProvider<AppState>(
          create: (context) => AppState(),
          child: MainScreen(),
        )
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
    return Text("qqq");
  }
}