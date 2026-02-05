import 'dart:math';
import '../models/player.dart';

class GameManager {
  List<Player> players = [];
  final List<String> _wordPool = [
    'Gatto',
    'Cane',
    'Spiaggia',
    'Computer',
    'Pizza',
    'Albero',
    'Auto',
    'Orologio',
    'Libro',
    'Scuola',
    'Stella',
    'Neve',
    'Fiume',
    'Montagna',
    'Luna',
    'Sedia',
    'Tavolo',
    'Bicicletta',
    'Televisione',
    'Telefono',
  ];
  late final String word;
  final Random _rnd = Random();

  void setPlayers(List<Player> p) {
    players = p;
  }

  void assignRoles({int impostors = 1}) {
    // clear previous
    for (var pl in players) {
      pl.isImpostor = false;
      pl.hasSeen = false;
      pl.isAlive = true;
    }

    // choose impostors (we only support 1 for now)
    if (players.isNotEmpty) {
      int idx = _rnd.nextInt(players.length);
      players[idx].isImpostor = true;
    }

    // choose a word from pool
    word = _wordPool[_rnd.nextInt(_wordPool.length)];
  }

  Player getNextUnseen(int startIndex) {
    int i = startIndex;
    while (i < players.length && players[i].hasSeen) {
      i++;
    }
    return players[i];
  }

  Player pickRandomNonImpostorStarter() {
    List<Player> nonImpostors = players.where((p) => !p.isImpostor).toList();
    return nonImpostors[_rnd.nextInt(nonImpostors.length)];
  }

  Map<String, String> votes = {};

  void clearVotes() => votes.clear();

  void recordVote(String voter, String voted) {
    votes[voter] = voted;
  }

  String tallyVotes() {
    if (votes.isEmpty) return '';
    final counts = <String, int>{};
    votes.values.forEach((v) => counts[v] = (counts[v] ?? 0) + 1);
    // find max voted
    String winner = counts.keys.first;
    int max = counts[winner]!;
    counts.forEach((k, v) {
      if (v > max) {
        max = v;
        winner = k;
      }
    });
    return winner;
  }
}
