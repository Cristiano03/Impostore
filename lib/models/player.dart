class Player {
  final String name;
  bool isImpostor;
  bool hasSeen;
  bool isAlive;

  Player({
    required this.name,
    this.isImpostor = false,
    this.hasSeen = false,
    this.isAlive = true,
  });
}
