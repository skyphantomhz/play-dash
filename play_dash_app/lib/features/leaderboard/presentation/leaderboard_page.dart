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
          'The standings view was rebuilt using stacked translucent cards, a condensed stat rail, and stronger top-rank emphasis to match the new dashboard language.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          StatusPill(
              label: 'Season form',
              icon: Icons.query_stats_rounded,
              tinted: true),
          StatusPill(
              label: 'Compact rankings', icon: Icons.leaderboard_outlined),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 980;
          final summary = GlassPanel(
            radius: 32,
            blur: 8,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeading(
                  title: 'Season standings',
                  subtitle:
                      'Quick summary metrics keep the leaderboard readable before players scan the full ranked list.',
                ),
                SizedBox(height: 20),
                MetricCard(
                    label: 'Top average',
                    value: '61.4',
                    icon: Icons.bolt_outlined,
                    highlight: true),
                SizedBox(height: 12),
                MetricCard(
                    label: 'Most wins',
                    value: 'Alex · 18',
                    icon: Icons.emoji_events_outlined),
                SizedBox(height: 12),
                MetricCard(
                    label: 'Tracked players',
                    value: '4 active',
                    icon: Icons.groups_outlined),
              ],
            ),
          );

          final list = Column(
            children: [
              for (var i = 0; i < _entries.length; i++) ...[
                _LeaderboardCard(rank: i + 1, entry: _entries[i]),
                const SizedBox(height: 12),
              ],
            ],
          );

          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 3, child: summary),
                  const SizedBox(width: 20),
                  Expanded(flex: 5, child: list)
                ])
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [summary, const SizedBox(height: 20), list]);
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
    final highlight = rank == 1;
    return FrostPanel(
      radius: 28,
      blur: 6,
      backgroundOpacity: 0.48,
      highlight: highlight,
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: highlight
                    ? const [Color(0xFF8C7BFF), Color(0xFF52D1FF)]
                    : [
                        Colors.white.withValues(alpha: 0.14),
                        Colors.white.withValues(alpha: 0.06)
                      ],
              ),
            ),
            alignment: Alignment.center,
            child: Text('$rank',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${entry.wins} wins • ${entry.legs} legs won',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          MetricCard(
              label: '3-dart avg',
              value: entry.average.toStringAsFixed(1),
              icon: Icons.show_chart_rounded,
              compact: true,
              highlight: highlight),
        ],
      ),
    );
  }
}

class _LeaderboardEntry {
  const _LeaderboardEntry(
      {required this.name,
      required this.wins,
      required this.legs,
      required this.average});

  final String name;
  final int wins;
  final int legs;
  final double average;
}
