import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:eleven/app_state.dart';
import 'package:eleven/game_tab.dart';
import 'package:eleven/players_tab.dart';
import 'package:eleven/final_score_tab.dart';

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
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.assignment_ind)),
                  Tab(icon: Icon(Icons.insert_chart)),
                  Tab(icon: Icon(Icons.stars)),
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
      ),
    );
  }
}