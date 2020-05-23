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
        child: MyHomePage(),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.assignment_ind)),
              Tab(icon: Icon(Icons.insert_chart)),
              Tab(icon: Icon(Icons.stars)),
            ],
          ),
          title: Text('Eleven!'),
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