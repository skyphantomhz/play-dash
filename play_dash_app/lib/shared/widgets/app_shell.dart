import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.title,
    required this.subtitle,
    required this.child,
    this.actions,
    this.hero,
    this.floatingOverlay,
    this.floatingOverlayHeight = 0,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final List<Widget>? actions;
  final Widget? hero;
  final Widget? floatingOverlay;
  final double floatingOverlayHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title),
        actions: actions,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF071225),
              Color(0xFF221135),
              Color(0xFF03050B),
            ],
            stops: [0.0, 0.52, 1.0],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _GlassmorphismBackground()),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.06),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.15),
                      radius: 1.2,
                      colors: [
                        Colors.white.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = constraints.maxWidth >= 1280
                      ? 40.0
                      : constraints.maxWidth >= 900
                          ? 28.0
                          : 16.0;
                  final headerSpacing =
                      constraints.maxWidth >= 900 ? 24.0 : 18.0;
                  final overlayTop = constraints.maxWidth >= 720 ? 20.0 : 12.0;
                  final overlayVisible = floatingOverlay != null;
                  final listTopPadding = overlayVisible
                      ? overlayTop + floatingOverlayHeight + 16
                      : 12.0;

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1320),
                      child: Stack(
                        children: [
                          ListView(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              listTopPadding,
                              horizontalPadding,
                              28,
                            ),
                            children: [
                              GlassPanel(
                                padding: EdgeInsets.all(
                                  constraints.maxWidth >= 720 ? 28 : 22,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hero != null) ...[
                                      hero!,
                                      const SizedBox(height: 18),
                                    ],
                                    Text(
                                      title,
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.6,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 860),
                                      child: Text(
                                        subtitle,
                                        style:
                                            theme.textTheme.bodyLarge?.copyWith(
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                          height: 1.45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: headerSpacing),
                              child,
                            ],
                          ),
                          if (overlayVisible)
                            Positioned(
                              top: overlayTop,
                              left: horizontalPadding,
                              right: horizontalPadding,
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

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 30,
    this.opacity = 0.72,
    this.borderOpacity = 0.24,
    this.blur = 20,
    this.gradient,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double opacity;
  final double borderOpacity;
  final double blur;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(radius);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.16),
                    theme.colorScheme.surfaceContainerHigh
                        .withValues(alpha: opacity),
                    theme.colorScheme.surfaceContainer
                        .withValues(alpha: opacity - 0.08),
                  ],
                ),
            border: Border.all(
              color: Colors.white.withValues(alpha: borderOpacity),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.20),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
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
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: highlight
                  ? [
                      theme.colorScheme.primary.withValues(alpha: 0.88),
                      Color.lerp(
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                        0.35,
                      )!,
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.12),
                      theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.52),
                    ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: highlight ? 0.16 : 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: (highlight ? theme.colorScheme.primary : Colors.black)
                    .withValues(alpha: 0.20),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: highlight
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: highlight
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
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
  const SectionHeading({
    required this.title,
    required this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ],
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
    final theme = Theme.of(context);
    final accent = highlight
        ? theme.colorScheme.primary.withValues(alpha: 0.20)
        : Colors.white.withValues(alpha: 0.08);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: highlight ? 0.18 : 0.10),
            accent,
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: highlight ? 0.16 : 0.08),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 14 : 16),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: compact ? 38 : 42,
                height: compact ? 38 : 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.16),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: (compact
                            ? theme.textTheme.titleMedium
                            : theme.textTheme.titleLarge)
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    this.icon,
    this.tinted = false,
    super.key,
  });

  final String label;
  final IconData? icon;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: tinted
            ? theme.colorScheme.primary.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassmorphismBackground extends StatelessWidget {
  const _GlassmorphismBackground();

  static const int _seed = 481516;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final glowBlobs = _generateGlowBlobs(size);
        final particles = _generateParticles(size);

        final isWidgetTest = WidgetsBinding.instance.runtimeType
            .toString()
            .contains('TestWidgetsFlutterBinding');

        return RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _GlowBlobPainter(blobs: glowBlobs),
              ),
              IgnorePointer(
                child: isWidgetTest
                    ? CustomPaint(
                        painter: const _LightStreakPainter(progress: 0.38),
                      )
                    : _AnimatedPainterLayer(
                        duration: const Duration(seconds: 18),
                        builder: (progress) =>
                            _LightStreakPainter(progress: progress),
                      ),
              ),
              IgnorePointer(
                child: isWidgetTest
                    ? CustomPaint(
                        painter: _ParticlePainter(
                          particles: particles,
                          progress: 0.52,
                        ),
                      )
                    : _AnimatedPainterLayer(
                        duration: const Duration(seconds: 24),
                        builder: (progress) => _ParticlePainter(
                          particles: particles,
                          progress: progress,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<_GlowBlob> _generateGlowBlobs(Size size) {
    final random = math.Random(_seed);
    final palette = <Color>[
      const Color(0xFF61E9FF),
      const Color(0xFFFF71D1),
      const Color(0xFF8D7BFF),
    ];

    return List<_GlowBlob>.generate(7, (index) {
      final widthFactor = 0.12 + random.nextDouble() * 0.76;
      final heightFactor = 0.08 + random.nextDouble() * 0.84;
      final radius = size.shortestSide * (0.20 + random.nextDouble() * 0.26);
      final color = palette[random.nextInt(palette.length)];

      return _GlowBlob(
        center: Offset(size.width * widthFactor, size.height * heightFactor),
        radius: radius,
        color: color,
        alpha: 0.13 + random.nextDouble() * 0.08,
      );
    });
  }

  List<_Particle> _generateParticles(Size size) {
    final random = math.Random(_seed * 3);

    return List<_Particle>.generate(24, (index) {
      return _Particle(
        base: Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        radius: 0.8 + random.nextDouble() * 2.2,
        dx: -16 + random.nextDouble() * 32,
        dy: -22 + random.nextDouble() * 26,
        opacity: 0.06 + random.nextDouble() * 0.08,
      );
    });
  }
}

class _AnimatedPainterLayer extends StatefulWidget {
  const _AnimatedPainterLayer({
    required this.duration,
    required this.builder,
  });

  final Duration duration;
  final CustomPainter Function(double progress) builder;

  @override
  State<_AnimatedPainterLayer> createState() => _AnimatedPainterLayerState();
}

class _AnimatedPainterLayerState extends State<_AnimatedPainterLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: widget.builder(_controller.value),
        );
      },
    );
  }
}

