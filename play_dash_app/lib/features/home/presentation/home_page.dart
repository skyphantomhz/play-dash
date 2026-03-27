import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_shell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= 1180;

    return AppShell(
      expandChild: true,
      mobileTopTabs: const [
        ShellTab(label: 'Home', route: '/'),
        ShellTab(label: 'Account', route: '/leaderboard'),
        ShellTab(label: 'Stats', route: '/leaderboard'),
        ShellTab(label: 'Voice', route: '/settings'),
      ],
      child: desktop ? const _DesktopHomeLayout() : const _MobileHomeLayout(),
    );
  }
}

class _DesktopHomeLayout extends StatelessWidget {
  const _DesktopHomeLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 29,
          child: Column(
            children: [
              _ModeCard(
                title: 'CRICKET',
                subtitle: 'Classic Cricket',
                metaLeft: '2 - 6 Players',
                metaRight: '10 • 0 / 20 hits',
                playerName: 'Mike Johnson',
                playerMeta: '2nd · 0 Cricket',
                accent: const Color(0xFF37D8FF),
                secondaryAccent: const Color(0xFF4DA3FF),
                icon: Icons.sports_martial_arts_rounded,
                onPressed: () => context.go('/match/cricket'),
              ),
              const SizedBox(height: 16),
              _ModeCard(
                title: 'X01',
                subtitle: '301 · 501 · 701',
                metaLeft: '1 - 8 Players',
                metaRight: '1 / 10 legs',
                accent: const Color(0xFFFF4FD8),
                secondaryAccent: const Color(0xFF8B5CF6),
                icon: Icons.close_rounded,
                onPressed: () => context.go('/setup'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Leaderboard',
                      subtitle: 'View Top Players',
                      icon: Icons.emoji_events_rounded,
                      accent: const Color(0xFF37D8FF),
                      onTap: () => context.go('/leaderboard'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Quick Setup',
                      subtitle: 'Create a Game',
                      icon: Icons.settings_suggest_rounded,
                      accent: const Color(0xFF8B5CF6),
                      onTap: () => context.go('/setup'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        const Expanded(flex: 42, child: _CenterGameShowcase()),
        const SizedBox(width: 18),
        const Expanded(flex: 24, child: _RightInfoRail()),
      ],
    );
  }
}

class _MobileHomeLayout extends StatelessWidget {
  const _MobileHomeLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ModeCard(
                title: 'CRICKET',
                subtitle: 'Classic Cricket',
                metaLeft: '2 - 6 Players',
                metaRight: '10 / 20 hits',
                accent: const Color(0xFF37D8FF),
                secondaryAccent: const Color(0xFF4DA3FF),
                icon: Icons.sports_martial_arts_rounded,
                compact: true,
                onPressed: () => context.go('/match/cricket'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ModeCard(
                title: 'X01',
                subtitle: '301 · 501 · 701',
                metaLeft: '1 - 8 Players',
                metaRight: '10 / 20 legs',
                accent: const Color(0xFFFF4FD8),
                secondaryAccent: const Color(0xFF8B5CF6),
                icon: Icons.close_rounded,
                compact: true,
                onPressed: () => context.go('/setup'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: 'Leaderboard',
                subtitle: 'View Top Players',
                icon: Icons.emoji_events_rounded,
                accent: const Color(0xFF37D8FF),
                compact: true,
                onTap: () => context.go('/leaderboard'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionCard(
                title: 'Quick Setup',
                subtitle: 'Create a Game',
                icon: Icons.settings_suggest_rounded,
                accent: const Color(0xFF8B5CF6),
                compact: true,
                onTap: () => context.go('/setup'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.metaLeft,
    required this.metaRight,
    required this.accent,
    required this.secondaryAccent,
    required this.icon,
    required this.onPressed,
    this.playerName,
    this.playerMeta,
    this.compact = false,
  });

  final String title;
  final String subtitle;
  final String metaLeft;
  final String metaRight;
  final Color accent;
  final Color secondaryAccent;
  final IconData icon;
  final VoidCallback onPressed;
  final String? playerName;
  final String? playerMeta;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: accent,
      secondaryAccent: secondaryAccent,
      radius: compact ? 18 : 22,
      padding: EdgeInsets.all(compact ? 14 : 18),
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (playerName != null) ...[
            Row(
              children: [
                const PlayerAvatar(name: 'Mike Johnson', colors: [Color(0xFF37D8FF), Color(0xFF4DA3FF)], radius: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(playerName!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: compact ? 12.5 : 14)),
                      Text(playerMeta ?? '', style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 10 : 14),
          ],
          Icon(icon, color: accent, size: compact ? 28 : 34),
          SizedBox(height: compact ? 8 : 10),
          Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: compact ? 20 : 26, letterSpacing: -0.8)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: compact ? 13 : 15)),
          SizedBox(height: compact ? 10 : 16),
          Row(
            children: [
              Expanded(child: Text(metaLeft, style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 11.5))),
              Text(metaRight, style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 11.5)),
            ],
          ),
          SizedBox(height: compact ? 12 : 16),
          SizedBox(
            width: double.infinity,
            child: GlassButton(
              label: 'Start Game',
              icon: Icons.play_arrow_rounded,
              highlight: true,
              compact: compact,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.title, required this.subtitle, required this.icon, required this.accent, required this.onTap, this.compact = false});

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: compact ? 18 : 20,
      blur: 20,
      background: Colors.white.withValues(alpha: 0.06),
      borderColor: Colors.white.withValues(alpha: 0.12),
      glowColor: accent,
      padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 16, vertical: compact ? 14 : 16),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: accent, size: compact ? 20 : 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: compact ? 14 : 15.5)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 11.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterGameShowcase extends StatelessWidget {
  const _CenterGameShowcase();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFF37D8FF),
      secondaryAccent: const Color(0xFFFF4FD8),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [StatusPill(label: 'GAME SCREEN', tinted: true)],
          ),
          const SizedBox(height: 8),
          const Text('XG1 • 80 Player • Rom of 3 legs', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 18),
          const Expanded(child: _HeroBoard()),
          const SizedBox(height: 10),
          const Text('Tap a section to score', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _FooterAction(title: 'Undo', subtitle: 'Score/Dart 20', icon: Icons.undo_rounded, accent: Color(0xFF37D8FF))),
              SizedBox(width: 12),
              Expanded(child: _CenterScoreCard()),
              SizedBox(width: 12),
              Expanded(child: _FooterAction(title: 'End Turn', subtitle: '', icon: Icons.bolt_rounded, accent: Color(0xFFFF4FD8), highlighted: true)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroBoard extends StatelessWidget {
  const _HeroBoard();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1, child: CustomPaint(painter: _BoardPainter()));
  }
}

class _FooterAction extends StatelessWidget {
  const _FooterAction({required this.title, required this.subtitle, required this.icon, required this.accent, this.highlighted = false});

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 18,
      blur: 16,
      background: Colors.white.withValues(alpha: 0.06),
      borderColor: Colors.white.withValues(alpha: 0.12),
      glowColor: accent,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterScoreCard extends StatelessWidget {
  const _CenterScoreCard();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 18,
      blur: 18,
      background: Colors.white.withValues(alpha: 0.08),
      borderColor: Colors.white.withValues(alpha: 0.14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: const Column(
        children: [
          Text('60', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
          Text('Latest Scored', style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 11.5)),
        ],
      ),
    );
  }
}

class _RightInfoRail extends StatelessWidget {
  const _RightInfoRail();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _HeroScoreCard(),
        SizedBox(height: 16),
        Expanded(child: _ActivityRail()),
      ],
    );
  }
}

