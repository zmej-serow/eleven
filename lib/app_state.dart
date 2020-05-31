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
  ThemeData _themeData;
  Map _prefs = {
    "textSize": 25.0,
    "brightness": Brightness.dark,
    "primaryColor": Color(0xff0277bd),
    "accentColor": Color(0xff42a5f5),
  };

  // getters
  List<Player> get getPlayers => _players;
  Map get prefs => _prefs;
  ThemeData get theme => _themeData;

  // methods
  void themeTextSize(double size) {
    _prefs['textSize'] = size;
    _updateTheme();
  }

  void flipDark(s) {
    _prefs['brightness'] = s ? Brightness.dark : Brightness.light;
    _updateTheme();
  }

  void setColor(String kind, c) {
    _prefs[kind] = c;
    _updateTheme();
  }

  void _updateTheme() {
    _themeData = ThemeData(
      brightness: _prefs['brightness'],
      primaryColor: _prefs['primaryColor'],
      accentColor: _prefs['accentColor'],
      textTheme: TextTheme(
        headline5: TextStyle(
            fontSize: _prefs['textSize'],
            fontWeight: FontWeight.bold
        ),
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
      var pr = preferences.getStringList(_spPrefs) ?? [];
      if (pr.isNotEmpty) _prefs = deserialize(pr);
      _updateTheme();
    } else {
      await preferences.setInt(_spCurrentPlayer, _currentPlayer);
      await preferences.setString(_spPlayers, json.encode(_players));
      await preferences.setStringList(_spPrefs, serialize(_prefs));
    }
    notifyListeners();
  }

  Map deserialize(List<String> prefs) {
    return {
      'textSize': double.tryParse(prefs[0]),
      'brightness': prefs[1].contains('dark') ? Brightness.dark : Brightness.light,
      'primaryColor': Color(int.tryParse(prefs[2])),
      'accentColor': Color(int.tryParse(prefs[3])),
    };
  }

  List<String> serialize(Map prefs) {
    return [
      prefs['textSize'].toString(),
      prefs['brightness'].toString(),
      prefs['primaryColor'].value.toString(),
      prefs['accentColor'].value.toString(),
    ];
  }
}