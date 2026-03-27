import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/dart_throw.dart';
import 'app_shell.dart';

class InteractiveDartboard extends StatefulWidget {
  const InteractiveDartboard(
      {required this.onThrow, this.enabled = true, super.key});

  final ValueChanged<DartThrow> onThrow;
  final bool enabled;

  static const List<int> _segmentOrder = <int>[
    20,
    1,
    18,
    4,
    13,
    6,
    10,
    15,
    2,
    17,
    3,
    19,
    7,
    16,
    8,
    11,
    14,
    9,
    12,
    5
  ];

  @override
  State<InteractiveDartboard> createState() => _InteractiveDartboardState();
}

class _InteractiveDartboardState extends State<InteractiveDartboard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  _BoardHit? _lastHit;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          title: 'X01 Game',
          subtitle:
              'Tap any ring or segment. The board keeps precise hit feedback, but with tighter and more restrained glow treatment.',
        ),
        const SizedBox(height: 18),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final pulse = Curves.easeOut.transform(1 - _controller.value);
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.12 * pulse),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.24),
                    blurRadius: 24,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: child,
            );
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size =
                    math.min(constraints.maxWidth, constraints.maxHeight);
                return Center(
                  child: GestureDetector(
                    onTapUp: widget.enabled
                        ? (details) {
                            final box =
                                context.findRenderObject() as RenderBox?;
                            if (box == null) return;
                            final local =
                                box.globalToLocal(details.globalPosition);
                            final result =
                                _throwForPosition(local, Size(size, size));
                            setState(() => _lastHit = result.hit);
                            _controller
                              ..reset()
                              ..forward();
                            widget.onThrow(result.dartThrow);
                          }
                        : null,
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: CustomPaint(
                        painter: _DartboardPainter(
                          colorScheme: scheme,
                          highlight: _lastHit,
                          progress: _controller.value,
                          disabled: !widget.enabled,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            const _LegendChip(label: 'Single', color: Color(0xFF1C2434)),
            const _LegendChip(label: 'Double', color: Color(0xFFE56A6E)),
            const _LegendChip(label: 'Triple', color: Color(0xFF3CC9A3)),
            _LegendChip(
              label: _lastHit == null
                  ? 'Ready'
                  : _formatThrow(_lastHit!.dartThrow),
              color: scheme.primary,
            ),
          ],
        ),
      ],
    );
  }

  _ThrowResult _throwForPosition(Offset position, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final radius = size.width / 2;
    final normalizedDistance = math.sqrt((dx * dx) + (dy * dy)) / radius;

    if (normalizedDistance > 1) {
      const miss = DartThrow(segment: 0, multiplier: 0);
      return const _ThrowResult(
          dartThrow: miss,
          hit: _BoardHit(segment: 0, multiplier: 0, ring: _BoardRing.miss));
    }
    if (normalizedDistance <= 0.05) {
      const bull = DartThrow(segment: 25, multiplier: 2);
      return const _ThrowResult(
          dartThrow: bull,
          hit: _BoardHit(segment: 25, multiplier: 2, ring: _BoardRing.bull));
    }
    if (normalizedDistance <= 0.10) {
      const outerBull = DartThrow(segment: 25, multiplier: 1);
      return const _ThrowResult(
          dartThrow: outerBull,
          hit: _BoardHit(
              segment: 25, multiplier: 1, ring: _BoardRing.outerBull));
    }

    final angle =
        (math.atan2(dy, dx) + (math.pi / 2) + (2 * math.pi)) % (2 * math.pi);
    final wedge = (angle / (math.pi / 10)).floor() %
        InteractiveDartboard._segmentOrder.length;
    final segment = InteractiveDartboard._segmentOrder[wedge];

    if (normalizedDistance >= 0.90) {
      final dart = DartThrow(segment: segment, multiplier: 2);
      return _ThrowResult(
          dartThrow: dart,
          hit: _BoardHit(
              segment: segment, multiplier: 2, ring: _BoardRing.double));
    }
    if (normalizedDistance >= 0.54 && normalizedDistance <= 0.62) {
      final dart = DartThrow(segment: segment, multiplier: 3);
      return _ThrowResult(
          dartThrow: dart,
          hit: _BoardHit(
              segment: segment, multiplier: 3, ring: _BoardRing.triple));
    }

    final ring = normalizedDistance < 0.54
        ? _BoardRing.innerSingle
        : _BoardRing.outerSingle;
    final dart = DartThrow(segment: segment, multiplier: 1);
    return _ThrowResult(
        dartThrow: dart,
        hit: _BoardHit(segment: segment, multiplier: 1, ring: ring));
  }

  static String _formatThrow(DartThrow dartThrow) {
    if (dartThrow.segment == 0 || dartThrow.multiplier == 0) return 'Miss';
    if (dartThrow.segment == 25) {
      return dartThrow.multiplier == 2 ? 'Bull' : 'Outer Bull';
    }
    return switch (dartThrow.multiplier) {
      1 => 'S${dartThrow.segment}',
      2 => 'D${dartThrow.segment}',
      3 => 'T${dartThrow.segment}',
      _ => '${dartThrow.multiplier}x ${dartThrow.segment}',
    };
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _DartboardPainter extends CustomPainter {
  const _DartboardPainter(
      {required this.colorScheme,
      required this.highlight,
      required this.progress,
      required this.disabled});

  final ColorScheme colorScheme;
  final _BoardHit? highlight;
  final double progress;
  final bool disabled;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final pulse = Curves.easeOut.transform(1 - progress);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF263449), Color(0xFF0E1522)],
          stops: [0.12, 1],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    _drawRing(canvas, center, radius, 0.62, 0.90, const Color(0xFFF1E4CC),
        const Color(0xFF1A2232), _BoardRing.outerSingle, pulse);
    _drawRing(canvas, center, radius, 0.54, 0.62, const Color(0xFF3CC9A3),
        const Color(0xFFE56A6E), _BoardRing.triple, pulse);
    _drawRing(canvas, center, radius, 0.10, 0.54, const Color(0xFF1A2232),
        const Color(0xFFF1E4CC), _BoardRing.innerSingle, pulse);
    _drawRing(canvas, center, radius, 0.90, 1.0, const Color(0xFFE56A6E),
        const Color(0xFF3CC9A3), _BoardRing.double, pulse);

    _drawBull(canvas, center, radius, pulse);
    _drawWires(canvas, center, radius);
    _drawLabels(canvas, center, radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.028
        ..color = Colors.white.withValues(alpha: 0.18),
    );

    if (disabled) {
      canvas.drawCircle(center, radius,
          Paint()..color = Colors.black.withValues(alpha: 0.36));
    }
  }

  void _drawRing(
      Canvas canvas,
      Offset center,
      double radius,
      double innerFactor,
      double outerFactor,
      Color evenColor,
      Color oddColor,
      _BoardRing ring,
      double pulse) {
    const sweep = math.pi / 10;
    final innerRadius = radius * innerFactor;
    final outerRadius = radius * outerFactor;

    for (var index = 0;
        index < InteractiveDartboard._segmentOrder.length;
        index++) {
      final segment = InteractiveDartboard._segmentOrder[index];
      final start = (-math.pi / 2) + (index * sweep);
      final isHighlighted =
          highlight?.segment == segment && highlight?.ring == ring;
      final path = Path()
        ..moveTo(center.dx + (innerRadius * math.cos(start)),
            center.dy + (innerRadius * math.sin(start)))
        ..arcTo(Rect.fromCircle(center: center, radius: outerRadius), start,
            sweep, false)
        ..lineTo(center.dx + (innerRadius * math.cos(start + sweep)),
            center.dy + (innerRadius * math.sin(start + sweep)))
        ..arcTo(Rect.fromCircle(center: center, radius: innerRadius),
            start + sweep, -sweep, false)
        ..close();

      final base = index.isEven ? evenColor : oddColor;
      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(base, Colors.white, 0.08)!,
              base,
              Color.lerp(base, Colors.black, 0.10)!
            ],
          ).createShader(Rect.fromCircle(center: center, radius: outerRadius)),
      );

      if (isHighlighted) {
        final color = _highlightColor(ring);
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5
            ..color = color.withValues(alpha: 0.90 - (0.12 * progress)),
        );
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.fill
            ..color = color.withValues(alpha: 0.18 + (0.10 * pulse)),
        );
      }

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.white.withValues(alpha: 0.16),
      );
    }
  }

  void _drawBull(Canvas canvas, Offset center, double radius, double pulse) {
    final outerBullSelected = highlight?.ring == _BoardRing.outerBull;
    final bullSelected = highlight?.ring == _BoardRing.bull;

    canvas.drawCircle(
        center, radius * 0.10, Paint()..color = const Color(0xFF3CC9A3));
    canvas.drawCircle(
        center, radius * 0.05, Paint()..color = const Color(0xFFE56A6E));

    if (outerBullSelected || bullSelected) {
      canvas.drawCircle(
        center,
        radius * (outerBullSelected ? 0.12 : 0.07),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = _highlightColor(highlight!.ring)
              .withValues(alpha: 0.9 - (0.1 * progress)),
      );
      canvas.drawCircle(
        center,
        radius * (outerBullSelected ? 0.14 : 0.09),
        Paint()
          ..color = _highlightColor(highlight!.ring)
              .withValues(alpha: 0.12 + (0.08 * pulse))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }
  }

  void _drawWires(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 1;

    for (var index = 0;
        index < InteractiveDartboard._segmentOrder.length;
        index++) {
      final angle = (-math.pi / 2) + (index * (math.pi / 10));
      canvas.drawLine(
        Offset(center.dx + radius * 0.10 * math.cos(angle),
            center.dy + radius * 0.10 * math.sin(angle)),
        Offset(center.dx + radius * math.cos(angle),
            center.dy + radius * math.sin(angle)),
        paint,
      );
    }
  }

  void _drawLabels(Canvas canvas, Offset center, double radius) {
    final painter = TextPainter(
        textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    for (var index = 0;
        index < InteractiveDartboard._segmentOrder.length;
        index++) {
      final angle = (-math.pi / 2) + ((index + 0.5) * (math.pi / 10));
      final point = Offset(center.dx + radius * 0.77 * math.cos(angle),
          center.dy + radius * 0.77 * math.sin(angle));
      painter.text = TextSpan(
        text: '${InteractiveDartboard._segmentOrder[index]}',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
          fontSize: radius * 0.08,
          shadows: const [
            Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 2))
          ],
        ),
      );
      painter.layout();
      painter.paint(
          canvas, point - Offset(painter.width / 2, painter.height / 2));
    }
  }

  Color _highlightColor(_BoardRing ring) {
    return switch (ring) {
      _BoardRing.double || _BoardRing.bull => const Color(0xFFFFA0A0),
      _BoardRing.triple || _BoardRing.outerBull => const Color(0xFF7AEDD0),
      _ => colorScheme.primary,
    };
  }

  @override
  bool shouldRepaint(covariant _DartboardPainter oldDelegate) {
    return oldDelegate.colorScheme != colorScheme ||
        oldDelegate.highlight != highlight ||
        oldDelegate.progress != progress ||
        oldDelegate.disabled != disabled;
  }
}

class _ThrowResult {
  const _ThrowResult({required this.dartThrow, required this.hit});

  final DartThrow dartThrow;
  final _BoardHit hit;
}

class _BoardHit {
  const _BoardHit(
      {required this.segment, required this.multiplier, required this.ring});

  final int segment;
  final int multiplier;
  final _BoardRing ring;

  DartThrow get dartThrow =>
      DartThrow(segment: segment, multiplier: multiplier);
}

enum _BoardRing {
  miss,
  innerSingle,
  outerSingle,
  double,
  triple,
  outerBull,
  bull
}