class _HeroScoreCard extends StatelessWidget {
  const _HeroScoreCard();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFFFF4FD8),
      secondaryAccent: const Color(0xFF8B5CF6),
      child: Column(
        children: const [
          Row(
            children: [
              PlayerAvatar(name: 'Sarah Williams', colors: [Color(0xFFFF4FD8), Color(0xFF8B5CF6)]),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(alignment: Alignment.centerRight, child: StatusPill(label: 'WAITING', tinted: true)),
                    SizedBox(height: 8),
                    Text('Sarah Williams', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('301', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 58, letterSpacing: -2)),
          SizedBox(height: 4),
          Text('S.01  |  Roun 5', style: TextStyle(color: Color(0xB3FFFFFF), fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          Text('✕  ★  ↻  ♥  ▽', style: TextStyle(color: Colors.white70, letterSpacing: 2)),
        ],
      ),
    );
  }
}

class _ActivityRail extends StatelessWidget {
  const _ActivityRail();

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFFFF4FD8),
      secondaryAccent: const Color(0xFF37D8FF),
      child: Column(
        children: const [
          PanelListTile(title: 'Mike Obhooy', subtitle: 'Trents       310', leading: Icon(Icons.person, color: Colors.white)),
          SizedBox(height: 10),
          PanelListTile(title: 'T. Nations', subtitle: 'St Nomos      7', leading: Icon(Icons.person, color: Colors.white)),
          SizedBox(height: 10),
          PanelListTile(title: 'Rehcroring', subtitle: 'Setting      30', leading: Icon(Icons.settings, color: Colors.white)),
          SizedBox(height: 16),
          SectionHeading(title: 'Throw History', compact: true),
          SizedBox(height: 10),
          _HistoryLine(left: '60  - 3.20 low', right: '+0:35'),
          _HistoryLine(left: '90  - 5.23 visit', right: '+0:50'),
          _HistoryLine(left: '1.90 loss', right: '+0:12'),
          _HistoryLine(left: '98 loss', right: '+0:18'),
        ],
      ),
    );
  }
}

