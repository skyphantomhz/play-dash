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
          'A rebuilt darts dashboard with crisp hierarchy, restrained glass panels, and a responsive split layout designed for live scoring.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          StatusPill(
            label: 'Low-blur glassmorphism',
            icon: Icons.blur_on_rounded,
            tinted: true,
          ),
          StatusPill(
            label: 'Touch-first match flow',
            icon: Icons.touch_app_rounded,
          ),
          StatusPill(
            label: 'Desktop + mobile responsive',
            icon: Icons.devices_rounded,
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
                    Expanded(flex: 7, child: _HomeOverview()),
                    SizedBox(width: 18),
                    Expanded(flex: 4, child: _HomeActions()),
                  ],
                )
              : const Column(
                  children: [
                    _HomeOverview(),
                    SizedBox(height: 18),
                    _HomeActions(),
                  ],
                );
        },
      ),
    );
  }
}

class _HomeOverview extends StatelessWidget {
  const _HomeOverview();

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
            title: 'Arena overview',
            subtitle:
                'The landing screen is rebuilt into one primary dashboard: headline metrics, a hero composition, and concise secondary cards for quick scanning.',
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              MetricCard(
                label: 'Modes',
                value: 'X01 + Cricket',
                icon: Icons.sports_score_rounded,
                highlight: true,
              ),
              MetricCard(
                label: 'Sessions',
                value: '1 to 8 players',
                icon: Icons.groups_2_rounded,
              ),
              MetricCard(
                label: 'Input',
                value: 'Interactive board',
                icon: Icons.ads_click_rounded,
              ),
            ],
          ),
          const SizedBox(height: 18),
          FrostPanel(
            radius: 30,
            blur: 5,
            backgroundOpacity: 0.34,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 760;
                final summary = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StatusPill(
                      label: 'Premium match console',
                      icon: Icons.auto_awesome_rounded,
                      tinted: true,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Focused scoring, minimal visual noise',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Cards are denser, blur is softer, and borders are more deliberate so the glass look stays elegant without sacrificing legibility during play.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        ScoreBadge(value: '501 ready', highlight: true),
                        ScoreBadge(value: 'Tap board to throw'),
                        ScoreBadge(value: 'Live standings'),
                      ],
                    ),
                  ],
                );

                final visual = AspectRatio(
                  aspectRatio: stacked ? 1.6 : 1.05,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0x338A7BFF),
                          Color(0x224FCBFF),
                          Color(0x0DFFFFFF),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(18),
                      child: _ArenaPreview(),
                    ),
                  ),
                );

                if (stacked) {
                  return Column(
                    children: [summary, const SizedBox(height: 18), visual],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: summary),
                    const SizedBox(width: 18),
                    Expanded(child: visual),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final tiles = const [
                PanelListTile(
                  title: 'Subtle blur treatment',
                  subtitle: 'Glass panels use lower sigma and stronger borders.',
                  leading: Icon(Icons.blur_circular_rounded),
                ),
                PanelListTile(
                  title: 'Fast launch flow',
                  subtitle: 'Setup, play, and leaderboard routes stay one tap away.',
                  leading: Icon(Icons.rocket_launch_rounded),
                ),
                PanelListTile(
                  title: 'Live-first hierarchy',
                  subtitle: 'Scores and active-player state dominate the layout.',
                  leading: Icon(Icons.stacked_line_chart_rounded),
                ),
              ];

              return compact
                  ? Column(children: tiles)
                  : Row(
                      children: [
                        for (var i = 0; i < tiles.length; i++) ...[
                          Expanded(child: tiles[i]),
                          if (i < tiles.length - 1) const SizedBox(width: 12),
                        ],
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
}

class _HomeActions extends StatelessWidget {
  const _HomeActions();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 36,
      blur: 6,
      opacity: 0.42,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeading(
            title: 'Quick launch',
            subtitle:
                'A vertical action stack mirrors the reference-style control rail with clear primary and secondary routes.',
          ),
          const SizedBox(height: 18),
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
          const SizedBox(height: 18),
          const PanelListTile(
            title: 'Tonight’s profile',
            subtitle: 'Quiet glass layers, stronger data emphasis, and consistent interaction feedback across all screens.',
            leading: Icon(Icons.nights_stay_rounded),
            trailing: ScoreBadge(value: 'Live'),
          ),
        ],
      ),
    );
  }
}

class _ArenaPreview extends StatelessWidget {
  const _ArenaPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: FrostPanel(
                radius: 22,
                child: _PreviewStat(title: 'Current', value: 'Morgan'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: FrostPanel(
                radius: 22,
                child: _PreviewStat(title: 'Checkout', value: '137'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: FrostPanel(
                  radius: 26,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ScoreBadge(value: 'Player performance', highlight: true),
                      const SizedBox(height: 14),
                      Expanded(child: CustomPaint(painter: _ChartPainter())),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Column(
                  children: const [
                    Expanded(
                      child: FrostPanel(
                        radius: 24,
                        child: Center(
                          child: ScoreBadge(value: '61.4 avg', highlight: true),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: FrostPanel(
                        radius: 24,
                        child: _LegSummary(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const FrostPanel(
          radius: 24,
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
    );
  }
}

class _PreviewStat extends StatelessWidget {
  const _PreviewStat({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _LegSummary extends StatelessWidget {
  const _LegSummary();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('3 darts used'),
        Text('Best visit 140'),
        Text('Next: double 20'),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  const _ChartPainter();

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
      ..moveTo(0, size.height * 0.76)
      ..cubicTo(size.width * 0.16, size.height * 0.56, size.width * 0.34,
          size.height * 0.84, size.width * 0.48, size.height * 0.48)
      ..cubicTo(size.width * 0.66, size.height * 0.10, size.width * 0.82,
          size.height * 0.44, size.width, size.height * 0.18);

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF8C80FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.4,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
