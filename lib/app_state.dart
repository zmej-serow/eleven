import 'package:flutter/material.dart';
import 'package:eleven/models/players.dart';

class AppState with ChangeNotifier {
  AppState();

  List<Player> _players = [];
  int _currentPlayer = 0;

  List<Player> get getPlayers => _players;

  void addPlayer(Player player) {
    _players.add(player);
    notifyListeners();
  }

  void addScore(int score) {
    _players[_currentPlayer].addScore(score);
    nextPlayer();
  }

  void editScore(Player player, int index, int score) {
    Player pl = _players.firstWhere((element) => element == player);
    pl.scores[index] = score;
    notifyListeners();
  }

  void newGame() {
    _players.forEach((player) {player.scores = [];});
    _currentPlayer = 0;
    notifyListeners();
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
}