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
                                'Large center board with lighter glass and neon accent ring.',
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
                              'Mobile board view uses the same glass-and-neon system.',
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
  const _CricketHero({required this.player, required this.score});

  final Player? player;
  final int score;

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
          const Center(
            child: Text(
              'Marks & points live',
              style: TextStyle(
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
