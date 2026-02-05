import 'package:flutter/material.dart';
import '../services/game_manager.dart';

class VotingScreen extends StatefulWidget {
  final GameManager gameManager;
  const VotingScreen({super.key, required this.gameManager});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int _voterIndex = 0;
  String? _selected;

  void _submitVote() {
    final voter = widget.gameManager.players[_voterIndex].name;
    if (_selected == null) return;
    widget.gameManager.recordVote(voter, _selected!);
    setState(() {
      _voterIndex++;
      _selected = null;
    });
  }

  void _finishAndTally() {
    final winner = widget.gameManager.tallyVotes();
    final impostor = widget.gameManager.players
        .firstWhere((p) => p.isImpostor)
        .name;
    final correct = winner == impostor;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(correct ? 'Impostore individuato!' : 'Voto sbagliato'),
        content: Text(
          correct
              ? 'L\'impostore era $impostor. Hai vinto!'
              : 'Il voto ha scelto $winner. L\'impostore era $impostor. Si continua.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // back to game screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_voterIndex >= widget.gameManager.players.length) {
      // all voted
      WidgetsBinding.instance.addPostFrameCallback((_) => _finishAndTally());
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final voter = widget.gameManager.players[_voterIndex];
    final candidates = widget.gameManager.players.map((p) => p.name).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Votazione')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Vota: ${voter.name}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: candidates
                    .map(
                      (c) => RadioListTile<String>(
                        value: c,
                        groupValue: _selected,
                        title: Text(c),
                        onChanged: (v) => setState(() => _selected = v),
                      ),
                    )
                    .toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _selected == null ? null : _submitVote,
              child: const Text('Conferma voto'),
            ),
          ],
        ),
      ),
    );
  }
}
