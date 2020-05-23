import 'package:flutter/material.dart';

class Player {
  String name;
  List<int> scores = [];

  Player({@required this.name, this.scores});

  void addScore(score) {
    this.scores.add(score);
  }

  int totalScore() {
    return this.scores.fold(0, (a, b) => a + b);
  }
}