import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_settings.dart';
import '../../../shared/models/player.dart';
import '../../../shared/widgets/interactive_dartboard.dart';
import '../application/x01_controller.dart';

class X01GamePage extends ConsumerWidget {
  const X01GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(x01ControllerProvider);
    final controller = ref.read(x01ControllerProvider.notifier);
    final players = state.players;
    final settings = state.settings as X01MatchSettings;
    final winnerId = state.game.winnerPlayerId;
    final activePlayer = _activePlayer(players, state.currentPlayerIndex);
    final winner = _findPlayerById(players, winnerId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('X01 Game'),
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
              Text(
                'Scores',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    ...players.map(
                      (player) {
                        final isActive = winner == null && activePlayer?.id == player.id;
                        final score = state.game.scores[player.id] ?? settings.startingScore;

                        return Card(
                          child: ListTile(
                            leading: Icon(
                              isActive ? Icons.arrow_right_alt : Icons.person_outline,
                            ),
                            title: Text(player.name),
                            subtitle: Text(isActive ? 'Throwing now' : 'Waiting'),
                            trailing: Text(
                              '$score',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Current turn',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    if (state.game.currentTurnThrows.isEmpty)
                      const Card(
                        child: ListTile(
                          title: Text('No darts thrown yet'),
                        ),
                      )
                    else
                      ...state.game.currentTurnThrows.asMap().entries.map(
                        (entry) => Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${entry.key + 1}'),
                            ),
                            title: Text(_formatThrow(entry.value)),
                            subtitle: Text(
                              'Score: ${entry.value.segment * entry.value.multiplier}',
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              InteractiveDartboard(
                enabled: winner == null,
                onThrow: controller.addThrow,
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

  static String _formatThrow(DartThrow dartThrow) {
    if (dartThrow.segment == 0 || dartThrow.multiplier == 0) {
      return 'Miss';
    }

    if (dartThrow.segment == 25) {
      if (dartThrow.multiplier == 2) {
        return 'Bull';
      }

      return 'Outer Bull';
    }

    switch (dartThrow.multiplier) {
      case 1:
        return 'Single ${dartThrow.segment}';
      case 2:
        return 'Double ${dartThrow.segment}';
      case 3:
        return 'Triple ${dartThrow.segment}';
      default:
        return '${dartThrow.multiplier}x ${dartThrow.segment}';
    }
  }
}
