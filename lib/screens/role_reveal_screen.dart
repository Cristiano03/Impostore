import 'package:flutter/material.dart';
import '../services/game_manager.dart';
import 'game_screen.dart';

class RoleRevealScreen extends StatefulWidget {
  final GameManager gameManager;
  const RoleRevealScreen({super.key, required this.gameManager});

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen> {
  int _current = 0;
  bool _revealed = false;

  void _reveal() {
    setState(() {
      _revealed = true;
    });
  }

  void _pass() {
    widget.gameManager.players[_current].hasSeen = true;
    if (_current + 1 >= widget.gameManager.players.length) {
      // done
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => GameScreen(gameManager: widget.gameManager),
        ),
      );
      return;
    }
    setState(() {
      _current++;
      _revealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.gameManager.players[_current];
    return Scaffold(
      appBar: AppBar(title: const Text('Mostra ruolo/parola')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Giocatore: ${player.name}',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 24),
            if (!_revealed)
              ElevatedButton(onPressed: _reveal, child: const Text('Mostra'))
            else
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      player.isImpostor
                          ? 'Sei l\'impostore'
                          : 'Parola: ${widget.gameManager.word}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _pass, child: const Text('Passa')),
          ],
        ),
      ),
    );
  }
}
