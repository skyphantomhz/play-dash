import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/dart_throw.dart';

class InteractiveDartboard extends StatefulWidget {
  const InteractiveDartboard({
    required this.onThrow,
    this.enabled = true,
    super.key,
  });

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
    5,
  ];

  @override
  State<InteractiveDartboard> createState() => _InteractiveDartboardState();
}

class _InteractiveDartboardState extends State<InteractiveDartboard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  _BoardHit? _lastHit;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Precision board', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Tap any segment to register a dart. The last hit now flashes with a stronger glow so the exact region is easier to confirm instantly.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = Curves.easeOutBack.transform(_controller.value);
            final glowOpacity = (1 - _controller.value).clamp(0.0, 1.0);

            return Transform.scale(
              scale: 1 + (0.045 * t),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(
                        alpha: 0.56 * glowOpacity,
                      ),
                      blurRadius: 54 + (42 * t),
                      spreadRadius: 8 + (14 * t),
                    ),
                    BoxShadow(
                      color: theme.colorScheme.secondary.withValues(
                        alpha: 0.26 * glowOpacity,
                      ),
                      blurRadius: 70 + (30 * t),
                      spreadRadius: 6 + (10 * t),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.30),
                      blurRadius: 38,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: child,
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: IgnorePointer(
              ignoring: !widget.enabled,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = math.min(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  return Center(
                    child: Builder(
                      builder: (boardContext) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapUp: (details) {
                            final box =
                                boardContext.findRenderObject() as RenderBox?;
                            if (box == null) return;

                            final localPosition =
                                box.globalToLocal(details.globalPosition);
                            final result = _throwForPosition(
                                localPosition, Size(size, size));
                            setState(() => _lastHit = result.hit);
                            _controller
                              ..reset()
                              ..forward();
                            widget.onThrow(result.dartThrow);
                          },
                          child: SizedBox(
                            width: size,
                            height: size,
                            child: CustomPaint(
                              painter: _DartboardPainter(
                                colorScheme: theme.colorScheme,
                                disabled: !widget.enabled,
                                highlight: _lastHit,
                                pulseValue: _controller.value,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            const _LegendChip(label: 'Single', color: Color(0xFF213142)),
            const _LegendChip(label: 'Double', color: Color(0xFFFF6B6B)),
            const _LegendChip(label: 'Triple', color: Color(0xFF00C08B)),
            const _LegendChip(label: 'Outer Bull', color: Color(0xFF00C08B)),
            const _LegendChip(label: 'Bull', color: Color(0xFFFF6B6B)),
            _LegendChip(
              label: _lastHit == null
                  ? 'Ready'
                  : _formatThrow(_lastHit!.dartThrow),
              color: theme.colorScheme.primary,
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
    final radius = math.min(size.width, size.height) / 2;
    final normalizedDistance =
        dx == 0 && dy == 0 ? 0.0 : math.sqrt((dx * dx) + (dy * dy)) / radius;

    if (normalizedDistance > 1) {
      const dartThrow = DartThrow(segment: 0, multiplier: 0);
      return const _ThrowResult(
        dartThrow: dartThrow,
        hit: _BoardHit(segment: 0, multiplier: 0, ring: _BoardRing.miss),
      );
    }

    if (normalizedDistance <= 0.05) {
      const dartThrow = DartThrow(segment: 25, multiplier: 2);
      return const _ThrowResult(
        dartThrow: dartThrow,
        hit: _BoardHit(segment: 25, multiplier: 2, ring: _BoardRing.bull),
      );
    }

    if (normalizedDistance <= 0.10) {
      const dartThrow = DartThrow(segment: 25, multiplier: 1);
      return const _ThrowResult(
        dartThrow: dartThrow,
        hit: _BoardHit(segment: 25, multiplier: 1, ring: _BoardRing.outerBull),
      );
    }

    final angle =
        (math.atan2(dy, dx) + (math.pi / 2) + (2 * math.pi)) % (2 * math.pi);
    final wedge = (angle / (math.pi / 10)).floor() %
        InteractiveDartboard._segmentOrder.length;
    final segment = InteractiveDartboard._segmentOrder[wedge];

    if (normalizedDistance >= 0.90) {
      final dartThrow = DartThrow(segment: segment, multiplier: 2);
      return _ThrowResult(
        dartThrow: dartThrow,
        hit:
            _BoardHit(segment: segment, multiplier: 2, ring: _BoardRing.double),
      );
    }

    if (normalizedDistance >= 0.54 && normalizedDistance <= 0.62) {
      final dartThrow = DartThrow(segment: segment, multiplier: 3);
      return _ThrowResult(
        dartThrow: dartThrow,
        hit:
            _BoardHit(segment: segment, multiplier: 3, ring: _BoardRing.triple),
      );
    }

    final ring = normalizedDistance < 0.54
        ? _BoardRing.innerSingle
        : _BoardRing.outerSingle;
    final dartThrow = DartThrow(segment: segment, multiplier: 1);
    return _ThrowResult(
      dartThrow: dartThrow,
      hit: _BoardHit(segment: segment, multiplier: 1, ring: ring),
    );
  }

  static String _formatThrow(DartThrow dartThrow) {
    if (dartThrow.segment == 0 || dartThrow.multiplier == 0) {
      return 'Miss';
    }
    if (dartThrow.segment == 25) {
      return dartThrow.multiplier == 2 ? 'Bull' : 'Outer Bull';
    }

    switch (dartThrow.multiplier) {
      case 1:
        return 'S${dartThrow.segment}';
      case 2:
        return 'D${dartThrow.segment}';
      case 3:
        return 'T${dartThrow.segment}';
      default:
        return '${dartThrow.multiplier}x ${dartThrow.segment}';
    }
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 8),
      label: Text(label),
      backgroundColor: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.76),
    );
  }
}

class _DartboardPainter extends CustomPainter {
  const _DartboardPainter({
    required this.colorScheme,
    required this.disabled,
    required this.highlight,
    required this.pulseValue,
  });

  final ColorScheme colorScheme;
  final bool disabled;
  final _BoardHit? highlight;
  final double pulseValue;

  static const List<int> _segmentOrder = InteractiveDartboard._segmentOrder;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final hitPulse = Curves.easeOutQuart.transform(1 - pulseValue);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFF34475F), Color(0xFF111824)],
          stops: const [0.08, 1],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    if (highlight != null) {
      final focusColor = _highlightColor(highlight!);

      canvas.drawCircle(
        center,
        radius * (1.02 + (0.06 * hitPulse)),
        Paint()
          ..color = focusColor.withValues(
            alpha: 0.24 + (0.18 * hitPulse),
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 34),
      );

      canvas.drawCircle(
        center,
        radius * (0.90 + (0.05 * hitPulse)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7 + (5 * hitPulse)
          ..color = focusColor.withValues(alpha: 0.14 + (0.12 * hitPulse))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.035
        ..shader = SweepGradient(
          colors: [
            Colors.white.withValues(alpha: 0.45),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.35),
            Colors.white.withValues(alpha: 0.18),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    _drawWedgeRing(canvas, center, radius,
        innerFactor: 0.62,
        outerFactor: 0.90,
        evenColor: const Color(0xFFF0DFC6),
        oddColor: const Color(0xFF1A2533),
        ring: _BoardRing.outerSingle);
    _drawWedgeRing(canvas, center, radius,
        innerFactor: 0.54,
        outerFactor: 0.62,
        evenColor: const Color(0xFF00C08B),
        oddColor: const Color(0xFFFF6B6B),
        ring: _BoardRing.triple);
    _drawWedgeRing(canvas, center, radius,
        innerFactor: 0.10,
        outerFactor: 0.54,
        evenColor: const Color(0xFF1A2533),
        oddColor: const Color(0xFFF0DFC6),
        ring: _BoardRing.innerSingle);
    _drawWedgeRing(canvas, center, radius,
        innerFactor: 0.90,
        outerFactor: 1.0,
        evenColor: const Color(0xFFFF6B6B),
        oddColor: const Color(0xFF00C08B),
        ring: _BoardRing.double);

    _drawBull(canvas, center, radius);
    _drawRadialWires(canvas, center, radius);
    _drawSegmentLabels(canvas, center, radius);

    if (highlight?.ring == _BoardRing.miss) {
      canvas.drawCircle(
        center,
        radius * (1.03 + (0.05 * hitPulse)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..color =
              colorScheme.primary.withValues(alpha: 0.42 + (0.18 * hitPulse))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }

    if (disabled) {
      canvas.drawCircle(
        center,
        radius,
        Paint()..color = colorScheme.surface.withValues(alpha: 0.46),
      );
    }
  }

  void _drawBull(Canvas canvas, Offset center, double radius) {
    final isOuterBull = highlight?.ring == _BoardRing.outerBull;
    final isBull = highlight?.ring == _BoardRing.bull;
    final pulse = Curves.easeOutQuart.transform(1 - pulseValue);

    if (isOuterBull) {
      canvas.drawCircle(
        center,
        radius * (0.14 + (0.035 * pulse)),
        Paint()
          ..color =
              const Color(0xFF00C08B).withValues(alpha: 0.34 + (0.30 * pulse))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      );
    }

    if (isBull) {
      canvas.drawCircle(
        center,
        radius * (0.09 + (0.036 * pulse)),
        Paint()
          ..color =
              const Color(0xFFFF6B6B).withValues(alpha: 0.40 + (0.30 * pulse))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      );
    }

    canvas.drawCircle(
      center,
      radius * 0.10,
      Paint()
        ..color = const Color(0xFF00C08B)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
    );
    canvas.drawCircle(
      center,
      radius * 0.05,
      Paint()
        ..color = const Color(0xFFFF6B6B)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.8),
    );
  }

  void _drawRadialWires(Canvas canvas, Offset center, double radius) {
    final wirePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 1;

    for (var index = 0; index < _segmentOrder.length; index++) {
      final angle = (-math.pi / 2) + (index * (math.pi / 10));
      canvas.drawLine(
        Offset(center.dx + (radius * 0.10 * math.cos(angle)),
            center.dy + (radius * 0.10 * math.sin(angle))),
        Offset(center.dx + (radius * math.cos(angle)),
            center.dy + (radius * math.sin(angle))),
        wirePaint,
      );
    }
  }

  void _drawWedgeRing(
    Canvas canvas,
    Offset center,
    double radius, {
    required double innerFactor,
    required double outerFactor,
    required Color evenColor,
    required Color oddColor,
    required _BoardRing ring,
  }) {
    const sweep = math.pi / 10;
    final innerRadius = radius * innerFactor;
    final outerRadius = radius * outerFactor;

    for (var index = 0; index < _segmentOrder.length; index++) {
      final start = (-math.pi / 2) + (index * sweep);
      final segment = _segmentOrder[index];
      final isHighlighted =
          highlight?.segment == segment && highlight?.ring == ring;
      final baseColor = index.isEven ? evenColor : oddColor;
      final highlightColor = _highlightColor(
        _BoardHit(segment: segment, multiplier: 1, ring: ring),
      );
      final pulse = Curves.easeOutQuart.transform(1 - pulseValue);

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

      if (isHighlighted) {
        canvas.drawPath(
          path,
          Paint()
            ..color = highlightColor.withValues(alpha: 0.62 + (0.24 * pulse))
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 14 + (9 * pulse)
            ..strokeJoin = StrokeJoin.round,
        );
      }

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(baseColor, Colors.white, 0.14)!,
              baseColor,
              Color.lerp(baseColor, Colors.black, 0.18)!,
            ],
          ).createShader(Rect.fromCircle(center: center, radius: outerRadius)),
      );

      if (isHighlighted) {
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.fill
            ..shader = LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.34 + (0.16 * pulse)),
                highlightColor.withValues(alpha: 0.28 + (0.24 * pulse)),
              ],
            ).createShader(
              Rect.fromCircle(center: center, radius: outerRadius),
            ),
        );

        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.4
            ..color = Colors.white.withValues(alpha: 0.84 - (0.10 * pulse)),
        );
      }

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..color = Colors.white.withValues(alpha: 0.18),
      );
    }
  }

  Color _highlightColor(_BoardHit hit) {
    switch (hit.ring) {
      case _BoardRing.double:
      case _BoardRing.bull:
        return const Color(0xFFFF7A59);
      case _BoardRing.triple:
      case _BoardRing.outerBull:
        return const Color(0xFF00D9A6);
      case _BoardRing.innerSingle:
      case _BoardRing.outerSingle:
        return colorScheme.primary;
      case _BoardRing.miss:
        return colorScheme.primary;
    }
  }

  void _drawSegmentLabels(Canvas canvas, Offset center, double radius) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (var index = 0; index < _segmentOrder.length; index++) {
      final angle = (-math.pi / 2) + ((index + 0.5) * (math.pi / 10));
      final labelOffset = Offset(
        center.dx + (radius * 0.77 * math.cos(angle)),
        center.dy + (radius * 0.77 * math.sin(angle)),
      );

      textPainter.text = TextSpan(
        text: '${_segmentOrder[index]}',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: radius * 0.082,
          fontWeight: FontWeight.w800,
          shadows: const [
            Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        labelOffset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DartboardPainter oldDelegate) {
    return oldDelegate.colorScheme != colorScheme ||
        oldDelegate.disabled != disabled ||
        oldDelegate.highlight != highlight ||
        oldDelegate.pulseValue != pulseValue;
  }
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

class _BoardHit {
  const _BoardHit({
    required this.segment,
    required this.multiplier,
    required this.ring,
  });

  final int segment;
  final int multiplier;
  final _BoardRing ring;

  DartThrow get dartThrow =>
      DartThrow(segment: segment, multiplier: multiplier);

  @override
  bool operator ==(Object other) {
    return other is _BoardHit &&
        other.segment == segment &&
        other.multiplier == multiplier &&
        other.ring == ring;
  }

  @override
  int get hashCode => Object.hash(segment, multiplier, ring);
}

class _ThrowResult {
  const _ThrowResult({required this.dartThrow, required this.hit});

  final DartThrow dartThrow;
  final _BoardHit hit;
}
