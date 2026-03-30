import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_shell.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    required this.winnerName,
    required this.onRematch,
    this.statLabel,
    this.statValue,
    super.key,
  });

  final String winnerName;
  final String? statLabel;
  final String? statValue;
  final Future<void> Function() onRematch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: GlassPanel(
          radius: 30,
          blur: 14,
          padding: const EdgeInsets.all(24),
          background: const Color(0xCC09111F),
          borderColor: const Color(0x4D9FEFFF),
          glowColor: const Color(0xFF37D8FF),
          shadowColor: const Color(0xE6000000),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF37D8FF), Color(0xFFFF4FD8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF37D8FF).withValues(alpha: 0.34),
                        blurRadius: 28,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: const Color(0xFFFF4FD8).withValues(alpha: 0.24),
                        blurRadius: 44,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  'MATCH FINISHED',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF9FEFFF),
                    letterSpacing: 2.8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  winnerName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                    shadows: [
                      Shadow(
                        color: const Color(0xFF37D8FF).withValues(alpha: 0.35),
                        blurRadius: 26,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'owns the oche. Queue the neon confetti and start the next battle.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    height: 1.45,
                  ),
                ),
              ),
              if (statLabel != null && statValue != null) ...[
                const SizedBox(height: 20),
                GlassPanel(
                  radius: 22,
                  blur: 10,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  background: Colors.white.withValues(alpha: 0.05),
                  borderColor: const Color(0x33FFFFFF),
                  glowColor: const Color(0xFFFF4FD8),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white.withValues(alpha: 0.07),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: const Icon(
                          Icons.insights_rounded,
                          color: Color(0xFFFF9AE8),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statLabel!,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.62),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              statValue!,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GlassButton(
                      label: 'Back to Home',
                      icon: Icons.home_rounded,
                      trailingIcon: Icons.not_interested,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        context.go('/');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton(
                      label: 'Rematch',
                      icon: Icons.replay_rounded,
                      highlight: true,
                      trailingIcon: Icons.not_interested,
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        await onRematch();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
