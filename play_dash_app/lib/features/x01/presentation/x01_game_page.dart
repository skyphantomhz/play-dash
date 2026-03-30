import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_settings.dart';
import '../../../shared/models/match_state.dart';
import '../../../shared/models/player.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/game_over_dialog.dart';
import '../../../shared/widgets/interactive_dartboard.dart';
import '../application/x01_controller.dart';

String x01FormatThrow(DartThrow dartThrow) {
  if (dartThrow.segment == 25) {
    return dartThrow.multiplier == 2 ? 'Bull' : 'Outer Bull';
  }
  if (dartThrow.segment == 0 || dartThrow.multiplier == 0) {
    return 'Miss';
  }
  return switch (dartThrow.multiplier) {
    1 => 'Single ${dartThrow.segment}',
    2 => 'Double ${dartThrow.segment}',
    3 => 'Triple ${dartThrow.segment}',
    _ => '${dartThrow.multiplier}x ${dartThrow.segment}',
  };
}

class X01GamePage extends ConsumerStatefulWidget {
  const X01GamePage({super.key});

  @override
  ConsumerState<X01GamePage> createState() => _X01GamePageState();
}

class _X01GamePageState extends ConsumerState<X01GamePage> {
  bool _dialogVisible = false;
  late final ProviderSubscription<X01MatchState> _winnerSubscription;

  @override
  void initState() {
    super.initState();
    _winnerSubscription = ref.listenManual<X01MatchState>(x01ControllerProvider,
        (previous, next) {
      final winnerChanged =
          previous?.game.winnerPlayerId != next.game.winnerPlayerId;
      if (!winnerChanged ||
          next.game.winnerPlayerId == null ||
          _dialogVisible) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted || _dialogVisible) {
          return;
        }

        final winner = _findPlayerById(next.players, next.game.winnerPlayerId);
        if (winner == null) {
          return;
        }

        _dialogVisible = true;
        await showDialog<void>(
          context: context,
          useRootNavigator: true,
          barrierDismissible: false,
          builder: (dialogContext) => GameOverDialog(
            winnerName: winner.name,
            statLabel: 'Checkout Score',
            statValue: '${next.game.scores[winner.id] ?? 0} remaining',
            onRematch: () async {
              ref.read(x01ControllerProvider.notifier).rematch();
            },
          ),
        );
        _dialogVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _winnerSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(x01ControllerProvider);
    final controller = ref.read(x01ControllerProvider.notifier);
    final canUndo = ref.watch(x01CanUndoProvider);
    final settings = state.settings as X01MatchSettings;
    final activePlayer = _activePlayer(state.players, state.currentPlayerIndex);
    final winner = _findPlayerById(state.players, state.game.winnerPlayerId);
    final throwHistory = controller.throwHistory;
    final latestThrow = throwHistory.isEmpty ? null : throwHistory.last;
    final latestScore =
        latestThrow == null ? 0 : latestThrow.segment * latestThrow.multiplier;

    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1180;
        final content = desktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 24,
                    child: _PlayerPanel(
                      name: activePlayer?.name ?? 'No Player',
                      score: state.game.scores[activePlayer?.id] ??
                          settings.startingScore,
                      accent: const Color(0xFF37D8FF),
                      meta:
                          '${settings.startingScore}  |  ${settings.doubleOut ? 'Double Out' : 'Single Out'}',
                      turnLabel: winner != null
                          ? '${winner.name} wins'
                          : 'Throw ${state.game.currentTurnThrows.length + 1} of 3',
                      active: winner == null,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 42,
                    child: RepaintBoundary(
                      child: _BoardStage(
                        controller: controller,
                        winner: winner,
                        canUndo: canUndo,
                        latestScore: latestScore,
                        canEndTurn: winner == null &&
                            state.game.currentTurnThrows.isNotEmpty,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 26,
                    child: _ScoreRail(
                      players: state.players,
                      activePlayer: activePlayer,
                      scores: state.game.scores,
                      settings: settings,
                      throws: throwHistory.reversed.toList(),
                      winner: winner,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PlayerPanel(
                    name: activePlayer?.name ?? 'No Player',
                    score: state.game.scores[activePlayer?.id] ??
                        settings.startingScore,
                    accent: const Color(0xFF37D8FF),
                    meta:
                        '${settings.startingScore}  |  ${settings.doubleOut ? 'Double Out' : 'Single Out'}',
                    turnLabel: winner != null
                        ? '${winner.name} wins'
                        : 'Throw ${state.game.currentTurnThrows.length + 1} of 3',
                    active: winner == null,
                    compact: true,
                  ),
                  const SizedBox(height: 12),
                  RepaintBoundary(
                    child: _BoardStage(
                      controller: controller,
                      winner: winner,
                      canUndo: canUndo,
                      latestScore: latestScore,
                      canEndTurn: winner == null &&
                          state.game.currentTurnThrows.isNotEmpty,
                      compact: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ScoreRail(
                    players: state.players,
                    activePlayer: activePlayer,
                    scores: state.game.scores,
                    settings: settings,
                    throws: throwHistory.reversed.toList(),
                    winner: winner,
                    compact: true,
                  ),
                  const SizedBox(height: 12),
                  _BottomActions(
                    controller: controller,
                    canUndo: canUndo,
                    canEndTurn: winner == null &&
                        state.game.currentTurnThrows.isNotEmpty,
                  ),
                ],
              );

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 8),
          child: content,
        );
      },
    );
  }

  static Player? _activePlayer(List<Player> players, int index) =>
      players.isEmpty ? null : players[index.clamp(0, players.length - 1)];

  static Player? _findPlayerById(List<Player> players, String? id) {
    if (id == null) {
      return null;
    }
    for (final player in players) {
      if (player.id == id) {
        return player;
      }
    }
    return null;
  }
}

class _PlayerPanel extends StatelessWidget {
  const _PlayerPanel({
    required this.name,
    required this.score,
    required this.accent,
    required this.meta,
    required this.turnLabel,
    this.active = false,
    this.compact = false,
  });

