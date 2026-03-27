import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_settings.dart';
import '../../../shared/models/player.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/interactive_dartboard.dart';
import '../application/x01_controller.dart';

class X01GamePage extends ConsumerWidget {
  const X01GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(x01ControllerProvider);
    final controller = ref.read(x01ControllerProvider.notifier);
    final canUndo = ref.watch(x01CanUndoProvider);
    final settings = state.settings as X01MatchSettings;
    final activePlayer = _activePlayer(state.players, state.currentPlayerIndex);
    final winner = _findPlayerById(state.players, state.game.winnerPlayerId);

    return AppShell(
      title: 'X01 match',
      subtitle:
          'Rebuilt as a dual-panel arena with the dartboard and the live scoring rail always visible. Contrast is stronger, blur is softer, and actions stay close to the score state.',
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
          StatusPill(
            label: 'Target ${settings.startingScore}',
            icon: Icons.flag_outlined,
          ),
          StatusPill(
            label: '${state.game.currentTurnThrows.length}/3 darts',
            icon: Icons.ads_click_outlined,
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
                      child: _BoardColumn(
                        winner: winner,
                        activePlayer: activePlayer,
                        settings: settings,
                        state: state,
                        controller: controller,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: _ScoreColumn(
                        winner: winner,
                        activePlayer: activePlayer,
                        state: state,
                        settings: settings,
                        canUndo: canUndo,
                        controller: controller,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _BoardColumn(
                      winner: winner,
                      activePlayer: activePlayer,
                      settings: settings,
                      state: state,
                      controller: controller,
                    ),
                    const SizedBox(height: 20),
                    _ScoreColumn(
                      winner: winner,
                      activePlayer: activePlayer,
                      state: state,
                      settings: settings,
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

  static String formatThrow(DartThrow dartThrow) {
    if (dartThrow.segment == 25) {
      return dartThrow.multiplier == 2 ? 'Bull' : 'Outer Bull';
    }
    if (dartThrow.segment == 0 || dartThrow.multiplier == 0) return 'Miss';
    return switch (dartThrow.multiplier) {
      1 => 'Single ${dartThrow.segment}',
      2 => 'Double ${dartThrow.segment}',
      3 => 'Triple ${dartThrow.segment}',
      _ => '${dartThrow.multiplier}x ${dartThrow.segment}',
    };
  }
}

class _BoardColumn extends StatelessWidget {
  const _BoardColumn({
    required this.winner,
    required this.activePlayer,
    required this.settings,
    required this.state,
    required this.controller,
  });

  final Player? winner;
  final Player? activePlayer;
  final X01MatchSettings settings;
  final dynamic state;
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
                'The interactive board remains the centerpiece, now framed by cleaner badges and more restrained highlight treatment.',
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
              MetricCard(
                label: 'Starting score',
                value: '${settings.startingScore}',
                icon: Icons.flag_outlined,
              ),
              MetricCard(
                label: 'Current turn',
                value: '${state.game.currentTurnThrows.length}/3',
                icon: Icons.timeline_rounded,
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

class _ScoreColumn extends StatelessWidget {
  const _ScoreColumn({
    required this.winner,
    required this.activePlayer,
    required this.state,
    required this.settings,
    required this.canUndo,
    required this.controller,
  });

  final Player? winner;
  final Player? activePlayer;
  final dynamic state;
  final X01MatchSettings settings;
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
            title: 'Live scoring rail',
            subtitle:
                'Scores, turn history, and quick actions are grouped into one side column for immediate confirmation while throwing.',
            trailing: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: canUndo ? controller.undo : null,
                  icon: const Icon(Icons.undo_rounded),
                  label: const Text('Undo'),
                ),
                OutlinedButton.icon(
                  onPressed: winner == null && state.game.currentTurnThrows.isNotEmpty
                      ? controller.resetCurrentTurn
                      : null,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Clear turn'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final player in state.players) ...[
            _PlayerScoreTile(
              player: player,
              isActive: winner == null && player.id == activePlayer?.id,
              score: state.game.scores[player.id] ?? settings.startingScore,
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 8),
          const SectionHeading(
            title: 'Current turn',
            subtitle: 'Latest throws are shown as compact confirmation cards.',
          ),
          const SizedBox(height: 14),
          if (state.game.currentTurnThrows.isEmpty)
            const PanelListTile(
              title: 'No throws yet',
              subtitle: 'Tap the board to record the first dart.',
              leading: Icon(Icons.sports_martial_arts_outlined),
            )
          else
            for (final entry in state.game.currentTurnThrows.asMap().entries) ...[
              PanelListTile(
                title: X01GamePage.formatThrow(entry.value),
                subtitle:
                    'Throw ${entry.key + 1} · ${entry.value.segment * entry.value.multiplier} points',
                leading: CircleAvatar(child: Text('${entry.key + 1}')),
                trailing: ScoreBadge(
                  value: '${entry.value.segment * entry.value.multiplier}',
                  highlight: entry.key == state.game.currentTurnThrows.length - 1,
                ),
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _PlayerScoreTile extends StatelessWidget {
  const _PlayerScoreTile({
    required this.player,
    required this.isActive,
    required this.score,
  });

  final Player player;
  final bool isActive;
  final int score;

  @override
  Widget build(BuildContext context) {
    return PanelListTile(
      title: player.name,
      subtitle: isActive ? 'Current player' : 'Waiting',
      highlight: isActive,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: (isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.white)
            .withValues(alpha: isActive ? 0.18 : 0.1),
        child: Icon(
          isActive ? Icons.arrow_right_alt_rounded : Icons.person_outline_rounded,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: ScoreBadge(value: '$score', highlight: isActive),
    );
  }
}
