import 'package:flutter/material.dart';
import '../services/game_manager.dart';
import 'voting_screen.dart';

class GameScreen extends StatefulWidget {
  final GameManager gameManager;
  const GameScreen({super.key, required this.gameManager});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late String starter;

  @override
  void initState() {
    super.initState();
    final p = widget.gameManager.pickRandomNonImpostorStarter();
    starter = p.name;
  }

  void _startVoting() {
    widget.gameManager.clearVotes();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VotingScreen(gameManager: widget.gameManager),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partita')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Giocatore che inizia: $starter',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _startVoting,
              child: const Text('Avvia votazione'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Giocatori presenti:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: widget.gameManager.players
                    .map((p) => ListTile(title: Text(p.name)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
