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
    final players = state.players;
    final settings = state.settings as X01MatchSettings;
    final winnerId = state.game.winnerPlayerId;
    final activePlayer = _activePlayer(players, state.currentPlayerIndex);
    final winner = _findPlayerById(players, winnerId);

    return AppShell(
      title: 'X01 Match',
      subtitle:
          'A two-zone layout keeps the interactive board and score state visible together, reducing eye travel during live play.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          StatusPill(
            label: winner == null
                ? 'Throwing: ${activePlayer?.name ?? '—'}'
                : 'Winner: ${winner.name}',
            icon: winner == null
                ? Icons.person_pin_circle_outlined
                : Icons.emoji_events_outlined,
            tinted: true,
          ),
          StatusPill(
            label: 'Target ${settings.startingScore}',
            icon: Icons.flag_outlined,
          ),
        ],
      ),
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
                Text(
                  'X01 Game',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  winner == null
                      ? 'Current player: ${activePlayer?.name ?? '—'}'
                      : 'Game finished',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
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
                      label: 'Target score',
                      value: '${settings.startingScore}',
                      icon: Icons.flag_outlined,
                    ),
                    MetricCard(
                      label: 'Darts this turn',
                      value: '${state.game.currentTurnThrows.length}/3',
                      icon: Icons.sports_martial_arts_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (winner != null) ...[
                  GlassPanel(
                    radius: 24,
                    opacity: 0.52,
                    blur: 16,
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
                  const SizedBox(height: 16),
                ],
                InteractiveDartboard(
                  enabled: winner == null,
                  onThrow: controller.addThrow,
                ),
              ],
            ),
          );

          final scorePanel = GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  title: 'Live scoring',
                  subtitle:
                      'Prominent numbers, active-player emphasis, and concise throw history help players confirm state fast.',
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: canUndo ? controller.undo : null,
                      icon: const Icon(Icons.undo),
                      label: const Text('Undo'),
                    ),
                    if (state.game.currentTurnThrows.isNotEmpty)
                      OutlinedButton.icon(
                        onPressed:
                            winner == null ? controller.resetCurrentTurn : null,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Clear turn'),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                ...players.map((player) {
                  final isActive =
                      winner == null && activePlayer?.id == player.id;
                  final score =
                      state.game.scores[player.id] ?? settings.startingScore;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassPanel(
                      radius: 24,
                      blur: 14,
                      opacity: isActive ? 0.62 : 0.46,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.18)
                                  : Colors.white.withValues(alpha: 0.10),
                            ),
                            child: Icon(
                              isActive
                                  ? Icons.arrow_right_alt_rounded
                                  : Icons.person_outline,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isActive ? 'Throwing now' : 'Waiting',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$score',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                const SectionHeading(
                  title: 'Current turn',
                  subtitle: 'Recent darts are grouped to reduce recall burden.',
                ),
                const SizedBox(height: 12),
                if (state.game.currentTurnThrows.isEmpty)
                  const GlassPanel(
                    radius: 22,
                    blur: 14,
                    child: ListTile(title: Text('No darts thrown yet')),
                  )
                else
                  ...state.game.currentTurnThrows.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GlassPanel(
                            radius: 22,
                            blur: 14,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
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
                      ),
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
