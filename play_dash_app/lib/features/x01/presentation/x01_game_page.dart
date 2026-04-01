import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_settings.dart';
import '../../../shared/models/match_state.dart';
import '../../../shared/models/player.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/game_over_dialog.dart';
import '../../../shared/widgets/interactive_dartboard.dart';
import '../../../shared/services/feedback_service.dart';
import '../../../features/settings/application/feedback_settings_provider.dart';
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

// ---------------------------------------------------------------------------
// Bust snack-bar entry point
// ---------------------------------------------------------------------------

/// Shows a glassmorphism-styled "BUST" overlay as a custom SnackBar.
void _showBustSnackBar(BuildContext context, String playerName) {
  ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: _BustSnackBarContent(playerName: playerName),
    ),
  );
}

class _BustSnackBarContent extends StatelessWidget {
  const _BustSnackBarContent({required this.playerName});

  final String playerName;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // Deep red-tinted glassmorphism background
            color: const Color(0xCC1A0510),
            border: Border.all(
              color: const Color(0xFFFF3B5C).withValues(alpha: 0.55),
              width: 1.1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFF3B5C).withValues(alpha: 0.22),
                const Color(0xFF8B0026).withValues(alpha: 0.14),
                Colors.black.withValues(alpha: 0.30),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF3B5C).withValues(alpha: 0.28),
                blurRadius: 32,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.55),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Glowing bust icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF3B5C).withValues(alpha: 0.18),
                  border: Border.all(
                    color: const Color(0xFFFF3B5C).withValues(alpha: 0.50),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF3B5C).withValues(alpha: 0.35),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.cancel_rounded,
                  color: Color(0xFFFF3B5C),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // BUST headline
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFF3B5C), Color(0xFFFF8FA3)],
                      ).createShader(bounds),
                      child: const Text(
                        'BUST!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$playerName returns to previous score.',
                      style: const TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main page
// ---------------------------------------------------------------------------

class X01GamePage extends ConsumerStatefulWidget {
  const X01GamePage({super.key});

  @override
  ConsumerState<X01GamePage> createState() => _X01GamePageState();
}

class _X01GamePageState extends ConsumerState<X01GamePage> {
  bool _dialogVisible = false;
  late final ProviderSubscription<X01MatchState> _winnerSubscription;
  late final ProviderSubscription<X01MatchState> _bustSubscription;

  @override
  void initState() {
    super.initState();

    // ---- winner dialog ----
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
        FeedbackService.instance.playSuccess();
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

    // ---- bust snack-bar ----
    _bustSubscription = ref.listenManual<X01MatchState>(x01ControllerProvider,
        (previous, next) {
      // Only trigger when lastTurnWasBust flips from false → true.
      final wasBust = previous?.game.lastTurnWasBust ?? false;
      if (!wasBust && next.game.lastTurnWasBust) {
        // The bust player was the *previous* active player (turn already
        // advanced), so we reconstruct their name from the previous state.
        final bustPlayerIndex = previous?.currentPlayerIndex ??
            next.currentPlayerIndex;
        final players = next.players;
        final bustPlayer = players.isEmpty
            ? null
            : players[bustPlayerIndex.clamp(0, players.length - 1)];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          FeedbackService.instance.playError();
          _showBustSnackBar(context, bustPlayer?.name ?? 'Player');
        });
      }
    });
  }

  @override
  void dispose() {
    _winnerSubscription.close();
    _bustSubscription.close();
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

    // Current score for the active player — needed for double-in hint.
    final activeScore =
        state.game.scores[activePlayer?.id] ?? settings.startingScore;

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
                      score: activeScore,
                      accent: const Color(0xFF37D8FF),
                      meta:
                          '${settings.startingScore}  |  ${settings.doubleOut ? 'Double Out' : 'Single Out'}',
                      turnLabel: winner != null
                          ? '${winner.name} wins'
                          : 'Throw ${state.game.currentTurnThrows.length + 1} of 3',
                      active: winner == null,
                      settings: settings,
                      startingScore: settings.startingScore,
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
                    score: activeScore,
                    accent: const Color(0xFF37D8FF),
                    meta:
                        '${settings.startingScore}  |  ${settings.doubleOut ? 'Double Out' : 'Single Out'}',
                    turnLabel: winner != null
                        ? '${winner.name} wins'
                        : 'Throw ${state.game.currentTurnThrows.length + 1} of 3',
                    active: winner == null,
                    compact: true,
                    settings: settings,
                    startingScore: settings.startingScore,
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

// ---------------------------------------------------------------------------
// _PlayerPanel
// ---------------------------------------------------------------------------

/// Returns the hint text that should appear on the player panel, or null if
/// no special rule applies to the current state.
///
/// Priority:
///   1. doubleIn + player has not yet opened (score == startingScore) → "Double In Required"
///   2. doubleOut → "Double Out Required"
String? _resolveHintText({
  required X01MatchSettings settings,
  required int score,
  required int startingScore,
}) {
  // Double-In: the player hasn't scored yet (score still equals startingScore).
  if (settings.doubleIn && score == startingScore) {
    return 'Double In Required';
  }
  // Double-Out: always shown when rule is active and game is ongoing.
  if (settings.doubleOut) {
    return 'Double Out Required';
  }
  return null;
}

class _PlayerPanel extends StatelessWidget {
  const _PlayerPanel({
    required this.name,
    required this.score,
    required this.accent,
    required this.meta,
    required this.turnLabel,
    required this.settings,
    required this.startingScore,
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
  final X01MatchSettings settings;
  final int startingScore;

  @override
  Widget build(BuildContext context) {
    final hintText = active
        ? _resolveHintText(
            settings: settings,
            score: score,
            startingScore: startingScore,
          )
        : null;

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
          // ---- Double-In / Double-Out hint badge ----
          if (hintText != null) ...[
            const SizedBox(height: 12),
            Center(child: _RuleHintBadge(label: hintText)),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _RuleHintBadge — glassmorphism pill for Double-In / Double-Out hints
// ---------------------------------------------------------------------------

class _RuleHintBadge extends StatelessWidget {
  const _RuleHintBadge({required this.label});

  final String label;

  // Choose accent colours based on which rule we're hinting.
  static const _doubleInColor = Color(0xFF37D8FF);   // cyan
  static const _doubleOutColor = Color(0xFFFF4FD8);  // pink

  @override
  Widget build(BuildContext context) {
    final isDoubleIn = label.contains('In');
    final color = isDoubleIn ? _doubleInColor : _doubleOutColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: color.withValues(alpha: 0.12),
            border: Border.all(
              color: color.withValues(alpha: 0.45),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.20),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDoubleIn
                    ? Icons.login_rounded
                    : Icons.logout_rounded,
                size: 13,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _BoardStage
// ---------------------------------------------------------------------------

class _BoardStage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbackSettings = ref.watch(feedbackSettingsProvider);
    final audioEnabled = feedbackSettings.audioEnabled;

    return NeonCard(
      accent: const Color(0xFF37D8FF),
      secondaryAccent: const Color(0xFFFF4FD8),
      child: Column(
        children: [
          SectionHeading(
            title: winner == null ? 'Game Screen' : '${winner!.name} Wins',
            subtitle:
                'Tap the board to score. Buttons update from controller state.',
            trailing: _MuteToggleButton(audioEnabled: audioEnabled),
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

// ---------------------------------------------------------------------------
// _ScoreRail
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// _BottomActions
// ---------------------------------------------------------------------------

class _BottomActions extends ConsumerWidget {
  const _BottomActions({
    required this.controller,
    required this.canUndo,
    required this.canEndTurn,
  });

  final X01Controller controller;
  final bool canUndo;
  final bool canEndTurn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioEnabled = ref.watch(feedbackSettingsProvider).audioEnabled;
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
        _MuteToggleButton(audioEnabled: audioEnabled),
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

// ---------------------------------------------------------------------------
// _MuteToggleButton — shared mute/unmute icon button
// ---------------------------------------------------------------------------

class _MuteToggleButton extends ConsumerWidget {
  const _MuteToggleButton({required this.audioEnabled});

  final bool audioEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: audioEnabled ? 'Mute audio' : 'Unmute audio',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref
                .read(feedbackSettingsProvider.notifier)
                .setAudioEnabled(!audioEnabled);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: audioEnabled
                  ? Colors.white.withValues(alpha: 0.07)
                  : const Color(0xFFFF4FD8).withValues(alpha: 0.15),
              border: Border.all(
                color: audioEnabled
                    ? Colors.white.withValues(alpha: 0.10)
                    : const Color(0xFFFF4FD8).withValues(alpha: 0.40),
                width: 1.0,
              ),
            ),
            child: Icon(
              audioEnabled
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
              size: 20,
              color: audioEnabled
                  ? Colors.white.withValues(alpha: 0.75)
                  : const Color(0xFFFF4FD8),
            ),
          ),
        ),
      ),
    );
  }
}
