import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/history_providers.dart';
import '../../../shared/widgets/app_shell.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1180;
        return desktop
            ? const _DesktopLeaderboard()
            : const _MobileLeaderboard();
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Desktop layout
// ---------------------------------------------------------------------------

class _DesktopLeaderboard extends ConsumerWidget {
  const _DesktopLeaderboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(leaderboardEntriesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 64,
            child: NeonCard(
              accent: const Color(0xFF37D8FF),
              secondaryAccent: const Color(0xFF8B5CF6),
              child: Column(
                children: [
                  const Row(
                    children: [
                      PlayerAvatar(
                          name: 'Leaderboard',
                          colors: [Color(0xFF37D8FF), Color(0xFF8B5CF6)]),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text('LEADERBOARD',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _LeaderboardTab(label: 'All Time', active: true),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (entries.isEmpty)
                    const _EmptyState()
                  else
                    for (final entry in entries) ...[
                      _LeaderboardRow(entry: entry),
                      const SizedBox(height: 12),
                    ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(flex: 24, child: _LeaderboardRail(entries: entries)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mobile layout
// ---------------------------------------------------------------------------

class _MobileLeaderboard extends ConsumerWidget {
  const _MobileLeaderboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(leaderboardEntriesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const GlassPanel(
            radius: 20,
            blur: 20,
            background: Color(0x14FFFFFF),
            borderColor: Color(0x1FFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeading(
                  title: 'Leaderboard',
                  subtitle: 'Rankings based on your local match history.',
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _LeaderboardTab(label: 'All Time', active: true),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (entries.isEmpty)
            const _EmptyState()
          else
            for (final entry in entries) ...[
              _LeaderboardRow(entry: entry, compact: true),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rail (right sidebar on desktop)
// ---------------------------------------------------------------------------

class _LeaderboardRail extends StatelessWidget {
  const _LeaderboardRail({required this.entries});

  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    final topEntry = entries.isNotEmpty ? entries.first : null;
    final totalGames = entries.fold<int>(0, (acc, e) => acc + e.totalGames);
    final avgWinRate = entries.isEmpty
        ? 0.0
        : entries.fold<double>(0, (acc, e) => acc + e.winRate) / entries.length;

    return GlassPanel(
      radius: 20,
      blur: 22,
      background: Colors.white.withValues(alpha: 0.06),
      borderColor: Colors.white.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Season',
            subtitle: 'Stats derived from your local match history.',
          ),
          const SizedBox(height: 14),
          MetricCard(
            label: 'Top Player',
            value: topEntry?.playerName ?? '—',
            icon: Icons.emoji_events_rounded,
            highlight: true,
          ),
          const SizedBox(height: 10),
          MetricCard(
            label: 'Total Games',
            value: totalGames > 0 ? '$totalGames' : '—',
            icon: Icons.sports_rounded,
          ),
          const SizedBox(height: 10),
          MetricCard(
            label: 'Avg Win Rate',
            value: entries.isNotEmpty
                ? '${(avgWinRate * 100).toStringAsFixed(0)}%'
                : '—',
            icon: Icons.show_chart_rounded,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.sports_bar_rounded,
            size: 56,
            color: Colors.white.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 16),
          Text(
            'No matches yet',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete a game to see rankings here.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Row widget
// ---------------------------------------------------------------------------

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry, this.compact = false});

  final LeaderboardEntry entry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = entry.rank <= 3
        ? const [Color(0xFFFFD95B), Color(0xFFFF9A48)]
        : const [Color(0xFF37D8FF), Color(0xFF8B5CF6)];

    return GlassPanel(
      radius: compact ? 18 : 20,
      blur: 18,
      background: Colors.white.withValues(alpha: 0.05),
      borderColor: Colors.white.withValues(alpha: 0.10),
      glowColor: colors.first,
      padding: EdgeInsets.symmetric(
          horizontal: compact ? 12 : 16, vertical: compact ? 12 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: compact ? 40 : 54,
            height: compact ? 40 : 54,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: colors),
                border:
                    Border.all(color: Colors.white.withValues(alpha: 0.32))),
            alignment: Alignment.center,
            child: Text('${entry.rank}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: compact ? 17 : 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlayerAvatar(
                        name: entry.playerName,
                        colors: colors,
                        radius: compact ? 18 : 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.playerName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: compact ? 14 : 17)),
                          const SizedBox(height: 4),
                          Text(entry.metaText,
                              style: const TextStyle(
                                  color: Color(0xB3FFFFFF), fontSize: 11.5)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Text(_formatScore(entry.score),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: compact ? 22 : 34,
                            letterSpacing: -1.2)),
                    if (entry.rank == 1)
                      const Icon(Icons.emoji_events_rounded,
                          color: Color(0xFFFFD95B), size: 24),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatScore(int value) {
    final text = value.toString();
    if (text.length <= 3) return text;
    final head = text.substring(0, text.length - 3);
    final tail = text.substring(text.length - 3);
    return '$head,$tail';
  }
}

// ---------------------------------------------------------------------------
// Tab chip
// ---------------------------------------------------------------------------

class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: active
            ? const LinearGradient(
                colors: [Color(0xFF37D8FF), Color(0xFF4DA3FF)])
            : null,
        color: active ? null : Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}
