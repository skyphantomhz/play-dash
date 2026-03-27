import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF070B16), Color(0xFF0B1223), Color(0xFF060915)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: _AmbientBackdrop()),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 1160;
                  final horizontalPadding = constraints.maxWidth >= 1400
                      ? 34.0
                      : constraints.maxWidth >= 900
                          ? 24.0
                          : 14.0;
                  final content = _ShellBody(
                    title: title,
                    subtitle: subtitle,
                    hero: hero,
                    child: child,
                    actions: actions,
                    floatingOverlay: floatingOverlay,
                    floatingOverlayHeight: floatingOverlayHeight,
                  );

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1480),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          16,
                          horizontalPadding,
                          16,
                        ),
                        child: isDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(
                                    width: 258,
                                    child: _SideRail(),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(child: content),
                                ],
                              )
                            : content,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 1160
          ? const Padding(
              padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: _BottomDock(),
            )
          : null,
    );
  }
}

class _ShellBody extends StatelessWidget {
  const _ShellBody({
    required this.title,
    required this.subtitle,
    required this.child,
    this.hero,
    this.actions,
    this.floatingOverlay,
    this.floatingOverlayHeight = 0,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final topInset = floatingOverlay == null ? 0.0 : floatingOverlayHeight + 18.0;

        return Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(bottom: 96, top: topInset),
              children: [
                GlassPanel(
                  radius: 34,
                  blur: 9,
                  opacity: 0.5,
                  padding: EdgeInsets.all(isWide ? 28 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 14,
                        spacing: 14,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 780),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -1,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Text(
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
                              ],
                            ),
                          ),
                          _TopCommandBar(actions: actions),
                        ],
                      ),
                      if (hero != null) ...[
                        const SizedBox(height: 22),
                        hero!,
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                child,
              ],
            ),
            if (floatingOverlay != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: floatingOverlay!,
              ),
          ],
        );
      },
    );
  }
}

class _TopCommandBar extends StatelessWidget {
  const _TopCommandBar({this.actions});

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: 24,
      blur: 8,
      backgroundOpacity: 0.42,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _StatusDot(color: Color(0xFF6FE3C1)),
          const SizedBox(width: 10),
          Text(
            'Live dashboard',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(width: 12),
            ...actions!,
          ],
        ],
      ),
    );
  }
}

class _SideRail extends StatelessWidget {
  const _SideRail();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return GlassPanel(
      radius: 34,
      blur: 10,
      opacity: 0.48,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF8E7BFF), Color(0xFF52CFFF)],
                  ),
                ),
                child: const Icon(Icons.sports_score_rounded, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Play Dash',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  Text(
                    'Glass arena',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          for (final item in _navItems) ...[
            _RailButton(item: item, selected: location == item.route),
            const SizedBox(height: 10),
          ],
          const Spacer(),
          FrostPanel(
            radius: 28,
            blur: 8,
            backgroundOpacity: 0.38,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusPill(
                  label: 'Subtle blur',
                  icon: Icons.blur_on_rounded,
                  tinted: true,
                ),
                const SizedBox(height: 14),
                Text(
                  'Sharper contrast, softer frosted layers, and faster scanning for live scoring.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomDock extends StatelessWidget {
  const _BottomDock();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return FrostPanel(
      radius: 28,
      blur: 10,
      backgroundOpacity: 0.46,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: _navItems
            .take(4)
            .map(
              (item) => Expanded(
                child: _DockButton(
                  item: item,
                  selected: location == item.route,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({required this.item, required this.selected});

  final _NavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.go(item.route),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary.withValues(alpha: 0.88),
                    scheme.secondary.withValues(alpha: 0.74),
                  ],
                )
              : null,
          color: selected ? null : Colors.white.withValues(alpha: 0.04),
          border: Border.all(
            color: Colors.white.withValues(alpha: selected ? 0.1 : 0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 20, color: selected ? scheme.onPrimary : null),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selected ? scheme.onPrimary : scheme.onSurface,
                    ),
              ),
            ),
            if (selected)
              Icon(Icons.chevron_right_rounded,
                  color: scheme.onPrimary.withValues(alpha: 0.9)),
          ],
        ),
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  const _DockButton({required this.item, required this.selected});

  final _NavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.go(item.route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: selected
              ? LinearGradient(
                  colors: [
                    scheme.primary.withValues(alpha: 0.92),
                    scheme.secondary.withValues(alpha: 0.78),
                  ],
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: selected ? scheme.onPrimary : scheme.onSurfaceVariant),
            const SizedBox(height: 4),
            Text(
              item.shortLabel,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
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
                Colors.white.withValues(alpha: highlight ? 0.18 : 0.10),
                scheme.surfaceContainerHigh.withValues(alpha: backgroundOpacity),
                scheme.surfaceContainer.withValues(
                  alpha: backgroundOpacity - 0.12,
                ),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: borderOpacity),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: (highlight ? scheme.primary : Colors.white)
                    .withValues(alpha: highlight ? 0.16 : 0.03),
                blurRadius: 18,
                offset: const Offset(0, -3),
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
    super.borderOpacity = 0.14,
    super.blur = 7,
    super.key,
  }) : super(backgroundOpacity: opacity);
}

