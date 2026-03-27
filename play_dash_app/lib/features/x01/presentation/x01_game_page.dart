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

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1100;
        final mobileScoreDock = _MobileScoreDock(
          title: 'Player scores',
          canUndo: canUndo,
          onUndo: controller.undo,
          child: SizedBox(
            height: 122,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: players.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final player = players[index];
                return SizedBox(
                  width: 180,
                  child: _buildDockScoreCard(
                    context,
                    player: player,
                    isActive: winner == null && activePlayer?.id == player.id,
                    score:
                        state.game.scores[player.id] ?? settings.startingScore,
                  ),
                );
              },
            ),
          ),
        );

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
              ...players.map((player) => _buildScoreCard(
                    context,
                    player: player,
                    isActive: winner == null && activePlayer?.id == player.id,
                    score:
                        state.game.scores[player.id] ?? settings.startingScore,
                  )),
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
          floatingOverlay: wide ? null : mobileScoreDock,
          floatingOverlayHeight: wide ? 0 : 154,
          actions: [
            IconButton(
              onPressed: canUndo ? controller.undo : null,
              icon: const Icon(Icons.undo),
              tooltip: 'Undo',
            ),
          ],
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: boardPanel),
                    const SizedBox(width: 20),
                    Expanded(flex: 5, child: scorePanel),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    boardPanel,
                    const SizedBox(height: 20),
                    scorePanel,
                  ],
                ),
        );
      },
    );
  }

  static Widget _buildScoreCard(
    BuildContext context, {
    required Player player,
    required bool isActive,
    required int score,
  }) {
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
                isActive ? Icons.arrow_right_alt_rounded : Icons.person_outline,
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
  }

  static Widget _buildDockScoreCard(
    BuildContext context, {
    required Player player,
    required bool isActive,
    required int score,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: isActive ? 0.22 : 0.12),
            (isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest)
                .withValues(alpha: isActive ? 0.20 : 0.36),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: isActive ? 0.22 : 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isActive ? Icons.track_changes : Icons.person_outline,
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    player.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '$score',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              isActive ? 'Throwing now' : 'Waiting',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
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

class _MobileScoreDock extends StatelessWidget {
  const _MobileScoreDock({
    required this.title,
    required this.canUndo,
    required this.onUndo,
    required this.child,
  });

  final String title;
  final bool canUndo;
  final VoidCallback onUndo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 26,
      blur: 20,
      opacity: 0.60,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              FilledButton.icon(
                onPressed: canUndo ? onUndo : null,
                icon: const Icon(Icons.undo, size: 18),
                label: const Text('Undo'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
