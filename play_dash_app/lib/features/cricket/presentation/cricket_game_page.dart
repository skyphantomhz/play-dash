import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_state.dart';
import '../../../shared/models/player.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/game_over_dialog.dart';
import '../../../shared/widgets/interactive_dartboard.dart';
import '../application/cricket_controller.dart';

String cricketFormatThrow(DartThrow dartThrow) {
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

class CricketGamePage extends ConsumerStatefulWidget {
  const CricketGamePage({super.key});

  static const List<int> segments = <int>[20, 19, 18, 17, 16, 15, 25];

  @override
  ConsumerState<CricketGamePage> createState() => _CricketGamePageState();
}

class _CricketGamePageState extends ConsumerState<CricketGamePage> {
  bool _dialogVisible = false;
  late final ProviderSubscription<CricketMatchState> _winnerSubscription;

  @override
  void initState() {
    super.initState();
    _winnerSubscription = ref.listenManual<CricketMatchState>(
        cricketControllerProvider, (previous, next) {
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
            statLabel: 'Final Cricket Score',
            statValue: '${next.game.scores[winner.id] ?? 0} points',
            onRematch: () async {
              ref.read(cricketControllerProvider.notifier).rematch();
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
    final state = ref.watch(cricketControllerProvider);
    final controller = ref.read(cricketControllerProvider.notifier);
    final canUndo = ref.watch(cricketCanUndoProvider);
    final activePlayer = _activePlayer(state.players, state.currentPlayerIndex);
    final winner = _findPlayerById(state.players, state.game.winnerPlayerId);
    final throwHistory = controller.throwHistory;
    final currentTurnThrows = controller.currentTurnThrows;
    final latestThrow = throwHistory.isEmpty ? null : throwHistory.last;
    final latestScore =
        latestThrow == null ? 0 : latestThrow.segment * latestThrow.multiplier;
    final canEndTurn = winner == null && currentTurnThrows.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1180;
        final content = desktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 28,
                    child: _CricketHero(
                      player: activePlayer,
                      score: activePlayer == null
                          ? 0
                          : state.game.scores[activePlayer.id] ?? 0,
                      turnLabel: winner != null
                          ? '${winner.name} wins'
                          : 'Throw ${currentTurnThrows.length + 1} of 3',
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 40,
                    child: NeonCard(
                      accent: const Color(0xFF37D8FF),
                      secondaryAccent: const Color(0xFFFF4FD8),
                      child: Column(
                        children: [
                          SectionHeading(
                            title: winner == null
                                ? 'Cricket Board'
                                : '${winner.name} Wins',
                            subtitle:
                                'Interactive board writes throws into the live Cricket controller.',
                            trailing: ScoreBadge(
                              value: canUndo ? 'Undo Ready' : 'Locked',
                              highlight: canUndo,
                            ),
                          ),
                          const SizedBox(height: 16),
                          InteractiveDartboard(
                            enabled: winner == null,
                            onThrow: controller.addThrow,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: GlassButton(
                                  label: 'Undo',
                                  icon: Icons.undo_rounded,
                                  onPressed: canUndo ? controller.undo : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              _LatestCricketScoreCard(latestScore: latestScore),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GlassButton(
                                  label: 'End Turn',
                                  icon: Icons.bolt_rounded,
                                  highlight: true,
                                  onPressed: canEndTurn
                                      ? controller.resetCurrentTurn
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 28,
                    child: GlassPanel(
                      radius: 20,
                      blur: 22,
                      background: Colors.white.withValues(alpha: 0.06),
                      borderColor: Colors.white.withValues(alpha: 0.05),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          for (final player in state.players) ...[
                            _CricketPlayerCard(
                              player: player,
                              isActive: winner == null &&
                                  activePlayer?.id == player.id,
                              score: state.game.scores[player.id] ?? 0,
                              marks: state.game.marks[player.id] ??
                                  const <int, int>{},
                            ),
                            const SizedBox(height: 10),
                          ],
                          const SizedBox(height: 6),
                          const SectionHeading(
                              title: 'Throw History', compact: true),
                          const SizedBox(height: 10),
                          if (throwHistory.isEmpty)
                            const PanelListTile(
                              title: 'No throws yet',
                              subtitle: 'Tap the board to open the round.',
                              leading: Icon(Icons.touch_app_rounded,
                                  color: Colors.white),
                            )
                          else
                            for (final entry in throwHistory.reversed
                                .take(8)
                                .toList()
                                .asMap()
                                .entries) ...[
                              PanelListTile(
                                title: cricketFormatThrow(entry.value),
                                subtitle:
                                    'Throw ${entry.key + 1} · ${entry.value.segment * entry.value.multiplier} scored',
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
                                  value:
                                      '${entry.value.segment * entry.value.multiplier}',
                                  highlight: entry.key == 0,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CricketHero(
                    player: activePlayer,
                    score: activePlayer == null
                        ? 0
                        : state.game.scores[activePlayer.id] ?? 0,
                    turnLabel: winner != null
                        ? '${winner.name} wins'
                        : 'Throw ${currentTurnThrows.length + 1} of 3',
                  ),
                  const SizedBox(height: 12),
                  NeonCard(
                    accent: const Color(0xFF37D8FF),
                    secondaryAccent: const Color(0xFFFF4FD8),
                    child: Column(
                      children: [
                        SectionHeading(
                          title: winner == null
                              ? 'Cricket Board'
                              : '${winner.name} Wins',
                          subtitle:
                              'Mobile board view uses the same live controller state.',
                          trailing: ScoreBadge(
                            value: canUndo ? 'Undo' : 'Locked',
                            highlight: canUndo,
                          ),
                        ),
                        const SizedBox(height: 14),
                        InteractiveDartboard(
                          enabled: winner == null,
                          compact: true,
                          onThrow: controller.addThrow,
                        ),
                        const SizedBox(height: 12),
                        Row(
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
                                onPressed: canEndTurn
                                    ? controller.resetCurrentTurn
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final player in state.players) ...[
                    _CricketPlayerCard(
                      player: player,
                      isActive: winner == null && activePlayer?.id == player.id,
                      score: state.game.scores[player.id] ?? 0,
                      marks: state.game.marks[player.id] ?? const <int, int>{},
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 10),
                  GlassPanel(
                    radius: 20,
                    blur: 18,
                    background: Colors.white.withValues(alpha: 0.05),
                    borderColor: Colors.white.withValues(alpha: 0.05),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeading(
                            title: 'Throw History', compact: true),
                        const SizedBox(height: 10),
                        if (throwHistory.isEmpty)
                          const Text(
                            'No throws yet',
                            style: TextStyle(color: Colors.white70),
                          )
                        else
                          for (final entry
                              in throwHistory.reversed.take(8).toList()) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '${cricketFormatThrow(entry)} · ${entry.segment * entry.multiplier}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                      ],
                    ),
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
    if (id == null) return null;
    for (final player in players) {
      if (player.id == id) return player;
    }
    return null;
  }
}

class _CricketHero extends StatelessWidget {
  const _CricketHero({
    required this.player,
    required this.score,
    required this.turnLabel,
  });

  final Player? player;
  final int score;
  final String turnLabel;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFF37D8FF),
      secondaryAccent: const Color(0xFF4DA3FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PlayerAvatar(
                name: player?.name ?? 'P',
                colors: const [Color(0xFF37D8FF), Color(0xFF4DA3FF)],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player?.name ?? 'Current Player',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Classic Cricket',
                      style: TextStyle(
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 64,
                  letterSpacing: -2,
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

class _LatestCricketScoreCard extends StatelessWidget {
  const _LatestCricketScoreCard({required this.latestScore});

  final int latestScore;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 18,
      blur: 18,
      background: Colors.white.withValues(alpha: 0.08),
      borderColor: Colors.white.withValues(alpha: 0.14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Column(
        children: [
          Text(
            '$latestScore',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.2,
            ),
          ),
          const Text('Latest Hit',
              style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 11.5)),
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
    return GlassPanel(
      radius: 20,
      blur: 18,
      background: Colors.white.withValues(alpha: isActive ? 0.08 : 0.05),
      borderColor: Colors.white.withValues(alpha: isActive ? 0.07 : 0.04),
      glowColor: isActive ? const Color(0xFF37D8FF) : const Color(0xFFFF4FD8),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              PlayerAvatar(
                name: player.name,
                colors: [
                  isActive ? const Color(0xFF37D8FF) : const Color(0xFFFF4FD8),
                  const Color(0xFF8B5CF6),
                ],
                radius: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isActive ? 'Current Player' : 'Waiting',
                      style: const TextStyle(
                        color: Color(0xB3FFFFFF),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              ScoreBadge(value: '$score', highlight: isActive, large: isActive),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: CricketGamePage.segments.map((segment) {
              final value = (marks[segment] ?? 0).clamp(0, 3);
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white.withValues(alpha: 0.05),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05), width: 0.8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      segment == 25 ? 'Bull' : '$segment',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        final filled = index < value;
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled
                                ? const Color(0xFF9FEFFF)
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
