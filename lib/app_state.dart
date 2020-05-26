import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:eleven/models/players.dart';

class AppState with ChangeNotifier {
  AppState() {
    _load();
  }

  List<Player> _players = [];
  int _currentPlayer = 0;

  List<Player> get getPlayers => _players;

  void addPlayer(Player player) {
    _players.add(player);
    _save();
  }

  void addScore(int score) {
    _players[_currentPlayer].addScore(score);
    nextPlayer();
  }

  void editScore(Player player, int index, int score) {
    Player pl = _players.firstWhere((element) => element == player);
    pl.scores[index] = score;
    _save();
  }

  void newGame() {
    _players.forEach((player) {player.scores = [];});
    _currentPlayer = 0;
    _save();
  }

  void removePlayer(String playerName) {
    _players.removeWhere((item) => item.name == playerName);
    _save();
  }

  void nextPlayer() {
    _currentPlayer += 1;
    if (_currentPlayer == _players.length) _currentPlayer = 0;
    _save();
  }

  bool isPlayerCurrent(Player player) {
    return _players.indexOf(player) == _currentPlayer;
  }

  void _load() => _store(load: true);
  void _save() => _store();
  void _store({bool load = false}) async {
    const String _sharedPrefsCurrentPlayer = 'elevenCurrentPlayer';
    const String _sharedPrefsPlayers = 'elevenPlayers';
    final prefs = await SharedPreferences.getInstance();

    if (load) {
      _currentPlayer = prefs.getInt(_sharedPrefsCurrentPlayer) ?? 0;
      var ps = json.decode(prefs.getString(_sharedPrefsPlayers) ?? "{}");
      _players = List<Player>.from(ps.map((i) => Player.fromJson(i)));
    } else {
      await prefs.setString(_sharedPrefsPlayers, json.encode(_players));
      await prefs.setInt(_sharedPrefsCurrentPlayer, _currentPlayer);
    }

    notifyListeners();
  }
}