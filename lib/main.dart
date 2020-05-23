import 'package:flutter/material.dart';

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
      home: DefaultTabController(
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
      ),
    );
  }
}