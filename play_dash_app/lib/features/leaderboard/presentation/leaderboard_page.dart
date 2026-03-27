import 'package:flutter/material.dart';

import '../../../shared/widgets/app_shell.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const List<_LeaderboardEntry> entries = <_LeaderboardEntry>[
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
          'The standings view was rebuilt into a glass statistics board with denser ranking rows, a stronger top-player hero, and cleaner season metrics.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          StatusPill(
            label: 'Season form',
            icon: Icons.query_stats_rounded,
            tinted: true,
          ),
          StatusPill(
            label: 'Compact rankings',
            icon: Icons.leaderboard_rounded,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1120;
          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 3, child: _SummaryPanel()),
                    const SizedBox(width: 20),
                    Expanded(flex: 5, child: _RankingsPanel()),
                  ],
                )
              : const Column(
                  children: [
                    _SummaryPanel(),
                    SizedBox(height: 20),
                    _RankingsPanel(),
                  ],
                );
        },
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 34,
      blur: 9,
      opacity: 0.48,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionHeading(
            title: 'Season snapshot',
            subtitle:
                'A focused metric rail keeps the leaderboard easy to read before scanning the full ranked list.',
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
          SizedBox(height: 20),
          PanelListTile(
            title: 'Sharper hierarchy',
            subtitle: 'Top rank is highlighted, while lower ranks remain compact and readable.',
            leading: Icon(Icons.format_paint_rounded),
          ),
        ],
      ),
    );
  }
}

class _RankingsPanel extends StatelessWidget {
  const _RankingsPanel();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 34,
      blur: 9,
      opacity: 0.48,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Rankings',
            subtitle:
                'Player rows are rebuilt as translucent cards with stronger score emphasis and clearer spacing.',
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < LeaderboardScreen.entries.length; i++) ...[
            _LeaderboardCard(rank: i + 1, entry: LeaderboardScreen.entries[i]),
            const SizedBox(height: 12),
          ],
        ],
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
      blur: 8,
      backgroundOpacity: highlight ? 0.48 : 0.38,
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
                    ? const [Color(0xFF8E7BFF), Color(0xFF52CFFF)]
                    : [
                        Colors.white.withValues(alpha: 0.14),
                        Colors.white.withValues(alpha: 0.06),
                      ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.wins} wins • ${entry.legs} legs won',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          ScoreBadge(
            value: entry.average.toStringAsFixed(1),
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
