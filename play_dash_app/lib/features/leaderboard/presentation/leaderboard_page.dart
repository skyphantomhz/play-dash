import 'package:flutter/material.dart';

import '../../../shared/widgets/app_shell.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const List<_LeaderboardEntry> _entries = <_LeaderboardEntry>[
    _LeaderboardEntry(name: 'Alex', wins: 18, legs: 42, average: 61.4),
    _LeaderboardEntry(name: 'Morgan', wins: 14, legs: 35, average: 57.8),
    _LeaderboardEntry(name: 'Jamie', wins: 10, legs: 24, average: 52.1),
    _LeaderboardEntry(name: 'Taylor', wins: 7, legs: 19, average: 48.6),
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Leaderboard',
      subtitle:
          'A compact ranking layout that keeps key stats visible without sacrificing readability on smaller screens.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          StatusPill(label: 'Season form', icon: Icons.query_stats_rounded),
          StatusPill(
              label: 'Scannable cards',
              icon: Icons.dashboard_customize_rounded),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 960;

          const summaryPanel = GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeading(
                  title: 'Season standings',
                  subtitle:
                      'Modern sports UIs benefit from clear hierarchy, dense but scannable cards, and a strong top-three focus.',
                ),
                SizedBox(height: 20),
                MetricCard(
                  label: 'Top average',
                  value: '61.4',
                  icon: Icons.bolt_outlined,
                  highlight: true,
                ),
                SizedBox(height: 12),
                MetricCard(
                  label: 'Most wins',
                  value: 'Alex · 18',
                  icon: Icons.emoji_events_outlined,
                ),
                SizedBox(height: 12),
                MetricCard(
                  label: 'Tracked players',
                  value: '4 active',
                  icon: Icons.groups_outlined,
                ),
              ],
            ),
          );

          final rankingPanel = Column(
            children: [
              for (int index = 0; index < _entries.length; index++) ...[
                _LeaderboardCard(rank: index + 1, entry: _entries[index]),
                const SizedBox(height: 12),
              ],
            ],
          );

          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 3, child: summaryPanel),
                    const SizedBox(width: 20),
                    Expanded(flex: 5, child: rankingPanel),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    summaryPanel,
                    const SizedBox(height: 20),
                    rankingPanel,
                  ],
                );
        },
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard({required this.rank, required this.entry});

  final int rank;
  final _LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlight = rank == 1;

    return GlassPanel(
      padding: const EdgeInsets.all(18),
      blur: 18,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 14,
        spacing: 16,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: highlight
                    ? [
                        theme.colorScheme.primary.withValues(alpha: 0.95),
                        theme.colorScheme.secondary.withValues(alpha: 0.85),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.14),
                        theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.64),
                      ],
              ),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: highlight
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.wins} wins • ${entry.legs} legs won',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          MetricCard(
            label: '3-dart avg',
            value: entry.average.toStringAsFixed(1),
            icon: Icons.show_chart_rounded,
            compact: true,
            highlight: highlight,
          ),
        ],
      ),
    );
  }
}

class _LeaderboardEntry {
  const _LeaderboardEntry({
    required this.name,
    required this.wins,
    required this.legs,
    required this.average,
  });

  final String name;
  final int wins;
  final int legs;
  final double average;
}
