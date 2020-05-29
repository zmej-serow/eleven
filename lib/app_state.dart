import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:eleven/models/players.dart';

class AppState with ChangeNotifier {
  AppState() {
    _load();
  }

  // defaults
  List<Player> _players = [];
  int _currentPlayer = 0;
  Map _prefs = {};

  static Map _defaultPrefs = {
    "textSize": 25.0,
    "brightness": Brightness.dark,
    "primaryColor": Colors.lightBlue[800],
    "accentColor": Colors.cyan[600],
  };
  ThemeData _themeData = ThemeData(
    brightness: _defaultPrefs['brightness'],
    primaryColor: _defaultPrefs['primaryColor'],
    accentColor: _defaultPrefs['accentColor'],
    textTheme: TextTheme(
      headline5: TextStyle(
          fontSize: _defaultPrefs['textSize'],
          fontWeight: FontWeight.bold
      ),
    ),
  );

  // getters
  List<Player> get getPlayers => _players;
  Map get prefs => _prefs;
  ThemeData get theme => _themeData;

  // methods
  void themeTextSize(double size) {
    _prefs['textSize'] = size;
    _themeData = _themeData.copyWith(
      textTheme: TextTheme(
        headline5: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
      ),
    );
    _save();
  }

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

  // shared preferences
  void _load() => _store(load: true);
  void _save() => _store();
  void _store({bool load = false}) async {
    const String _spCurrentPlayer = 'elevenCurrentPlayer';
    const String _spPlayers = 'elevenPlayers';
    const String _spPrefs = 'elevenPreferences';
    final preferences = await SharedPreferences.getInstance();

    if (load) {
      _currentPlayer = preferences.getInt(_spCurrentPlayer) ?? 0;
      var ps = json.decode(preferences.getString(_spPlayers) ?? "{}");
      _players = ps.isEmpty
          ? []
          : List<Player>.from(ps.map((i) => Player.fromJson(i)));
      var pr = preferences.getString(_spPrefs) ?? "";
      _prefs = pr.isEmpty
          ? _defaultPrefs
          : deserialized(pr);
    } else {
      await preferences.setInt(_spCurrentPlayer, _currentPlayer);
      await preferences.setString(_spPlayers, json.encode(_players));
      await preferences.setString(_spPrefs, _prefs.toString());
    }
    notifyListeners();
  }

  Map deserialized(String prefs) {
    // {textSize: 31.966159119897963, brightness: Brightness.dark, primaryColor: Color(0xff0277bd), accentColor: Color(0xff00acc1)}
    print("incoming prefs: ${prefs.runtimeType} / ${prefs}");

    return _defaultPrefs;
  }
}