class GlassButton extends StatelessWidget {
  const GlassButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.highlight = false,
    this.compact = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool highlight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(compact ? 18 : 24),
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 18 : 24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: highlight
                  ? [
                      scheme.primary.withValues(alpha: 0.96),
                      scheme.secondary.withValues(alpha: 0.78),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.11),
                      scheme.surfaceContainerHighest.withValues(alpha: 0.52),
                    ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: (highlight ? scheme.primary : Colors.black)
                    .withValues(alpha: 0.22),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 16 : 18,
              vertical: compact ? 14 : 18,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: highlight ? scheme.onPrimary : scheme.onSurface),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: highlight ? scheme.onPrimary : scheme.onSurface,
                        ),
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
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 10,
      spacing: 12,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
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
        if (trailing != null) trailing!,
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
      constraints: BoxConstraints(minWidth: compact ? 132 : 170),
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: highlight ? 0.18 : 0.08),
            (highlight ? scheme.primary : scheme.surfaceContainerHighest)
                .withValues(alpha: highlight ? 0.2 : 0.46),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: highlight ? 0.18 : 0.08),
        ),
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
              child: Icon(icon, color: scheme.primary, size: compact ? 20 : 22),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: (compact
                          ? Theme.of(context).textTheme.titleMedium
                          : Theme.of(context).textTheme.titleLarge)
                      ?.copyWith(fontWeight: FontWeight.w800),
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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: tinted
            ? scheme.primary.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.06),
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

class PanelListTile extends StatelessWidget {
  const PanelListTile({
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
    this.highlight = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: 24,
      blur: 7,
      backgroundOpacity: highlight ? 0.5 : 0.38,
      highlight: highlight,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
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
      ),
    );
  }
}

class ScoreBadge extends StatelessWidget {
  const ScoreBadge({required this.value, this.highlight = false, super.key});

  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: highlight
              ? [
                  scheme.primary.withValues(alpha: 0.92),
                  scheme.secondary.withValues(alpha: 0.76),
                ]
              : [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.04),
                ],
        ),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: highlight ? scheme.onPrimary : scheme.onSurface,
            ),
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
          top: -110,
          left: -70,
          child: _GlowOrb(size: 320, color: Color(0xFF756EFF)),
        ),
        Positioned(
          top: 120,
          right: -80,
          child: _GlowOrb(size: 300, color: Color(0xFF4CCEFF)),
        ),
        Positioned(
          bottom: -120,
          left: 120,
          child: _GlowOrb(size: 300, color: Color(0xFFFF73AF)),
        ),
        Positioned(
          bottom: 120,
          right: 80,
          child: _GridHalo(),
        ),
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
              color.withValues(alpha: 0.28),
              color.withValues(alpha: 0.06),
              Colors.transparent,
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
      child: CustomPaint(
        size: const Size(300, 300),
        painter: _GridHaloPainter(),
      ),
    );
  }
}

class _GridHaloPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0x22756EFF), Colors.transparent],
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(48)),
      paint,
    );

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
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

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.6),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.shortLabel,
    required this.icon,
    required this.route,
  });

  final String label;
  final String shortLabel;
  final IconData icon;
  final String route;
}

const List<_NavItem> _navItems = [
  _NavItem(
    label: 'Dashboard',
    shortLabel: 'Home',
    icon: Icons.space_dashboard_rounded,
    route: '/',
  ),
  _NavItem(
    label: 'Player Setup',
    shortLabel: 'Setup',
    icon: Icons.groups_2_rounded,
    route: '/setup',
  ),
  _NavItem(
    label: 'X01 Match',
    shortLabel: 'X01',
    icon: Icons.sports_score_rounded,
    route: '/match/x01',
  ),
  _NavItem(
    label: 'Cricket Match',
    shortLabel: 'Cricket',
    icon: Icons.track_changes_rounded,
    route: '/match/cricket',
  ),
  _NavItem(
    label: 'Leaderboard',
    shortLabel: 'Leads',
    icon: Icons.emoji_events_rounded,
    route: '/leaderboard',
  ),
];
