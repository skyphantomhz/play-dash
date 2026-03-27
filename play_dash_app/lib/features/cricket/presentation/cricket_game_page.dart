import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/player.dart';
import '../../../shared/widgets/interactive_dartboard.dart';
import '../application/cricket_controller.dart';

class CricketGamePage extends ConsumerWidget {
  const CricketGamePage({super.key});

  static const List<int> _segments = <int>[20, 19, 18, 17, 16, 15, 25];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cricketControllerProvider);
    final controller = ref.read(cricketControllerProvider.notifier);
    final players = state.players;
    final winnerId = state.game.winnerPlayerId;
    final activePlayer = _activePlayer(players, state.currentPlayerIndex);
    final winner = _findPlayerById(players, winnerId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cricket Game'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (winner != null) ...[
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${winner.name} wins!',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                winner == null
                    ? 'Current player: ${activePlayer?.name ?? '—'}'
                    : 'Game finished',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      'Cricket scoreboard',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ...players.map((player) {
                      final isActive = winner == null && activePlayer?.id == player.id;
                      final marks = state.game.marks[player.id] ?? const <int, int>{};
                      final score = state.game.scores[player.id] ?? 0;

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(isActive ? Icons.arrow_right_alt : Icons.person_outline),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      player.name,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                  Text(
                                    '$score pts',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _segments.map((segment) {
                                  final value = marks[segment] ?? 0;
                                  return Chip(
                                    label: Text(
                                      '${segment == 25 ? 'Bull' : segment}: ${'X' * value}${value == 0 ? '—' : ''}',
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Text(
                      'Throw input',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    InteractiveDartboard(
                      enabled: winner == null,
                      onThrow: controller.addThrow,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Each tap records one dart and advances to the next player.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Player? _activePlayer(List<Player> players, int index) {
    if (index < 0 || index >= players.length) {
      return null;
    }

    return players[index];
  }

  static Player? _findPlayerById(List<Player> players, String? playerId) {
    if (playerId == null) {
      return null;
    }

    for (final player in players) {
      if (player.id == playerId) {
        return player;
      }
    }

    return null;
  }
}
