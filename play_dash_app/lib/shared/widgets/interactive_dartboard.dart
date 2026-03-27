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

  @override
  State<InteractiveDartboard> createState() => _InteractiveDartboardState();
}

class _InteractiveDartboardState extends State<InteractiveDartboard> {
  static const List<int> _segments = <int>[20, 19, 18, 17, 16, 15, 25];
  int _selectedMultiplier = 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose multiplier',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _multiplierChip(label: 'Single', multiplier: 1),
            _multiplierChip(label: 'Double', multiplier: 2),
            _multiplierChip(label: 'Triple', multiplier: 3, enabled: widget.enabled),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Tap a segment',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _segments.map((segment) {
            final isBull = segment == 25;
            final isTripleBull = isBull && _selectedMultiplier == 3;

            return SizedBox(
              width: 100,
              child: FilledButton.tonal(
                onPressed: widget.enabled && !isTripleBull
                    ? () => widget.onThrow(
                          DartThrow(
                            segment: segment,
                            multiplier: _selectedMultiplier,
                          ),
                        )
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: isBull ? colorScheme.secondaryContainer : null,
                ),
                child: Text(isBull ? 'Bull' : '$segment'),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: widget.enabled
              ? () => widget.onThrow(
                    const DartThrow(segment: 0, multiplier: 0),
                  )
              : null,
          icon: const Icon(Icons.close),
          label: const Text('Miss'),
        ),
      ],
    );
  }

  Widget _multiplierChip({
    required String label,
    required int multiplier,
    bool enabled = true,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedMultiplier == multiplier,
      onSelected: widget.enabled && enabled
          ? (_) => setState(() => _selectedMultiplier = multiplier)
          : null,
    );
  }
}
