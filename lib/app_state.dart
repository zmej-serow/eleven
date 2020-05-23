import 'package:flutter/material.dart';
import 'package:eleven/models/players.dart';

class AppState with ChangeNotifier {
  AppState();

  List<Player> _players = [];

  void addPlayer(Player player) {
    _players.add(player);
    notifyListeners();
  }

  List<Player> get getPlayers => _players;
}