class Player {
  final String name;
  List<int> scores;

  Player(this.name, this.scores);

  void addScore(score) {
    this.scores.add(score);
  }

  int totalScore() {
    return this.scores.fold(0, (a, b) => a + b);
  }
}