class _HistoryLine extends StatelessWidget {
  const _HistoryLine({required this.left, required this.right});

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(left, style: const TextStyle(color: Colors.white70, fontSize: 11.5))),
        Text(right, style: const TextStyle(color: Color(0x99FFFFFF), fontSize: 11)),
      ],
    );
  }
}

class _BoardPainter extends CustomPainter {
  static const order = [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(
      center,
      radius * 1.05,
      Paint()..shader = const RadialGradient(colors: [Color(0x5537D8FF), Color(0x228B5CF6), Colors.transparent]).createShader(Rect.fromCircle(center: center, radius: radius * 1.2)),
    );

    const sweep = math.pi / 10;
    void ring(double inner, double outer, Color even, Color odd) {
      for (int i = 0; i < 20; i++) {
        final start = -math.pi / 2 + i * sweep;
        final path = Path()
          ..moveTo(center.dx + radius * inner * math.cos(start), center.dy + radius * inner * math.sin(start))
          ..arcTo(Rect.fromCircle(center: center, radius: radius * outer), start, sweep, false)
          ..lineTo(center.dx + radius * inner * math.cos(start + sweep), center.dy + radius * inner * math.sin(start + sweep))
          ..arcTo(Rect.fromCircle(center: center, radius: radius * inner), start + sweep, -sweep, false)
          ..close();
        canvas.drawPath(path, Paint()..color = i.isEven ? even : odd);
        canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = const Color(0xFF0B0B0B));
      }
    }

    ring(0.62, 0.90, const Color(0xFFE8DAB3), const Color(0xFF121616));
    ring(0.54, 0.62, const Color(0xFF2AA18B), const Color(0xFFAF1233));
    ring(0.10, 0.54, const Color(0xFF121616), const Color(0xFFE8DAB3));
    ring(0.90, 1.00, const Color(0xFFAF1233), const Color(0xFF2AA18B));

    canvas.drawCircle(center, radius * 0.10, Paint()..color = const Color(0xFF2AA18B));
    canvas.drawCircle(center, radius * 0.05, Paint()..color = const Color(0xFFAF1233));

    final wire = Paint()..color = const Color(0xCC111111)..strokeWidth = 1;
    for (int i = 0; i < 20; i++) {
      final angle = -math.pi / 2 + i * sweep;
      canvas.drawLine(
        Offset(center.dx + radius * 0.10 * math.cos(angle), center.dy + radius * 0.10 * math.sin(angle)),
        Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle)),
        wire,
      );
    }

    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < 20; i++) {
      final angle = -math.pi / 2 + (i + 0.5) * sweep;
      final point = Offset(center.dx + radius * 0.81 * math.cos(angle), center.dy + radius * 0.81 * math.sin(angle));
      tp.text = TextSpan(text: '${order[i]}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: radius * 0.095, shadows: const [Shadow(color: Colors.black54, blurRadius: 8)]));
      tp.layout();
      tp.paint(canvas, point - Offset(tp.width / 2, tp.height / 2));
    }

    final beam = Paint()
      ..shader = const LinearGradient(colors: [Color(0x00FFFFFF), Color(0xAAFFF2A8), Color(0xAAFF4FD8), Color(0x0037D8FF)]).createShader(Rect.fromCenter(center: center, width: 80, height: radius * 1.3));
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(0.8);
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 34, height: radius * 1.1), beam);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
