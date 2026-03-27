import 'dart:ui';

import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.title,
    required this.subtitle,
    required this.child,
    this.hero,
    this.actions,
    this.floatingOverlay,
    this.floatingOverlayHeight = 0,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? hero;
  final List<Widget>? actions;
  final Widget? floatingOverlay;
  final double floatingOverlayHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B1020), Color(0xFF0F1830), Color(0xFF050811)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _AmbientBackdrop()),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final hPadding = constraints.maxWidth >= 1280
                      ? 40.0
                      : constraints.maxWidth >= 900
                          ? 28.0
                          : 16.0;
                  final topInset = floatingOverlay == null
                      ? 16.0
                      : floatingOverlayHeight + 28.0;

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1360),
                      child: Stack(
                        children: [
                          ListView(
                            padding: EdgeInsets.fromLTRB(
                                hPadding, topInset, hPadding, 28),
                            children: [
                              FrostPanel(
                                padding: EdgeInsets.all(
                                    constraints.maxWidth >= 720 ? 28 : 22),
                                radius: 34,
                                blur: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                              const SizedBox(height: 10),
                                              ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 820),
                                                child: Text(
                                                  subtitle,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        _TopBadge(),
                                      ],
                                    ),
                                    if (hero != null) ...[
                                      const SizedBox(height: 20),
                                      hero!,
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 22),
                              child,
                            ],
                          ),
                          if (floatingOverlay != null)
                            Positioned(
                              top: 12,
                              left: hPadding,
                              right: hPadding,
                              child: floatingOverlay!,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FrostPanel extends StatelessWidget {
  const FrostPanel({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 28,
    this.blur = 7,
    this.backgroundOpacity = 0.58,
    this.borderOpacity = 0.16,
    this.highlight = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;
  final double backgroundOpacity;
  final double borderOpacity;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(radius);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: highlight ? 0.18 : 0.12),
                scheme.surfaceContainerHigh
                    .withValues(alpha: backgroundOpacity),
                scheme.surfaceContainer
                    .withValues(alpha: backgroundOpacity - 0.10),
              ],
            ),
            border: Border.all(
                color: Colors.white.withValues(alpha: borderOpacity)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.20),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: (highlight ? scheme.primary : Colors.white)
                    .withValues(alpha: highlight ? 0.12 : 0.03),
                blurRadius: 18,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class GlassPanel extends FrostPanel {
  const GlassPanel({
    required super.child,
    super.padding,
    super.radius,
    double opacity = 0.58,
    super.borderOpacity = 0.16,
    super.blur = 7,
    super.key,
  }) : super(
          backgroundOpacity: opacity,
        );
}

class GlassButton extends StatelessWidget {
  const GlassButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.highlight = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: highlight
                  ? [
                      scheme.primary.withValues(alpha: 0.92),
                      scheme.secondary.withValues(alpha: 0.84)
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.11),
                      scheme.surfaceContainerHighest.withValues(alpha: 0.54)
                    ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            boxShadow: [
              BoxShadow(
                color: (highlight ? scheme.primary : Colors.black)
                    .withValues(alpha: 0.22),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: highlight ? scheme.onPrimary : scheme.onSurface),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: highlight ? scheme.onPrimary : scheme.onSurface,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(
      {required this.title, required this.subtitle, this.trailing, super.key});

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.label,
    required this.value,
    this.icon,
    this.highlight = false,
    this.compact = false,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final bool highlight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(minWidth: compact ? 150 : 180),
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: highlight ? 0.18 : 0.10),
            (highlight ? scheme.primary : scheme.surfaceContainerHighest)
                .withValues(alpha: highlight ? 0.16 : 0.52),
          ],
        ),
        border: Border.all(
            color: Colors.white.withValues(alpha: highlight ? 0.18 : 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              width: compact ? 38 : 42,
              height: compact ? 38 : 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primary.withValues(alpha: 0.16),
              ),
              child: Icon(icon, color: scheme.primary),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 6),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: (compact
                          ? Theme.of(context).textTheme.titleMedium
                          : Theme.of(context).textTheme.titleLarge)
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill(
      {required this.label, this.icon, this.tinted = false, super.key});

  final String label;
  final IconData? icon;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: tinted
            ? scheme.primary.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.07),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 16, color: tinted ? scheme.primary : scheme.onSurface),
            const SizedBox(width: 8),
          ],
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class _TopBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Glass UI', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text('Subtle blur • sharp contrast',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _AmbientBackdrop extends StatelessWidget {
  const _AmbientBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Positioned(
            top: -120,
            left: -80,
            child: _GlowOrb(size: 300, color: Color(0xFF6E67FF))),
        Positioned(
            top: 80,
            right: -60,
            child: _GlowOrb(size: 240, color: Color(0xFF4FCFFF))),
        Positioned(
            bottom: -100,
            left: 80,
            child: _GlowOrb(size: 260, color: Color(0xFFFF74AC))),
        Positioned(bottom: 120, right: 60, child: _GridHalo()),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.32),
              color.withValues(alpha: 0.06),
              Colors.transparent
            ],
          ),
        ),
      ),
    );
  }
}

class _GridHalo extends StatelessWidget {
  const _GridHalo();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child:
          CustomPaint(size: const Size(280, 280), painter: _GridHaloPainter()),
    );
  }
}

class _GridHaloPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x226E67FF), Colors.transparent],
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(48)), paint);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    const step = 28.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