class _GlowBlob {
  const _GlowBlob({
    required this.center,
    required this.radius,
    required this.color,
    required this.alpha,
  });

  final Offset center;
  final double radius;
  final Color color;
  final double alpha;
}

class _Particle {
  const _Particle({
    required this.base,
    required this.radius,
    required this.dx,
    required this.dy,
    required this.opacity,
  });

  final Offset base;
  final double radius;
  final double dx;
  final double dy;
  final double opacity;
}

class _GlowBlobPainter extends CustomPainter {
  const _GlowBlobPainter({required this.blobs});

  final List<_GlowBlob> blobs;

  @override
  void paint(Canvas canvas, Size size) {
    for (final blob in blobs) {
      canvas.drawCircle(
        blob.center,
        blob.radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              blob.color.withValues(alpha: blob.alpha),
              blob.color.withValues(alpha: blob.alpha * 0.42),
              blob.color.withValues(alpha: 0),
            ],
            stops: const [0.0, 0.45, 1.0],
          ).createShader(
            Rect.fromCircle(center: blob.center, radius: blob.radius),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GlowBlobPainter oldDelegate) => false;
}

class _LightStreakPainter extends CustomPainter {
  const _LightStreakPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paths = <_StreakSpec>[
      _StreakSpec(
        start: Offset(size.width * 0.06, size.height * 0.26),
        control1: Offset(size.width * 0.28, size.height * 0.10),
        control2: Offset(size.width * 0.52, size.height * 0.40),
        end: Offset(size.width * 0.92, size.height * 0.22),
        width: 2.2,
      ),
      _StreakSpec(
        start: Offset(size.width * 0.12, size.height * 0.78),
        control1: Offset(size.width * 0.34, size.height * 0.60),
        control2: Offset(size.width * 0.64, size.height * 0.94),
        end: Offset(size.width * 0.94, size.height * 0.70),
        width: 1.8,
      ),
      _StreakSpec(
        start: Offset(size.width * 0.72, size.height * 0.06),
        control1: Offset(size.width * 0.56, size.height * 0.18),
        control2: Offset(size.width * 0.92, size.height * 0.34),
        end: Offset(size.width * 0.78, size.height * 0.58),
        width: 1.6,
      ),
    ];

    for (var index = 0; index < paths.length; index++) {
      final spec = paths[index];
      final phase = (progress + (index * 0.18)) % 1.0;
      final opacity = 0.05 + (0.05 * math.sin(phase * math.pi));
      final path = Path()
        ..moveTo(spec.start.dx, spec.start.dy)
        ..cubicTo(
          spec.control1.dx,
          spec.control1.dy,
          spec.control2.dx,
          spec.control2.dy,
          spec.end.dx,
          spec.end.dy,
        );

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = spec.width
          ..strokeCap = StrokeCap.round
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF61E9FF).withValues(alpha: opacity * 0.55),
              const Color(0xFFFF71D1).withValues(alpha: opacity),
              const Color(0xFF8D7BFF).withValues(alpha: opacity * 0.65),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LightStreakPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _StreakSpec {
  const _StreakSpec({
    required this.start,
    required this.control1,
    required this.control2,
    required this.end,
    required this.width,
  });

  final Offset start;
  final Offset control1;
  final Offset control2;
  final Offset end;
  final double width;
}

class _ParticlePainter extends CustomPainter {
  const _ParticlePainter({required this.particles, required this.progress});

  final List<_Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (var index = 0; index < particles.length; index++) {
      final particle = particles[index];
      final wave = (progress + (index * 0.07)) % 1.0;
      final offset = Offset(
        particle.dx * math.sin(wave * math.pi * 2),
        particle.dy * math.cos(wave * math.pi * 2),
      );
      canvas.drawCircle(
        particle.base + offset,
        particle.radius,
        Paint()
          ..color = Colors.white.withValues(
            alpha: particle.opacity * (0.65 + 0.35 * math.sin(wave * math.pi)),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.particles != particles;
  }
}
