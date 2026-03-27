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
          'A rebuilt glassmorphism dashboard with restrained blur, sharp hierarchy, and responsive panels tuned for mobile, tablet, and desktop play.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          StatusPill(
              label: 'Live scoring',
              icon: Icons.auto_graph_rounded,
              tinted: true),
          StatusPill(label: 'Subtle glass layers', icon: Icons.blur_on_rounded),
          StatusPill(label: 'Mobile → Web', icon: Icons.devices_rounded),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1040;
          final lead = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 28 : 22),
            radius: 32,
            opacity: 0.54,
            blur: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  title: 'Choose a game mode',
                  subtitle:
                      'The home view was rebuilt around a hero dashboard card, dense match stats, and clear action hierarchy to mirror a premium game control surface.',
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    MetricCard(
                        label: 'Game modes',
                        value: 'X01 + Cricket',
                        icon: Icons.sports_score_outlined),
                    MetricCard(
                        label: 'Input model',
                        value: 'Interactive board',
                        icon: Icons.touch_app_outlined),
                    MetricCard(
                        label: 'Style',
                        value: 'Low-blur glass',
                        icon: Icons.dashboard_customize_outlined,
                        highlight: true),
                  ],
                ),
                const SizedBox(height: 22),
                FrostPanel(
                  radius: 28,
                  blur: 6,
                  backgroundOpacity: 0.46,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Night-session control center',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      Text(
                        'Layered color glows, stronger text contrast, and cleaner spacing were used to rebuild the UI so scorekeeping remains readable at a glance without the over-soft blur common in generic glassmorphism.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        height: constraints.maxWidth >= 720 ? 220 : 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0x338C7BFF),
                              Color(0x2252D1FF),
                              Color(0x18FFFFFF)
                            ],
                          ),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.10)),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 18,
                              left: 18,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                                child: const Text('Premium match view'),
                              ),
                            ),
                            const Positioned(
                                right: 22, top: 24, child: _MiniChart()),
                            Positioned(
                              left: 22,
                              right: 22,
                              bottom: 22,
                              child: Row(
                                children: const [
                                  Expanded(
                                      child: MetricCard(
                                          label: 'Players',
                                          value: 'Up to 8',
                                          compact: true,
                                          icon: Icons.groups_2_outlined)),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: MetricCard(
                                          label: 'Feedback',
                                          value: 'Hit highlight',
                                          compact: true,
                                          icon: Icons.ads_click_outlined)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          final actions = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 26 : 22),
            radius: 32,
            opacity: 0.54,
            blur: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeading(
                  title: 'Quick actions',
                  subtitle:
                      'Primary paths are grouped into one action rail for faster navigation and cleaner scanning on narrow screens.',
                ),
                const SizedBox(height: 22),
                GlassButton(
                    onPressed: () => context.go('/setup'),
                    icon: Icons.groups_2_outlined,
                    label: 'Player Setup',
                    highlight: true),
                const SizedBox(height: 12),
                GlassButton(
                    onPressed: () => context.go('/match/x01'),
                    icon: Icons.sports_score_outlined,
                    label: 'Play X01'),
                const SizedBox(height: 12),
                GlassButton(
                    onPressed: () => context.go('/match/cricket'),
                    icon: Icons.track_changes_outlined,
                    label: 'Play Cricket'),
                const SizedBox(height: 12),
                GlassButton(
                    onPressed: () => context.go('/leaderboard'),
                    icon: Icons.emoji_events_outlined,
                    label: 'Leaderboard'),
              ],
            ),
          );

          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 7, child: lead),
                  const SizedBox(width: 20),
                  Expanded(flex: 4, child: actions)
                ])
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [lead, const SizedBox(height: 20), actions]);
        },
      ),
    );
  }
}

class _MiniChart extends StatelessWidget {
  const _MiniChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 110,
      child: CustomPaint(
        painter: _MiniChartPainter(),
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final path = Path()
      ..moveTo(0, size.height * 0.78)
      ..cubicTo(size.width * 0.18, size.height * 0.62, size.width * 0.35,
          size.height * 0.85, size.width * 0.52, size.height * 0.48)
      ..cubicTo(size.width * 0.68, size.height * 0.16, size.width * 0.82,
          size.height * 0.42, size.width, size.height * 0.08);

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF8C7BFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
