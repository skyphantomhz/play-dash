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

    return LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth >= 1180;
          return desktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 24,
                      child: _PlayerPanel(
                        name: activePlayer?.name ?? 'Latest Johnson',
                        score: state.game.scores[activePlayer?.id] ??
                            settings.startingScore,
                        accent: const Color(0xFF37D8FF),
                        meta:
                            'S.01  |  Score ${state.game.currentTurnThrows.length + 2}',
                        active: true,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 42,
                      child: _BoardStage(
                          controller: controller,
                          winner: winner,
                          canUndo: canUndo),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 26,
                      child: _ScoreRail(
                        players: state.players,
                        activePlayer: activePlayer,
                        scores: state.game.scores,
                        settings: settings,
                        throws: state.game.currentTurnThrows,
                        winner: winner,
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _PlayerPanel(
                        name: activePlayer?.name ?? 'Latest Johnson',
                        score: state.game.scores[activePlayer?.id] ??
                            settings.startingScore,
                        accent: const Color(0xFF37D8FF),
                        meta:
                            'S.01  |  Score ${state.game.currentTurnThrows.length + 2}',
                        active: true,
                      ),
                      const SizedBox(height: 12),
                      _BoardStage(
                          controller: controller,
                          winner: winner,
                          canUndo: canUndo),
                      const SizedBox(height: 12),
                      _BottomActions(controller: controller, canUndo: canUndo),
                    ],
                  ),
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

  static String formatThrow(DartThrow dartThrow) {
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
}

class _PlayerPanel extends StatelessWidget {
  const _PlayerPanel(
      {required this.name,
      required this.score,
      required this.accent,
      required this.meta,
      this.active = false});

  final String name;
  final int score;
  final Color accent;
  final String meta;
  final bool active;

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
                  name: name, colors: [accent, const Color(0xFF4DA3FF)]),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(meta,
                        style: const TextStyle(
                            color: Color(0xB3FFFFFF), fontSize: 11.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '$score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 66,
                fontWeight: FontWeight.w900,
                letterSpacing: -2,
                shadows: active
                    ? [
                        Shadow(
                            color: accent.withValues(alpha: 0.45),
                            blurRadius: 24)
                      ]
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
              child: Text('S.01  |  Score 5',
                  style: TextStyle(
                      color: Color(0xB3FFFFFF), fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _BoardStage extends StatelessWidget {
  const _BoardStage(
      {required this.controller, required this.winner, required this.canUndo});

  final dynamic controller;
  final Player? winner;
  final bool canUndo;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFF37D8FF),
      secondaryAccent: const Color(0xFFFF4FD8),
      child: Column(
        children: [
          const SectionHeading(
              title: 'Game Screen',
              subtitle:
                  'Tap the board to score. Large centered board with bottom action rail mirrors the reference.'),
          const SizedBox(height: 14),
          InteractiveDartboard(
              enabled: winner == null, onThrow: controller.addThrow),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GlassPanel(
                  radius: 18,
                  blur: 16,
                  background: Colors.white.withValues(alpha: 0.06),
                  borderColor: Colors.white.withValues(alpha: 0.12),
                  glowColor: const Color(0xFF37D8FF),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(children: [
                    const Icon(Icons.undo_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(canUndo ? 'Undo Ready' : 'Undo Locked',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14))
                  ]),
                ),
              ),
              const SizedBox(width: 12),
              GlassPanel(
                radius: 18,
                blur: 16,
                background: Colors.white.withValues(alpha: 0.08),
                borderColor: Colors.white.withValues(alpha: 0.14),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: const Column(children: [
                  Text('60',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 42,
                          letterSpacing: -1.2)),
                  Text('Latest Scored',
                      style:
                          TextStyle(color: Color(0xB3FFFFFF), fontSize: 11.5))
                ]),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: GlassButton(
                      label: 'End Turn',
                      icon: Icons.bolt_rounded,
                      highlight: true,
                      onPressed: controller.resetCurrentTurn)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreRail extends StatelessWidget {
  const _ScoreRail(
      {required this.players,
      required this.activePlayer,
      required this.scores,
      required this.settings,
      required this.throws,
      required this.winner});

  final List<Player> players;
  final Player? activePlayer;
  final Map<String, int> scores;
  final X01MatchSettings settings;
  final List<DartThrow> throws;
  final Player? winner;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFFFF4FD8),
      secondaryAccent: const Color(0xFF8B5CF6),
      child: Column(
        children: [
          for (final player in players.take(4)) ...[
            PanelListTile(
              title: player.name,
              subtitle:
                  player.id == activePlayer?.id ? 'Current Player' : 'Waiting',
              leading: PlayerAvatar(
                  name: player.name,
                  colors: [
                    player.id == activePlayer?.id
                        ? const Color(0xFF37D8FF)
                        : const Color(0xFFFF4FD8),
                    const Color(0xFF8B5CF6)
                  ],
                  radius: 18),
              trailing: ScoreBadge(
                  value: '${scores[player.id] ?? settings.startingScore}',
                  highlight: player.id == activePlayer?.id,
                  large: player.id == activePlayer?.id),
              highlight: player.id == activePlayer?.id,
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
                leading: Icon(Icons.touch_app_rounded, color: Colors.white))
          else
            for (final entry in throws.asMap().entries) ...[
              PanelListTile(
                title: X01GamePage.formatThrow(entry.value),
                subtitle:
                    'Throw ${entry.key + 1} · ${entry.value.segment * entry.value.multiplier} points',
                leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white12,
                    child: Text('${entry.key + 1}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800))),
                trailing: ScoreBadge(
                    value: '${entry.value.segment * entry.value.multiplier}',
                    highlight: entry.key == throws.length - 1),
              ),
              const SizedBox(height: 8),
            ],
          if (winner != null) ...[
            const SizedBox(height: 12),
            PanelListTile(
                title: '${winner!.name} wins',
                subtitle: 'Checkout completed',
                leading: const Icon(Icons.emoji_events_rounded,
                    color: Color(0xFFFFD95B)),
                highlight: true),
          ],
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.controller, required this.canUndo});

  final dynamic controller;
  final bool canUndo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: GlassButton(
                label: 'Undo',
                icon: Icons.undo_rounded,
                onPressed: canUndo ? controller.undo : null)),
        const SizedBox(width: 10),
        Expanded(
            child: GlassButton(
                label: 'End Turn',
                icon: Icons.bolt_rounded,
                highlight: true,
                onPressed: controller.resetCurrentTurn)),
      ],
    );
  }
}
