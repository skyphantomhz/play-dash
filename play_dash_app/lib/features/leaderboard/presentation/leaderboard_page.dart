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
          'The standings screen is rebuilt as a compact season board with a hero summary, ranked player cards, and a more deliberate glass hierarchy.',
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
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _SummaryPanel()),
                    SizedBox(width: 18),
                    Expanded(flex: 5, child: _RankingsPanel()),
                  ],
                )
              : const Column(
                  children: [
                    _SummaryPanel(),
                    SizedBox(height: 18),
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
      radius: 36,
      blur: 6,
      opacity: 0.42,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionHeading(
            title: 'Season snapshot',
            subtitle:
                'A focused side summary keeps the key numbers visible before scanning the full rankings list.',
          ),
          SizedBox(height: 18),
          MetricCard(
            label: 'Top average',
            value: '61.4',
            icon: Icons.bolt_rounded,
            highlight: true,
          ),
          SizedBox(height: 12),
          MetricCard(
            label: 'Most wins',
            value: 'Alex · 18',
            icon: Icons.emoji_events_rounded,
          ),
          SizedBox(height: 12),
          MetricCard(
            label: 'Tracked players',
            value: '4 active',
            icon: Icons.groups_rounded,
          ),
          SizedBox(height: 18),
          PanelListTile(
            title: 'Sharper hierarchy',
            subtitle: 'Top rank receives stronger emphasis while lower ranks stay dense and readable.',
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
      radius: 36,
      blur: 6,
      opacity: 0.42,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Rankings',
            subtitle:
                'Player rows are rebuilt as translucent cards with clearer score emphasis, calmer backgrounds, and tighter spacing.',
          ),
          const SizedBox(height: 18),
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
      blur: 5,
      backgroundOpacity: highlight ? 0.36 : 0.30,
      highlight: highlight,
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: highlight
                    ? const [Color(0xFF8C80FF), Color(0xFF5AD4FF)]
                    : [
                        Colors.white.withValues(alpha: 0.14),
                        Colors.white.withValues(alpha: 0.05),
                      ],
              ),
            ),
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
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
