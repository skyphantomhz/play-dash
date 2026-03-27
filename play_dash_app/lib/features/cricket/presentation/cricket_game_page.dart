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
    final activePlayer = _activePlayer(state.players, state.currentPlayerIndex);
    final winner = _findPlayerById(state.players, state.game.winnerPlayerId);

    return AppShell(
      title: 'Cricket match',
      subtitle:
          'The cricket screen was rebuilt to pair the interactive dartboard with a denser scoreboard column, preserving fast mark reading and cleaner active-player emphasis.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          StatusPill(
              label: winner == null
                  ? 'Throwing: ${activePlayer?.name ?? '—'}'
                  : 'Winner: ${winner.name}',
              icon: Icons.person_pin_circle_outlined,
              tinted: true),
          const StatusPill(
              label: '20 → Bull scoring', icon: Icons.filter_7_outlined),
        ],
      ),
      actions: [
        IconButton(
            onPressed: canUndo ? controller.undo : null,
            icon: const Icon(Icons.undo),
            tooltip: 'Undo'),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1100;
          final boardPanel = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 28 : 22),
            radius: 32,
            blur: 8,
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
                            ? Icons.person_outline
                            : Icons.emoji_events_outlined,
                        highlight: true),
                    const MetricCard(
                        label: 'Scoring numbers',
                        value: '20 to Bull',
                        icon: Icons.filter_7_outlined),
                    MetricCard(
                        label: 'Undo ready',
                        value: canUndo ? 'Yes' : 'No',
                        icon: Icons.history_outlined),
                  ],
                ),
                const SizedBox(height: 20),
                InteractiveDartboard(
                    enabled: winner == null, onThrow: controller.addThrow),
              ],
            ),
          );

          final scores = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 28 : 22),
            radius: 32,
            blur: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeading(
                  title: 'Cricket scoreboard',
                  subtitle:
                      'Marks and points are arranged in vertically stacked cards so each player remains easy to scan during a live leg.',
                  trailing: FilledButton.icon(
                      onPressed: canUndo ? controller.undo : null,
                      icon: const Icon(Icons.undo),
                      label: const Text('Undo')),
                ),
                const SizedBox(height: 20),
                ...state.players.map((player) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CricketCard(
                        player: player,
                        isActive:
                            winner == null && activePlayer?.id == player.id,
                        score: state.game.scores[player.id] ?? 0,
                        marks:
                            state.game.marks[player.id] ?? const <int, int>{},
                      ),
                    )),
              ],
            ),
          );

          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 6, child: boardPanel),
                  const SizedBox(width: 20),
                  Expanded(flex: 5, child: scores)
                ])
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [boardPanel, const SizedBox(height: 20), scores]);
        },
      ),
    );
  }

  static Player? _activePlayer(List<Player> players, int index) =>
      players.isEmpty ? null : players[index.clamp(0, players.length - 1)];

  static Player? _findPlayerById(List<Player> players, String? id) {
    if (id == null) return null;
    for (final player in players) {
      if (player.id == id) return player;
    }
    return null;
  }
}

class _CricketCard extends StatelessWidget {
  const _CricketCard(
      {required this.player,
      required this.isActive,
      required this.score,
      required this.marks});

  final Player player;
  final bool isActive;
  final int score;
  final Map<int, int> marks;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: 26,
      blur: 6,
      backgroundOpacity: isActive ? 0.54 : 0.44,
      highlight: isActive,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(player.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(isActive ? 'Current player' : 'Waiting',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
                  ],
                ),
              ),
              Text('$score',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: CricketGamePage._segments.map((segment) {
              final value = (marks[segment] ?? 0).clamp(0, 3);
              return Container(
                width: 86,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withValues(alpha: 0.08),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.10)),
                ),
                child: Column(
                  children: [
                    Text(segment == 25 ? 'Bull' : '$segment',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final filled = index < value;
                        return Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white.withValues(alpha: 0.12),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
