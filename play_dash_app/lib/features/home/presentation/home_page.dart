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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 34,
          child: Column(
            children: [
              const _ModeCard(
                title: 'CRICKET',
                subtitle: 'Classic Cricket',
                metaLeft: '2 - 6 Players',
                metaRight: '10 - 0 / 20 hits',
                buttonLabel: 'Start Game',
                accent: Color(0xFF28C6FF),
                secondaryAccent: Color(0xFF4F7BFF),
                icon: Icons.sports_martial_arts_rounded,
                playerName: 'Mike Johnson',
                playerMeta: '2nd · 0 Cricket',
              ),
              const SizedBox(height: 16),
              const _ModeCard(
                title: 'X01',
                subtitle: '301 - 501 - 701',
                metaLeft: '1 - 8 Players',
                metaRight: '1 / 10 / 20 Legs',
                buttonLabel: 'Start Game',
                accent: Color(0xFFFF53E1),
                secondaryAccent: Color(0xFF7A49FF),
                icon: Icons.close_rounded,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _UtilityCard(
                      title: 'Leaderboard',
                      subtitle: 'View Top Players',
                      icon: Icons.emoji_events_rounded,
                      accent: const Color(0xFF2CB5FF),
                      onTap: () => context.go('/leaderboard'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _UtilityCard(
                      title: 'Quick Setup',
                      subtitle: 'Create a Game',
                      icon: Icons.settings_suggest_rounded,
                      accent: const Color(0xFFB84FFF),
                      onTap: () => context.go('/setup'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        const Expanded(flex: 44, child: _BoardShowcase()),
        const SizedBox(width: 18),
        Expanded(
          flex: 22,
          child: Column(
            children: [
              const _ScoreHeroCard(),
              const SizedBox(height: 16),
              _LiveFeedCard(onSetup: () => context.go('/setup')),
            ],
          ),
        ),
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
        const Row(
          children: [
            Expanded(
              child: _ModeCard(
                title: 'CRICKET',
                subtitle: 'Classic Cricket',
                metaLeft: '2 - 6 Players',
                metaRight: '10 / 20 hits',
                buttonLabel: 'Start Game',
                accent: Color(0xFF28C6FF),
                secondaryAccent: Color(0xFF4F7BFF),
                icon: Icons.sports_martial_arts_rounded,
                compact: true,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _ModeCard(
                title: 'X01',
                subtitle: '301 - 501 - 701',
                metaLeft: '1 to 8 Players',
                metaRight: '10 / 20 Legs',
                buttonLabel: 'Start Game',
                accent: Color(0xFFFF53E1),
                secondaryAccent: Color(0xFF7A49FF),
                icon: Icons.close_rounded,
                compact: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _UtilityCard(
                title: 'Leaderboard',
                subtitle: 'View Top Players',
                icon: Icons.emoji_events_rounded,
                accent: const Color(0xFF2CB5FF),
                compact: true,
                onTap: () => context.go('/leaderboard'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _UtilityCard(
                title: 'Quick Setup',
                subtitle: 'Create a Game',
                icon: Icons.settings_suggest_rounded,
                accent: const Color(0xFFB84FFF),
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
    required this.buttonLabel,
    required this.accent,
    required this.secondaryAccent,
    required this.icon,
    this.playerName,
    this.playerMeta,
    this.compact = false,
  });

  final String title;
  final String subtitle;
  final String metaLeft;
  final String metaRight;
  final String buttonLabel;
  final Color accent;
  final Color secondaryAccent;
  final IconData icon;
  final String? playerName;
  final String? playerMeta;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: accent,
      secondaryAccent: secondaryAccent,
      radius: compact ? 18 : 24,
      padding: EdgeInsets.all(compact ? 14 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (playerName != null) ...[
            Row(
              children: [
                const PlayerAvatar(
                  name: 'Mike Johnson',
                  colors: [Color(0xFF0E9EEB), Color(0xFF6C6CFF)],
                  radius: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(playerName!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: compact ? 12 : 14)),
                      Text(playerMeta ?? '', style: const TextStyle(color: Color(0xB3E8EDFF), fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 12 : 16),
          ],
          Icon(icon, size: compact ? 28 : 34, color: accent.withValues(alpha: 0.95)),
          SizedBox(height: compact ? 8 : 10),
          Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: compact ? 20 : 26, letterSpacing: -0.8)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 14)),
          SizedBox(height: compact ? 10 : 16),
          Row(
            children: [
              Expanded(child: Text(metaLeft, style: const TextStyle(color: Color(0xB3E8EDFF), fontSize: 11.5))),
              Text(metaRight, style: const TextStyle(color: Color(0xB3E8EDFF), fontSize: 11.5)),
            ],
          ),
          SizedBox(height: compact ? 12 : 16),
          SizedBox(
            width: double.infinity,
            child: GlassButton(
              label: buttonLabel,
              icon: Icons.play_arrow_rounded,
              highlight: true,
              compact: compact,
              onPressed: () => context.go(title == 'CRICKET' ? '/match/cricket' : '/setup'),
            ),
          ),
        ],
      ),
    );
  }
}

class _UtilityCard extends StatelessWidget {
  const _UtilityCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
    this.compact = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: accent,
      radius: compact ? 18 : 22,
      padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 16, vertical: compact ? 14 : 16),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: accent, size: compact ? 22 : 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: compact ? 14 : 16)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: Color(0xB3E8EDFF), fontSize: 11.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoardShowcase extends StatelessWidget {
  const _BoardShowcase();

  @override
  Widget build(BuildContext context) {
    return const NeonCard(
      accent: Color(0xFF2DB6FF),
      secondaryAccent: Color(0xFFFF4BDD),
      padding: EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StatusPill(label: 'GAME SCREEN', tinted: true),
            ],
          ),
          SizedBox(height: 10),
          _BoardHeader(),
          SizedBox(height: 18),
          Expanded(child: _HeroBoard()),
          SizedBox(height: 12),
          Text('Tap a section to score', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _FooterButton(title: 'Undo', subtitle: 'Score/Dart 20', accent: Color(0xFF2CB6FF), icon: Icons.undo_rounded)),
              SizedBox(width: 12),
              Expanded(child: _CenterScoreFooter()),
              SizedBox(width: 12),
              Expanded(child: _FooterButton(title: 'End Turn', subtitle: '', accent: Color(0xFFFF4BDD), icon: Icons.bolt_rounded)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BoardHeader extends StatelessWidget {
  const _BoardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text('XG1  •  80 Player  •  Rom of 3 legs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
      ],
    );
  }
}

class _HeroBoard extends StatelessWidget {
  const _HeroBoard();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _StaticBoardPainter(),
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({required this.title, required this.subtitle, required this.accent, required this.icon});

  final String title;
  final String subtitle;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: accent,
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: const TextStyle(color: Color(0xB3E8EDFF), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterScoreFooter extends StatelessWidget {
  const _CenterScoreFooter();

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: 18,
      backgroundOpacity: 0.16,
      borderOpacity: 0.20,
      child: const Column(
        children: [
          Text('60', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 40, letterSpacing: -1.2)),
          Text('Latest Scored', style: TextStyle(color: Color(0xB3E8EDFF), fontSize: 11.5)),
        ],
      ),
    );
  }
}

class _ScoreHeroCard extends StatelessWidget {
  const _ScoreHeroCard();

  @override
  Widget build(BuildContext context) {
    return const NeonCard(
      accent: Color(0xFFFF4BDD),
      secondaryAccent: Color(0xFF6F4AFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PlayerAvatar(name: 'Sarah Williams', colors: [Color(0xFFFF5A87), Color(0xFF7A49FF)]),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusPill(label: 'WAITING', tinted: true),
                    SizedBox(height: 8),
                    Text('Sarah Williams', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Center(
            child: Text('301', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 56, letterSpacing: -2.0)),
          ),
          Center(
            child: Text('S.01  |  Roun 5', style: TextStyle(color: Color(0xB3E8EDFF), fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 12),
          Center(
            child: Text('✕  ★  ↻  ♡  ▽', style: TextStyle(color: Colors.white70, letterSpacing: 2)),
          ),
        ],
      ),
    );
  }
}

class _LiveFeedCard extends StatelessWidget {
  const _LiveFeedCard({required this.onSetup});

  final VoidCallback onSetup;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFFFF4BDD),
      secondaryAccent: const Color(0xFF2DB6FF),
      child: Column(
        children: [
          const PanelListTile(
            title: 'Mike Obhooy',
            subtitle: 'Trents      310',
            leading: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const PanelListTile(
            title: 'T. Nations',
            subtitle: 'Sed Of Vioy  0',
            leading: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const PanelListTile(
            title: 'Rehcroring',
            subtitle: 'Setting       30',
            leading: Icon(Icons.settings, color: Colors.white),
          ),
          const SizedBox(height: 14),
          const SectionHeading(title: 'Throw History', compact: true),
          const SizedBox(height: 10),
          const _HistoryLine(left: '60  - 3.20 low', right: '+0:35'),
          const _HistoryLine(left: '90  - 5.23 visit', right: '+0:50'),
          const _HistoryLine(left: '1.90 loss', right: '+0:12'),
          const _HistoryLine(left: '98 loss', right: '+0:18'),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: GlassButton(
              label: 'Quick Setup',
              icon: Icons.settings_suggest_rounded,
              onPressed: onSetup,
            ),
          ),
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

class _StaticBoardPainter extends CustomPainter {
  const _StaticBoardPainter();

  static const order = [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0x552DB6FF), Colors.transparent],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.1)),
    );

    const sweep = 3.141592653589793 / 10;
    void ring(double inner, double outer, Color a, Color b) {
      for (int i = 0; i < 20; i++) {
        final start = -3.141592653589793 / 2 + i * sweep;
        final path = Path()
          ..moveTo(center.dx + radius * inner * math.cos(start), center.dy + radius * inner * math.sin(start))
          ..arcTo(Rect.fromCircle(center: center, radius: radius * outer), start, sweep, false)
          ..lineTo(center.dx + radius * inner * math.cos(start + sweep), center.dy + radius * inner * math.sin(start + sweep))
          ..arcTo(Rect.fromCircle(center: center, radius: radius * inner), start + sweep, -sweep, false)
          ..close();
        canvas.drawPath(path, Paint()..color = i.isEven ? a : b);
        canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = const Color(0xDD101010));
      }
    }

    ring(0.62, 0.90, const Color(0xFFE8DAB3), const Color(0xFF121616));
    ring(0.54, 0.62, const Color(0xFF2AA18B), const Color(0xFFAF1233));
    ring(0.10, 0.54, const Color(0xFF121616), const Color(0xFFE8DAB3));
    ring(0.90, 1.00, const Color(0xFFAF1233), const Color(0xFF2AA18B));

    canvas.drawCircle(center, radius * 0.10, Paint()..color = const Color(0xFF2AA18B));
    canvas.drawCircle(center, radius * 0.05, Paint()..color = const Color(0xFFAF1233));

    final wire = Paint()..color = const Color(0xCC0B0B0B)..strokeWidth = 1;
    for (int i = 0; i < 20; i++) {
      final angle = -3.141592653589793 / 2 + i * sweep;
      canvas.drawLine(
        Offset(center.dx + radius * 0.10 * math.cos(angle), center.dy + radius * 0.10 * math.sin(angle)),
        Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle)),
        wire,
      );
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < 20; i++) {
      final angle = -3.141592653589793 / 2 + (i + 0.5) * sweep;
      final point = Offset(center.dx + radius * 0.80 * math.cos(angle), center.dy + radius * 0.80 * math.sin(angle));
      textPainter.text = TextSpan(
        text: '${order[i]}',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: radius * 0.09),
      );
      textPainter.layout();
      textPainter.paint(canvas, point - Offset(textPainter.width / 2, textPainter.height / 2));
    }

    final beam = Paint()
      ..shader = const LinearGradient(colors: [Color(0x00FFFFFF), Color(0xAA7FE1FF), Color(0x00FFFFFF)]).createShader(
        Rect.fromLTWH(center.dx - 40, center.dy - radius * 0.8, 80, radius * 1.2),
      );
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(0.72);
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 24, height: radius * 1.1), beam);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

