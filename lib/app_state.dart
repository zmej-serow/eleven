import 'package:flutter/material.dart';
import 'package:eleven/models/players.dart';

class AppState with ChangeNotifier {
  AppState();

  List<Player> _players = [];
  int _currentPlayer = 0;

  void addPlayer(Player player) {
    _players.add(player);
    notifyListeners();
  }

  void addScore(int score) {
    _players[_currentPlayer].addScore(score);
    nextPlayer();
  }

  void removePlayer(String playerName) {
    _players.removeWhere((item) => item.name == playerName);
    notifyListeners();
  }

  void nextPlayer() {
    _currentPlayer += 1;
    if (_currentPlayer == _players.length) _currentPlayer = 0;
    notifyListeners();
  }

  bool isPlayerCurrent(Player player) {
    return _players.indexOf(player) == _currentPlayer;
  }

  List<Player> get getPlayers => _players;
}