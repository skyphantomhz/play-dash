import 'package:flutter/material.dart';

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
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Season standings',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Track the players with the hottest form across recent matches.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            for (int index = 0; index < _entries.length; index++) ...[
              _LeaderboardCard(
                rank: index + 1,
                entry: _entries[index],
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
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
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              child: Text('$rank'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.wins} wins • ${entry.legs} legs won',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  entry.average.toStringAsFixed(1),
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  '3-dart avg',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
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
