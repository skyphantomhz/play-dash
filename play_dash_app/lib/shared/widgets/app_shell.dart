import 'dart:ui';

import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.title,
    required this.subtitle,
    required this.child,
    this.actions,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final List<Widget>? actions;

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerLowest,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -120,
              right: -60,
              child: _GlowOrb(size: 260, color: Color(0xFF6EE7F9)),
            ),
            const Positioned(
              bottom: -140,
              left: -80,
              child: _GlowOrb(size: 320, color: Color(0xFF9D7CFF)),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = constraints.maxWidth >= 1200
                      ? 40.0
                      : constraints.maxWidth >= 720
                          ? 24.0
                          : 16.0;

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          12,
                          horizontalPadding,
                          24,
                        ),
                        children: [
                          GlassPanel(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: theme.textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  subtitle,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          child,
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
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color:
                theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 32,
                offset: const Offset(0, 18),
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

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
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
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = highlight
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: highlight ? 0.85 : 0.72),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: theme.colorScheme.primary),
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
                  Text(value, style: theme.textTheme.titleLarge),
                ],
              ),
            ),
          ],
        ),
      ),
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
              color.withValues(alpha: 0.24),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
