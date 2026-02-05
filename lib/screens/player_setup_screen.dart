import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/game_manager.dart';
import 'role_reveal_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  int _count = 3;
  final List<TextEditingController> _controllers = [];
  final GameManager _gm = GameManager();

  @override
  void initState() {
    super.initState();
    _ensureControllers();
  }

  void _ensureControllers() {
    while (_controllers.length < _count) {
      _controllers.add(TextEditingController());
    }
    while (_controllers.length > _count) {
      _controllers.removeLast();
    }
    setState(() {});
  }

  bool get _canStart {
    for (int i = 0; i < _count; i++) {
      if (_controllers[i].text.trim().isEmpty) return false;
    }
    return true;
  }

  void _startGame() {
    final players = List.generate(
      _count,
      (i) => Player(name: _controllers[i].text.trim()),
    );
    _gm.setPlayers(players);
    _gm.assignRoles();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RoleRevealScreen(gameManager: _gm)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Giocatori')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Numero di giocatori (3 - 24):'),
            Slider(
              value: _count.toDouble(),
              min: 3,
              max: 24,
              divisions: 21,
              label: '$_count',
              onChanged: (v) {
                setState(() {
                  _count = v.toInt();
                  _ensureControllers();
                });
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _count,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: TextField(
                    controller: _controllers[i],
                    decoration: InputDecoration(
                      labelText: 'Giocatore ${i + 1}',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _canStart ? _startGame : null,
              child: const SizedBox(
                width: double.infinity,
                child: Center(child: Text('Inizia')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
