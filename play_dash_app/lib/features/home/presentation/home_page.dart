import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_shell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Play Dash',
      subtitle:
          'A rebuilt glassmorphism control surface for darts night — quieter blur, stronger structure, and fast navigation across setup, live play, and standings.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          StatusPill(
            label: 'Responsive shell',
            icon: Icons.devices_rounded,
            tinted: true,
          ),
          StatusPill(
            label: 'Live match controls',
            icon: Icons.motion_photos_on_rounded,
          ),
          StatusPill(
            label: 'Reduced blur / sharper contrast',
            icon: Icons.blur_on_rounded,
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
                    Expanded(flex: 7, child: _OverviewPanel()),
                    const SizedBox(width: 20),
                    Expanded(flex: 4, child: _ActionRail()),
                  ],
                )
              : Column(
                  children: const [
                    _OverviewPanel(),
                    SizedBox(height: 20),
                    _ActionRail(),
                  ],
                );
        },
      ),
    );
  }
}

class _OverviewPanel extends StatelessWidget {
  const _OverviewPanel();

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
            title: 'Arena overview',
            subtitle:
                'The home screen was rebuilt as a dashboard: a single visual hierarchy with summary metrics, a hero visual panel, and a clean action rail that scales from phone to desktop.',
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              MetricCard(
                label: 'Game modes',
                value: 'X01 + Cricket',
                icon: Icons.sports_score_outlined,
                highlight: true,
              ),
              MetricCard(
                label: 'Input',
                value: 'Interactive board',
                icon: Icons.touch_app_outlined,
              ),
              MetricCard(
                label: 'Players',
                value: '1 to 8 local',
                icon: Icons.groups_2_outlined,
              ),
            ],
          ),
          const SizedBox(height: 20),
          FrostPanel(
            radius: 30,
            blur: 8,
            backgroundOpacity: 0.4,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 760;
                final stats = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusPill(
                      label: 'Premium match console',
                      icon: Icons.auto_awesome_rounded,
                      tinted: true,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Focused scoring dashboard',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Cards are denser, edges are cleaner, and the background blur is intentionally restrained so score data stays legible while the glass look still reads clearly.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        ScoreBadge(value: '501 ready', highlight: true),
                        ScoreBadge(value: 'Tap board to throw'),
                        ScoreBadge(value: 'Fast turn tracking'),
                      ],
                    ),
                  ],
                );

                final art = AspectRatio(
                  aspectRatio: stacked ? 1.7 : 1.15,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0x338E7BFF),
                          Color(0x224FCFFF),
                          Color(0x12FFFFFF),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Stack(
                      children: const [
                        Positioned(top: 18, left: 18, child: _HeroChip()),
                        Positioned.fill(child: _DashboardArt()),
                      ],
                    ),
                  ),
                );

                if (stacked) {
                  return Column(
                    children: [stats, const SizedBox(height: 20), art],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: stats),
                    const SizedBox(width: 20),
                    Expanded(child: art),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final children = const [
                PanelListTile(
                  title: 'Low-blur frosted cards',
                  subtitle: 'Subtle backdrop filtering with stronger borders.',
                  leading: _FeatureIcon(icon: Icons.layers_outlined),
                ),
                PanelListTile(
                  title: 'Responsive control flow',
                  subtitle: 'Desktop side rail and mobile dock share one layout language.',
                  leading: _FeatureIcon(icon: Icons.aspect_ratio_rounded),
                ),
                PanelListTile(
                  title: 'Match-first UX',
                  subtitle: 'Fast actions, quick scanning, and persistent score context.',
                  leading: _FeatureIcon(icon: Icons.speed_rounded),
                ),
              ];

              return compact
                  ? Column(children: children)
                  : Row(
                      children: [
                        for (var i = 0; i < children.length; i++) ...[
                          Expanded(child: children[i]),
                          if (i != children.length - 1)
                            const SizedBox(width: 12),
                        ]
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionRail extends StatelessWidget {
  const _ActionRail();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 34,
      blur: 9,
      opacity: 0.48,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeading(
            title: 'Quick launch',
            subtitle:
                'Primary routes are grouped into one clear action stack that stays finger-friendly on mobile and aligned in a desktop rail.',
          ),
          const SizedBox(height: 20),
          GlassButton(
            onPressed: () => context.go('/setup'),
            icon: Icons.groups_2_rounded,
            label: 'Player Setup',
            highlight: true,
          ),
          const SizedBox(height: 12),
          GlassButton(
            onPressed: () => context.go('/match/x01'),
            icon: Icons.sports_score_rounded,
            label: 'Launch X01',
          ),
          const SizedBox(height: 12),
          GlassButton(
            onPressed: () => context.go('/match/cricket'),
            icon: Icons.track_changes_rounded,
            label: 'Launch Cricket',
          ),
          const SizedBox(height: 12),
          GlassButton(
            onPressed: () => context.go('/leaderboard'),
            icon: Icons.emoji_events_rounded,
            label: 'Season Leaderboard',
          ),
          const SizedBox(height: 20),
          const PanelListTile(
            title: 'Tonight’s profile',
            subtitle: 'Glass cards, vivid gradients, and match telemetry stay consistent across every route.',
            leading: _FeatureIcon(icon: Icons.insights_rounded),
            trailing: ScoreBadge(value: 'Live'),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: const Text('Arena layout'),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  const _FeatureIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.16),
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary),
    );
  }
}

class _DashboardArt extends StatelessWidget {
  const _DashboardArt();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: FrostPanel(
                    radius: 26,
                    blur: 7,
                    backgroundOpacity: 0.36,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ScoreBadge(value: 'Player 01', highlight: true),
                        SizedBox(height: 12),
                        Expanded(child: _ChartMock()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: const [
                      Expanded(
                        child: FrostPanel(
                          radius: 24,
                          blur: 7,
                          backgroundOpacity: 0.34,
                          child: Center(child: ScoreBadge(value: '137', highlight: true)),
                        ),
                      ),
                      SizedBox(height: 14),
                      Expanded(
                        child: FrostPanel(
                          radius: 24,
                          blur: 7,
                          backgroundOpacity: 0.34,
                          child: _MiniStats(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const FrostPanel(
            radius: 24,
            blur: 7,
            backgroundOpacity: 0.34,
            child: Row(
              children: [
                Expanded(child: ScoreBadge(value: 'D20')),
                SizedBox(width: 10),
                Expanded(child: ScoreBadge(value: 'T19')),
                SizedBox(width: 10),
                Expanded(child: ScoreBadge(value: 'Bull', highlight: true)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStats extends StatelessWidget {
  const _MiniStats();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Avg 61.4'),
        Text('Checkout 40'),
        Text('3 darts used'),
      ],
    );
  }
}

class _ChartMock extends StatelessWidget {
  const _ChartMock();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ChartPainter());
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final path = Path()
      ..moveTo(0, size.height * 0.78)
      ..cubicTo(size.width * 0.18, size.height * 0.6, size.width * 0.32,
          size.height * 0.82, size.width * 0.48, size.height * 0.48)
      ..cubicTo(size.width * 0.68, size.height * 0.1, size.width * 0.78,
          size.height * 0.5, size.width, size.height * 0.18);

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF8E7BFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
