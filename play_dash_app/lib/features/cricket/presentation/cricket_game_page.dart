import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/player.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/interactive_dartboard.dart';
import '../application/cricket_controller.dart';

class CricketGamePage extends ConsumerWidget {
  const CricketGamePage({super.key});

  static const List<int> _segments = <int>[20, 19, 18, 17, 16, 15, 25];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cricketControllerProvider);
    final controller = ref.read(cricketControllerProvider.notifier);
    final canUndo = ref.watch(cricketCanUndoProvider);
    final players = state.players;
    final winnerId = state.game.winnerPlayerId;
    final activePlayer = _activePlayer(players, state.currentPlayerIndex);
    final winner = _findPlayerById(players, winnerId);

    return AppShell(
      title: 'Cricket match',
      subtitle:
          'The redesigned cricket screen balances dart input with a denser scoreboard, making marks and points easier to scan in one glance.',
      actions: [
        IconButton(
          onPressed: canUndo ? controller.undo : null,
          icon: const Icon(Icons.undo),
          tooltip: 'Undo',
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1100;

          final boardPanel = GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    MetricCard(
                      label: winner == null ? 'Current player' : 'Winner',
                      value: winner?.name ?? activePlayer?.name ?? '—',
                      icon: winner == null
                          ? Icons.person_pin_circle_outlined
                          : Icons.emoji_events_outlined,
                      highlight: true,
                    ),
                    MetricCard(
                      label: 'Scoring numbers',
                      value: '20 to Bull',
                      icon: Icons.filter_7_outlined,
                    ),
                    MetricCard(
                      label: 'Undo ready',
                      value: canUndo ? 'Yes' : 'No',
                      icon: Icons.history_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                InteractiveDartboard(
                  enabled: winner == null,
                  onThrow: controller.addThrow,
                ),
                const SizedBox(height: 8),
                Text(
                  'Each tap records one dart and advances to the next player.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          );

          final scorePanel = GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  title: 'Cricket scoreboard',
                  subtitle:
                      'Grouped marks, active-player emphasis, and persistent scoring chips make the state easier to parse under pressure.',
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: canUndo ? controller.undo : null,
                  icon: const Icon(Icons.undo),
                  label: const Text('Undo'),
                ),
                const SizedBox(height: 18),
                ...players.map((player) {
                  final isActive =
                      winner == null && activePlayer?.id == player.id;
                  final marks =
                      state.game.marks[player.id] ?? const <int, int>{};
                  final score = state.game.scores[player.id] ?? 0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      color: isActive
                          ? Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withValues(alpha: 0.76)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(isActive
                                    ? Icons.arrow_right_alt_rounded
                                    : Icons.person_outline),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    player.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                Text(
                                  '$score pts',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                                  backgroundColor: value >= 3
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primaryContainer
                                      : null,
                                  label: Text(
                                    '${segment == 25 ? 'Bull' : segment}: ${'X' * value}${value == 0 ? '—' : ''}',
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );

          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: boardPanel),
                    const SizedBox(width: 20),
                    Expanded(flex: 5, child: scorePanel),
                  ],
                )
              : Column(
                  children: [
                    boardPanel,
                    const SizedBox(height: 20),
                    scorePanel,
                  ],
                );
        },
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
