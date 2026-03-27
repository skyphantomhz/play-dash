import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/dart_throw.dart';

class InteractiveDartboard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tap the dartboard',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'The board detects singles, doubles, triples, bull, outer bull, and misses.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1,
          child: IgnorePointer(
            ignoring: !enabled,
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
                          final box = boardContext.findRenderObject() as RenderBox?;
                          if (box == null) {
                            return;
                          }

                          final localPosition = box.globalToLocal(
                            details.globalPosition,
                          );
                          final dartThrow = _throwForPosition(
                            localPosition,
                            Size(size, size),
                          );
                          onThrow(dartThrow);
                        },
                        child: SizedBox(
                          width: size,
                          height: size,
                          child: CustomPaint(
                            painter: _DartboardPainter(
                              colorScheme: Theme.of(context).colorScheme,
                              disabled: !enabled,
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
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _LegendChip(label: 'Single', color: Color(0xFF23262D)),
            _LegendChip(label: 'Double', color: Color(0xFFB22222)),
            _LegendChip(label: 'Triple', color: Color(0xFF2E8B57)),
            _LegendChip(label: 'Outer Bull', color: Color(0xFF2E8B57)),
            _LegendChip(label: 'Bull', color: Color(0xFFB22222)),
            _LegendChip(label: 'Miss', color: Color(0xFF4A4F5A)),
          ],
        ),
      ],
    );
  }

  DartThrow _throwForPosition(Offset position, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;
    final radius = math.min(size.width, size.height) / 2;
    final normalizedDistance = dx == 0 && dy == 0
        ? 0.0
        : math.sqrt((dx * dx) + (dy * dy)) / radius;

    if (normalizedDistance > 1) {
      return const DartThrow(segment: 0, multiplier: 0);
    }

    if (normalizedDistance <= 0.05) {
      return const DartThrow(segment: 25, multiplier: 2);
    }

    if (normalizedDistance <= 0.10) {
      return const DartThrow(segment: 25, multiplier: 1);
    }

    final angle = (math.atan2(dy, dx) + (math.pi / 2) + (2 * math.pi)) %
        (2 * math.pi);
    final wedge = (angle / (math.pi / 10)).floor() % _segmentOrder.length;
    final segment = _segmentOrder[wedge];

    if (normalizedDistance >= 0.90) {
      return DartThrow(segment: segment, multiplier: 2);
    }

    if (normalizedDistance >= 0.54 && normalizedDistance <= 0.62) {
      return DartThrow(segment: segment, multiplier: 3);
    }

    return DartThrow(segment: segment, multiplier: 1);
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 7),
      label: Text(label),
    );
  }
}

class _DartboardPainter extends CustomPainter {
  const _DartboardPainter({
    required this.colorScheme,
    required this.disabled,
  });

  final ColorScheme colorScheme;
  final bool disabled;

  static const List<int> _segmentOrder = InteractiveDartboard._segmentOrder;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final overlayColor = disabled
        ? colorScheme.surface.withValues(alpha: 0.45)
        : Colors.transparent;

    _drawWedgeRing(
      canvas,
      center,
      radius,
      innerFactor: 0.62,
      outerFactor: 0.90,
      evenColor: const Color(0xFFE8DCC8),
      oddColor: const Color(0xFF23262D),
    );
    _drawWedgeRing(
      canvas,
      center,
      radius,
      innerFactor: 0.54,
      outerFactor: 0.62,
      evenColor: const Color(0xFF2E8B57),
      oddColor: const Color(0xFFB22222),
    );
    _drawWedgeRing(
      canvas,
      center,
      radius,
      innerFactor: 0.10,
      outerFactor: 0.54,
      evenColor: const Color(0xFF23262D),
      oddColor: const Color(0xFFE8DCC8),
    );
    _drawWedgeRing(
      canvas,
      center,
      radius,
      innerFactor: 0.90,
      outerFactor: 1.0,
      evenColor: const Color(0xFFB22222),
      oddColor: const Color(0xFF2E8B57),
    );

    canvas.drawCircle(
      center,
      radius * 0.10,
      Paint()..color = const Color(0xFF2E8B57),
    );
    canvas.drawCircle(
      center,
      radius * 0.05,
      Paint()..color = const Color(0xFFB22222),
    );

    _drawSegmentLabels(canvas, center, radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = colorScheme.outlineVariant,
    );

    if (disabled) {
      canvas.drawCircle(
        center,
        radius,
        Paint()..color = overlayColor,
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
  }) {
    const sweep = math.pi / 10;
    final innerRadius = radius * innerFactor;
    final outerRadius = radius * outerFactor;

    for (var index = 0; index < _segmentOrder.length; index++) {
      final start = (-math.pi / 2) + (index * sweep);
      final path = Path()
        ..moveTo(
          center.dx + (innerRadius * math.cos(start)),
          center.dy + (innerRadius * math.sin(start)),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: outerRadius),
          start,
          sweep,
          false,
        )
        ..lineTo(
          center.dx + (innerRadius * math.cos(start + sweep)),
          center.dy + (innerRadius * math.sin(start + sweep)),
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: innerRadius),
          start + sweep,
          -sweep,
          false,
        )
        ..close();

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = index.isEven ? evenColor : oddColor,
      );
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = colorScheme.outlineVariant,
      );
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
        center.dx + (radius * 0.78 * math.cos(angle)),
        center.dy + (radius * 0.78 * math.sin(angle)),
      );

      textPainter.text = TextSpan(
        text: '${_segmentOrder[index]}',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: radius * 0.085,
          fontWeight: FontWeight.w700,
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
        oldDelegate.disabled != disabled;
  }
}
