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
      expandChild: true,
      mobileTopTabs: const [
        ShellTab(label: 'Score', route: '/match/x01'),
        ShellTab(label: 'Header', route: '/setup'),
        ShellTab(label: 'Single', route: '/match/x01'),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth >= 1180;
          return desktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 22,
                      child: _PlayerStatusCard(
                        name: activePlayer?.name ?? 'Latest Johnson',
                        score: state.game.scores[activePlayer?.id] ?? settings.startingScore,
                        accent: const Color(0xFF2DB6FF),
                        meta: 'S.01  |  Score ${state.game.currentTurnThrows.length + 2}',
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 44,
                      child: _BoardPanel(
                        controller: controller,
                        winner: winner,
                        canUndo: canUndo,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 24,
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
              : Column(
                  children: [
                    _PlayerStatusCard(
                      name: activePlayer?.name ?? 'Latest Johnson',
                      score: state.game.scores[activePlayer?.id] ?? settings.startingScore,
                      accent: const Color(0xFF2DB6FF),
                      meta: 'S.01  |  Score ${state.game.currentTurnThrows.length + 2}',
                    ),
                    const SizedBox(height: 12),
                    _BoardPanel(controller: controller, winner: winner, canUndo: canUndo),
                    const SizedBox(height: 12),
                    _BottomActions(controller: controller, canUndo: canUndo),
                  ],
                );
        },
      ),
    );
  }

  static Player? _activePlayer(List<Player> players, int index) => players.isEmpty ? null : players[index.clamp(0, players.length - 1)];

  static Player? _findPlayerById(List<Player> players, String? id) {
    if (id == null) return null;
    for (final player in players) {
      if (player.id == id) return player;
    }
    return null;
  }

  static String formatThrow(DartThrow dartThrow) {
    if (dartThrow.segment == 25) return dartThrow.multiplier == 2 ? 'Bull' : 'Outer Bull';
    if (dartThrow.segment == 0 || dartThrow.multiplier == 0) return 'Miss';
    return switch (dartThrow.multiplier) {
      1 => 'Single ${dartThrow.segment}',
      2 => 'Double ${dartThrow.segment}',
      3 => 'Triple ${dartThrow.segment}',
      _ => '${dartThrow.multiplier}x ${dartThrow.segment}',
    };
  }
}

class _PlayerStatusCard extends StatelessWidget {
  const _PlayerStatusCard({required this.name, required this.score, required this.accent, required this.meta});

  final String name;
  final int score;
  final Color accent;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: accent,
      secondaryAccent: const Color(0xFF6E49FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PlayerAvatar(name: name, colors: [accent, const Color(0xFF6E49FF)]),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(meta, style: const TextStyle(color: Color(0xB3E8EDFF), fontSize: 11.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Center(child: Text('$score', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 54, letterSpacing: -2))),
        ],
      ),
    );
  }
}

class _BoardPanel extends StatelessWidget {
  const _BoardPanel({required this.controller, required this.winner, required this.canUndo});

  final dynamic controller;
  final Player? winner;
  final bool canUndo;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFF2DB6FF),
      secondaryAccent: const Color(0xFFFF4BDD),
      child: Column(
        children: [
          const SectionHeading(title: 'Tap scoring to score', subtitle: 'Reduced blur and tighter edge lighting match the design.'),
          const SizedBox(height: 12),
          InteractiveDartboard(enabled: winner == null, onThrow: controller.addThrow),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: ScoreBadge(value: canUndo ? 'Undo Ready' : 'No Undo', highlight: canUndo)),
              const SizedBox(width: 10),
              const Expanded(child: ScoreBadge(value: '60', large: true)),
              const SizedBox(width: 10),
              Expanded(child: ScoreBadge(value: winner == null ? 'Live Turn' : 'Winner', highlight: winner != null)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreRail extends StatelessWidget {
  const _ScoreRail({required this.players, required this.activePlayer, required this.scores, required this.settings, required this.throws, required this.winner});

  final List<Player> players;
  final Player? activePlayer;
  final Map<String, int> scores;
  final X01MatchSettings settings;
  final List<DartThrow> throws;
  final Player? winner;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFFFF4BDD),
      secondaryAccent: const Color(0xFF6E49FF),
      child: Column(
        children: [
          for (final player in players.take(4)) ...[
            PanelListTile(
              title: player.name,
              subtitle: player.id == activePlayer?.id ? 'Current Player' : 'Waiting',
              leading: PlayerAvatar(
                name: player.name,
                colors: [player.id == activePlayer?.id ? const Color(0xFF2DB6FF) : const Color(0xFFFF5A87), const Color(0xFF6E49FF)],
                radius: 18,
              ),
              trailing: ScoreBadge(
                value: '${scores[player.id] ?? settings.startingScore}',
                highlight: player.id == activePlayer?.id,
                large: player.id == activePlayer?.id,
              ),
              highlight: player.id == activePlayer?.id,
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          const SectionHeading(title: 'Throw History', compact: true),
          const SizedBox(height: 10),
          if (throws.isEmpty)
            const PanelListTile(title: 'No throws yet', subtitle: 'Tap the board to open the round.', leading: Icon(Icons.touch_app_rounded, color: Colors.white))
          else
            for (final entry in throws.asMap().entries) ...[
              PanelListTile(
                title: X01GamePage.formatThrow(entry.value),
                subtitle: 'Throw ${entry.key + 1} · ${entry.value.segment * entry.value.multiplier} points',
                leading: CircleAvatar(radius: 16, backgroundColor: Colors.white12, child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
                trailing: ScoreBadge(value: '${entry.value.segment * entry.value.multiplier}', highlight: entry.key == throws.length - 1),
              ),
              const SizedBox(height: 8),
            ],
          if (winner != null) ...[
            const SizedBox(height: 12),
            PanelListTile(
              title: '${winner!.name} wins',
              subtitle: 'Checkout completed',
              leading: const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD95B)),
              highlight: true,
            ),
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
            onPressed: canUndo ? controller.undo : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GlassButton(
            label: 'End Turn',
            icon: Icons.bolt_rounded,
            onPressed: controller.resetCurrentTurn,
            highlight: true,
          ),
        ),
      ],
    );
  }
}
