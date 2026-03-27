import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/player.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/interactive_dartboard.dart';
import '../application/cricket_controller.dart';

class CricketGamePage extends ConsumerWidget {
  const CricketGamePage({super.key});

  static const List<int> segments = <int>[20, 19, 18, 17, 16, 15, 25];

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
          'The cricket view now shares the same glass dashboard system while keeping marks and points dense, legible, and easy to scan during a live leg.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          StatusPill(
            label: winner == null
                ? 'Throwing: ${activePlayer?.name ?? '—'}'
                : 'Winner: ${winner.name}',
            icon: Icons.person_pin_circle_outlined,
            tinted: true,
          ),
          const StatusPill(
            label: '20 to Bull scoring',
            icon: Icons.filter_7_outlined,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: canUndo ? controller.undo : null,
          icon: const Icon(Icons.undo_rounded),
          tooltip: 'Undo',
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1180;
          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _CricketBoard(
                        winner: winner,
                        activePlayer: activePlayer,
                        canUndo: canUndo,
                        controller: controller,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: _CricketScores(
                        state: state,
                        winner: winner,
                        activePlayer: activePlayer,
                        canUndo: canUndo,
                        controller: controller,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _CricketBoard(
                      winner: winner,
                      activePlayer: activePlayer,
                      canUndo: canUndo,
                      controller: controller,
                    ),
                    const SizedBox(height: 20),
                    _CricketScores(
                      state: state,
                      winner: winner,
                      activePlayer: activePlayer,
                      canUndo: canUndo,
                      controller: controller,
                    ),
                  ],
                );
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

class _CricketBoard extends StatelessWidget {
  const _CricketBoard({
    required this.winner,
    required this.activePlayer,
    required this.canUndo,
    required this.controller,
  });

  final Player? winner;
  final Player? activePlayer;
  final bool canUndo;
  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 34,
      blur: 9,
      opacity: 0.48,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Throw board',
            subtitle:
                'The same restrained glass framing is used here, while marks scoring stays visually separate from the dart input surface.',
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MetricCard(
                label: winner == null ? 'Current player' : 'Winner',
                value: winner?.name ?? activePlayer?.name ?? '—',
                icon: winner == null
                    ? Icons.person_outline_rounded
                    : Icons.emoji_events_rounded,
                highlight: true,
              ),
              const MetricCard(
                label: 'Scoring numbers',
                value: '20 to Bull',
                icon: Icons.filter_7_rounded,
              ),
              MetricCard(
                label: 'Undo ready',
                value: canUndo ? 'Yes' : 'No',
                icon: Icons.history_rounded,
              ),
            ],
          ),
          const SizedBox(height: 20),
          InteractiveDartboard(
            enabled: winner == null,
            onThrow: controller.addThrow,
          ),
        ],
      ),
    );
  }
}

class _CricketScores extends StatelessWidget {
  const _CricketScores({
    required this.state,
    required this.winner,
    required this.activePlayer,
    required this.canUndo,
    required this.controller,
  });

  final dynamic state;
  final Player? winner;
  final Player? activePlayer;
  final bool canUndo;
  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 34,
      blur: 9,
      opacity: 0.48,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            title: 'Cricket scoreboard',
            subtitle:
                'Marks and totals are packed into card rows so every player can be scanned quickly without losing the glass layout language.',
            trailing: FilledButton.icon(
              onPressed: canUndo ? controller.undo : null,
              icon: const Icon(Icons.undo_rounded),
              label: const Text('Undo'),
            ),
          ),
          const SizedBox(height: 20),
          for (final player in state.players) ...[
            _CricketPlayerCard(
              player: player,
              isActive: winner == null && activePlayer?.id == player.id,
              score: state.game.scores[player.id] ?? 0,
              marks: state.game.marks[player.id] ?? const <int, int>{},
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CricketPlayerCard extends StatelessWidget {
  const _CricketPlayerCard({
    required this.player,
    required this.isActive,
    required this.score,
    required this.marks,
  });

  final Player player;
  final bool isActive;
  final int score;
  final Map<int, int> marks;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: 28,
      blur: 8,
      backgroundOpacity: isActive ? 0.46 : 0.38,
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
                    Text(
                      player.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isActive ? 'Current player' : 'Waiting',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              ScoreBadge(value: '$score', highlight: isActive),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: CricketGamePage.segments.map((segment) {
              final value = (marks[segment] ?? 0).clamp(0, 3);
              return Container(
                width: 88,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  children: [
                    Text(segment == 25 ? 'Bull' : '$segment'),
                    const SizedBox(height: 10),
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
