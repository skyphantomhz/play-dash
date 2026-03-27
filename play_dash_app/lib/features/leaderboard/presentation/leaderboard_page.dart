import 'package:flutter/material.dart';
import '../../../shared/widgets/app_shell.dart';


class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const entries = <_LeaderboardEntry>[
    _LeaderboardEntry(name: 'Michel “Bullseye” Scott', score: 12847, meta: '35 Games · 2356 Pts Wins', rank: 1),
    _LeaderboardEntry(name: 'Sarah Williams', score: 11243, meta: '18 Games · 2184 Pts Wins', rank: 2),
    _LeaderboardEntry(name: 'James Davis', score: 10932, meta: '31 Games · 2826 Pts Wins', rank: 3),
    _LeaderboardEntry(name: 'Borre Oloone', score: 9887, meta: '15 Games · 2041 Pts Wins', rank: 4),
    _LeaderboardEntry(name: 'Leo Boclones', score: 9521, meta: '16 Games · 2264 Pts Wins', rank: 5),
    _LeaderboardEntry(name: 'You', score: 8765, meta: 'Fall / Playerest · 200 Wins Stats', rank: 12, highlight: true),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1180;
        return desktop ? const _DesktopLeaderboard() : const _MobileLeaderboard();
      },
    );
  }
}

class _DesktopLeaderboard extends StatelessWidget {
  const _DesktopLeaderboard();

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    PlayerAvatar(name: 'Mob Ado', colors: [Color(0xFF37D8FF), Color(0xFF8B5CF6)]),
                    SizedBox(width: 10),
                    Expanded(child: Text('SETUP GAME', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20))),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: const [
                    Expanded(child: _LeaderboardTab(label: 'Global', active: true)),
                    SizedBox(width: 8),
                    Expanded(child: _LeaderboardTab(label: 'Friends')),
                    SizedBox(width: 8),
                    Expanded(child: _LeaderboardTab(label: 'This Month')),
                  ],
                ),
                const SizedBox(height: 16),
                for (final entry in LeaderboardScreen.entries) ...[
                  _LeaderboardRow(entry: entry),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        const Expanded(flex: 24, child: _LeaderboardRail()),
      ],
    );
  }
}

class _MobileLeaderboard extends StatelessWidget {
  const _MobileLeaderboard();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final entry in LeaderboardScreen.entries) ...[
          _LeaderboardRow(entry: entry, compact: true),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _LeaderboardRail extends StatelessWidget {
  const _LeaderboardRail();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFFFF4FD8),
      secondaryAccent: const Color(0xFF37D8FF),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(title: 'Season', subtitle: 'Top three glow brighter and current user row gets the magenta/cyan emphasis.'),
          SizedBox(height: 14),
          MetricCard(label: 'Current Place', value: '12', icon: Icons.tag_rounded, highlight: true),
          SizedBox(height: 10),
          MetricCard(label: 'Best Session', value: '200', icon: Icons.local_fire_department_rounded),
          SizedBox(height: 10),
          MetricCard(label: 'Win Trend', value: '+18%', icon: Icons.show_chart_rounded),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry, this.compact = false});

  final _LeaderboardEntry entry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = entry.highlight
        ? const [Color(0xFFFF4FD8), Color(0xFF37D8FF)]
        : entry.rank <= 3
            ? const [Color(0xFFFFD95B), Color(0xFFFF9A48)]
            : const [Color(0xFF37D8FF), Color(0xFF8B5CF6)];

    return GlassPanel(
      radius: compact ? 18 : 20,
      blur: 18,
      background: Colors.white.withValues(alpha: 0.05),
      borderColor: Colors.white.withValues(alpha: 0.10),
      glowColor: colors.first,
      padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16, vertical: compact ? 12 : 14),
      child: Row(
        children: [
          Container(
            width: compact ? 40 : 54,
            height: compact ? 40 : 54,
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: colors), border: Border.all(color: Colors.white.withValues(alpha: 0.32))),
            alignment: Alignment.center,
            child: Text('${entry.rank}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: compact ? 17 : 24)),
          ),
          const SizedBox(width: 12),
          PlayerAvatar(name: entry.name, colors: colors, radius: compact ? 18 : 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: compact ? 14 : 17)),
                const SizedBox(height: 4),
                Text(entry.meta, style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 11.5)),
              ],
            ),
          ),
          Text(_formatScore(entry.score), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: compact ? 22 : 34, letterSpacing: -1.2)),
          const SizedBox(width: 8),
          if (entry.rank == 1) const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD95B), size: 26),
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

class _LeaderboardTab extends StatelessWidget {
  const _LeaderboardTab({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: active ? const LinearGradient(colors: [Color(0xFF37D8FF), Color(0xFF4DA3FF)]) : null,
        color: active ? null : Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

class _LeaderboardEntry {
  const _LeaderboardEntry({required this.name, required this.score, required this.meta, required this.rank, this.highlight = false});

  final String name;
  final int score;
  final String meta;
  final int rank;
  final bool highlight;
}
