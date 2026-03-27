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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          final overviewPanel = GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: const Text('Live scoring · adaptive UI'),
                  avatar: Icon(
                    Icons.auto_awesome,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Choose a game mode',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose a match flow and keep every throw readable at a glance.',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'The refreshed interface prioritizes fast input, clear hierarchy, and glass-style surfaces with strong contrast for sports environments.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    SizedBox(
                      width: 170,
                      child: MetricCard(
                        label: 'Modes',
                        value: 'X01 + Cricket',
                        icon: Icons.sports_score_outlined,
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      child: MetricCard(
                        label: 'Input',
                        value: 'Interactive board',
                        icon: Icons.touch_app_outlined,
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      child: MetricCard(
                        label: 'Responsive',
                        value: 'Mobile to desktop',
                        icon: Icons.devices_outlined,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          final actionsPanel = GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeading(
                  title: 'Quick actions',
                  subtitle:
                      'Start where players expect: setup, jump into a mode, or review form.',
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => context.go('/setup'),
                  icon: const Icon(Icons.groups_2_outlined),
                  label: const Text('Player Setup'),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => context.go('/match/x01'),
                  icon: const Icon(Icons.sports_score_outlined),
                  label: const Text('Play X01'),
                ),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => context.go('/match/cricket'),
                  icon: const Icon(Icons.track_changes_outlined),
                  label: const Text('Play Cricket'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go('/leaderboard'),
                  icon: const Icon(Icons.emoji_events_outlined),
                  label: const Text('Leaderboard'),
                ),
              ],
            ),
          );

          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: overviewPanel),
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
