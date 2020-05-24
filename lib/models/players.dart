class Player {
  final String name;
  List<int> scores;

  Player(this.name, this.scores);

  void addScore(score) {
    this.scores.add(score);
  }

  int totalScore() {
    if (this.scores.isEmpty)
      return 0;
    else
      return this.scores.fold(0, (a, b) => a + b);
  }
}