  final String name;
  final int score;
  final Color accent;
  final String meta;
  final String turnLabel;
  final bool active;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: accent,
      secondaryAccent: const Color(0xFF4DA3FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PlayerAvatar(
                name: name,
                colors: [accent, const Color(0xFF4DA3FF)],
                radius: compact ? 20 : 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 15 : 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta,
                      style: const TextStyle(
                        color: Color(0xB3FFFFFF),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 56 : 66,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                  shadows: active
                      ? [
                          Shadow(
                            color: accent.withValues(alpha: 0.45),
                            blurRadius: 24,
                          )
                        ]
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              turnLabel,
              style: const TextStyle(
                color: Color(0xB3FFFFFF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardStage extends StatelessWidget {
  const _BoardStage({
    required this.controller,
    required this.winner,
    required this.canUndo,
    required this.latestScore,
    required this.canEndTurn,
    this.compact = false,
  });

  final X01Controller controller;
  final Player? winner;
  final bool canUndo;
  final int latestScore;
  final bool canEndTurn;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFF37D8FF),
      secondaryAccent: const Color(0xFFFF4FD8),
      child: Column(
        children: [
          SectionHeading(
            title: winner == null ? 'Game Screen' : '${winner!.name} Wins',
            subtitle:
                'Tap the board to score. Buttons update from controller state.',
          ),
          const SizedBox(height: 14),
          RepaintBoundary(
            child: InteractiveDartboard(
              enabled: winner == null,
              compact: compact,
              onThrow: controller.addThrow,
            ),
          ),
          const SizedBox(height: 12),
          if (compact)
            Column(
              children: [
                _UndoStateChip(
                    canUndo: canUndo,
                    onPressed: canUndo ? controller.undo : null),
                const SizedBox(height: 10),
                _LatestScoreCard(latestScore: latestScore),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: GlassButton(
                    label: 'End Turn',
                    icon: Icons.bolt_rounded,
                    highlight: true,
                    onPressed: canEndTurn ? controller.resetCurrentTurn : null,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _UndoStateChip(
                    canUndo: canUndo,
                    onPressed: canUndo ? controller.undo : null,
                  ),
                ),
                const SizedBox(width: 12),
                _LatestScoreCard(latestScore: latestScore),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassButton(
                    label: 'End Turn',
                    icon: Icons.bolt_rounded,
                    highlight: true,
                    onPressed: canEndTurn ? controller.resetCurrentTurn : null,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _UndoStateChip extends StatelessWidget {
  const _UndoStateChip({required this.canUndo, required this.onPressed});

  final bool canUndo;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      label: canUndo ? 'Undo Ready' : 'Undo Locked',
      icon: Icons.undo_rounded,
      onPressed: onPressed,
    );
  }
}

class _LatestScoreCard extends StatelessWidget {
  const _LatestScoreCard({required this.latestScore});

  final int latestScore;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 18,
      blur: 16,
      background: Colors.white.withValues(alpha: 0.08),
      borderColor: Colors.white.withValues(alpha: 0.05),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Text(
            '$latestScore',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 42,
              letterSpacing: -1.2,
            ),
          ),
          const Text(
            'Latest Scored',
            style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

class _ScoreRail extends StatelessWidget {
  const _ScoreRail({
    required this.players,
    required this.activePlayer,
    required this.scores,
    required this.settings,
    required this.throws,
    required this.winner,
    this.compact = false,
  });

  final List<Player> players;
  final Player? activePlayer;
  final Map<String, int> scores;
  final X01MatchSettings settings;
  final List<DartThrow> throws;
  final Player? winner;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFFFF4FD8),
      secondaryAccent: const Color(0xFF8B5CF6),
      child: Column(
        children: [
          for (final player in players.take(compact ? players.length : 8)) ...[
            PanelListTile(
              title: player.name,
              subtitle: player.id == winner?.id
                  ? 'Winner'
                  : player.id == activePlayer?.id
                      ? 'Current Player'
                      : 'Waiting',
              leading: PlayerAvatar(
                name: player.name,
                colors: [
                  player.id == activePlayer?.id
                      ? const Color(0xFF37D8FF)
                      : const Color(0xFFFF4FD8),
                  const Color(0xFF8B5CF6),
                ],
                radius: 18,
              ),
              trailing: ScoreBadge(
                value: '${scores[player.id] ?? settings.startingScore}',
                highlight:
                    player.id == activePlayer?.id || player.id == winner?.id,
                large: player.id == activePlayer?.id,
              ),
              highlight:
                  player.id == activePlayer?.id || player.id == winner?.id,
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          const SectionHeading(title: 'Throw History', compact: true),
          const SizedBox(height: 10),
          if (throws.isEmpty)
            const PanelListTile(
              title: 'No throws yet',
              subtitle: 'Tap the board to open the round.',
              leading: Icon(Icons.touch_app_rounded, color: Colors.white),
            )
          else
            for (final entry in throws.take(8).toList().asMap().entries) ...[
              PanelListTile(
                title: x01FormatThrow(entry.value),
                subtitle:
                    'Visit ${entry.key + 1} · ${entry.value.segment * entry.value.multiplier} points',
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white12,
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                trailing: ScoreBadge(
                  value: '${entry.value.segment * entry.value.multiplier}',
                  highlight: entry.key == 0,
                ),
              ),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.controller,
    required this.canUndo,
    required this.canEndTurn,
  });

  final X01Controller controller;
  final bool canUndo;
  final bool canEndTurn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassButton(
            label: 'Undo',
            icon: Icons.undo_rounded,
            onPressed: canUndo ? controller.undo : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GlassButton(
            label: 'End Turn',
            icon: Icons.bolt_rounded,
            highlight: true,
            onPressed: canEndTurn ? controller.resetCurrentTurn : null,
          ),
        ),
      ],
    );
  }
}
