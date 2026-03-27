import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_shell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppShell(
      title: 'Play Dash',
      subtitle:
          'A sharper, more immersive darts scoring experience built for phones, tablets, and desktop dashboards.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          StatusPill(label: 'Live scoring', icon: Icons.auto_graph_rounded),
          StatusPill(label: 'Glassmorphism UI', icon: Icons.blur_on_rounded),
          StatusPill(label: 'Mobile → Desktop', icon: Icons.devices_rounded),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 980;

          final overviewPanel = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 28 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: const Text('Match control · responsive surfaces'),
                  avatar: Icon(
                    Icons.auto_awesome,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Choose a game mode',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'The interface uses layered glass panels, soft glows, and high-contrast typography so players can read scores quickly in bright rooms or darker lounge-style setups.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    SizedBox(
                      width: 220,
                      child: MetricCard(
                        label: 'Game modes',
                        value: 'X01 + Cricket',
                        icon: Icons.sports_score_outlined,
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: MetricCard(
                        label: 'Input flow',
                        value: 'Interactive dartboard',
                        icon: Icons.touch_app_outlined,
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: MetricCard(
                        label: 'Responsive',
                        value: 'Stacked or split layout',
                        icon: Icons.view_quilt_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                GlassPanel(
                  radius: 24,
                  blur: 14,
                  opacity: 0.48,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.18),
                        ),
                        child: Icon(
                          Icons.visibility_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'The scoring views keep the active player, score state, and dart input visible together to reduce eye travel during play.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          final actionsPanel = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 28 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeading(
                  title: 'Quick actions',
                  subtitle:
                      'Start where players expect: setup, jump into a mode, or review performance with fewer taps.',
                ),
                const SizedBox(height: 22),
                GlassButton(
                  onPressed: () => context.go('/setup'),
                  icon: Icons.groups_2_outlined,
                  label: 'Player Setup',
                  highlight: true,
                ),
                const SizedBox(height: 12),
                GlassButton(
                  onPressed: () => context.go('/match/x01'),
                  icon: Icons.sports_score_outlined,
                  label: 'Play X01',
                ),
                const SizedBox(height: 12),
                GlassButton(
                  onPressed: () => context.go('/match/cricket'),
                  icon: Icons.track_changes_outlined,
                  label: 'Play Cricket',
                ),
                const SizedBox(height: 12),
                GlassButton(
                  onPressed: () => context.go('/leaderboard'),
                  icon: Icons.emoji_events_outlined,
                  label: 'Leaderboard',
                ),
              ],
            ),
          );

          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: overviewPanel),
                    const SizedBox(width: 20),
                    Expanded(flex: 4, child: actionsPanel),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    overviewPanel,
                    const SizedBox(height: 20),
                    actionsPanel,
                  ],
                );
        },
      ),
    );
  }
}
