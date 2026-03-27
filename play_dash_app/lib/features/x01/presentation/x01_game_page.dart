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
      title: 'X01 Match',
      subtitle:
          'The match screen now uses a split glass dashboard: dart input on one side, live scores and turn state on the other, with tighter glow and cleaner contrast.',
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
          StatusPill(
              label: 'Target ${settings.startingScore}',
              icon: Icons.flag_outlined),
          StatusPill(
              label: '${state.game.currentTurnThrows.length}/3 darts',
              icon: Icons.sports_martial_arts_outlined),
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
                Text('X01 Game',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  winner == null
                      ? 'Current player: ${activePlayer?.name ?? '—'}'
                      : 'Game finished',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 18),
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
                    MetricCard(
                        label: 'Target score',
                        value: '${settings.startingScore}',
                        icon: Icons.flag_outlined),
                    MetricCard(
                        label: 'Darts this turn',
                        value: '${state.game.currentTurnThrows.length}/3',
                        icon: Icons.ads_click_outlined),
                  ],
                ),
                const SizedBox(height: 20),
                InteractiveDartboard(
                    enabled: winner == null, onThrow: controller.addThrow),
              ],
            ),
          );

          final scorePanel = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 28 : 22),
            radius: 32,
            blur: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeading(
                  title: 'Live scoring',
                  subtitle:
                      'Player cards, current-turn history, and quick actions remain visible together so the match state can be read in one glance.',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilledButton.icon(
                          onPressed: canUndo ? controller.undo : null,
                          icon: const Icon(Icons.undo),
                          label: const Text('Undo')),
                      if (state.game.currentTurnThrows.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                            onPressed: winner == null
                                ? controller.resetCurrentTurn
                                : null,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Clear turn')),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...state.players.map((player) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ScoreCard(
                        player: player,
                        isActive:
                            winner == null && player.id == activePlayer?.id,
                        score: state.game.scores[player.id] ??
                            settings.startingScore,
                      ),
                    )),
                const SizedBox(height: 8),
                const SectionHeading(
                    title: 'Current turn',
                    subtitle:
                        'Recent darts are grouped into a compact list for quick confirmation.'),
                const SizedBox(height: 14),
                if (state.game.currentTurnThrows.isEmpty)
                  const FrostPanel(
                      radius: 24,
                      child: ListTile(title: Text('No darts thrown yet')))
                else
                  ...state.game.currentTurnThrows.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FrostPanel(
                            radius: 22,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: ListTile(
                              leading:
                                  CircleAvatar(child: Text('${entry.key + 1}')),
                              title: Text(_formatThrow(entry.value)),
                              subtitle: Text(
                                  'Score: ${entry.value.segment * entry.value.multiplier}'),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );

          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 6, child: boardPanel),
                  const SizedBox(width: 20),
                  Expanded(flex: 5, child: scorePanel)
                ])
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      boardPanel,
                      const SizedBox(height: 20),
                      scorePanel
                    ]);
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

  static String _formatThrow(DartThrow dartThrow) {
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

class _ScoreCard extends StatelessWidget {
  const _ScoreCard(
      {required this.player, required this.isActive, required this.score});

  final Player player;
  final bool isActive;
  final int score;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: 26,
      blur: 6,
      backgroundOpacity: isActive ? 0.54 : 0.44,
      highlight: isActive,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white)
                  .withValues(alpha: isActive ? 0.18 : 0.10),
            ),
            child: Icon(
                isActive ? Icons.arrow_right_alt_rounded : Icons.person_outline,
                color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 12),
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
    );
  }
}
