import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _AppBackground(),
        child,
      ],
    );
  }
}

class RootAppShell extends StatelessWidget {
  const RootAppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1180;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1520),
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 20 : 10),
              child: GlassPanel(
                radius: 28,
                blur: 26,
                background: Colors.white.withValues(alpha: 0.05),
                borderColor: Colors.white.withValues(alpha: 0.05),
                padding: EdgeInsets.all(isDesktop ? 14 : 8),
                child: isDesktop
                    ? Row(
                        children: [
                          SizedBox(
                            width: 220,
                            child: _DesktopSidebar(
                              currentIndex: navigationShell.currentIndex,
                              onSelectBranch: (index) => _goToBranch(index),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _ShellSurface(
                              navigationShell: navigationShell,
                              showBottomNav: false,
                            ),
                          ),
                        ],
                      )
                    : _ShellSurface(
                        navigationShell: navigationShell,
                        showBottomNav: true,
                        onSelectBranch: (index) => _goToBranch(index),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _goToBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _ShellSurface extends StatelessWidget {
  const _ShellSurface({
    required this.navigationShell,
    required this.showBottomNav,
    this.onSelectBranch,
  });

  final StatefulNavigationShell navigationShell;
  final bool showBottomNav;
  final ValueChanged<int>? onSelectBranch;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1180;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isDesktop ? 26 : 24),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.9),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF091127), Color(0xFF11153A), Color(0xFF170A2F)],
        ),
        boxShadow: [
          const BoxShadow(
            color: Color(0x8A02030A),
            blurRadius: 36,
            offset: Offset(0, 20),
          ),
          BoxShadow(
            color: const Color(0xFF37D8FF).withValues(alpha: 0.09),
            blurRadius: 46,
            spreadRadius: -12,
          ),
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
            blurRadius: 58,
            spreadRadius: -20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isDesktop ? 26 : 24),
        child: Stack(
          children: [
            const Positioned.fill(child: _InnerCosmos()),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isDesktop ? 16 : 10,
                      isDesktop ? 16 : 10,
                      isDesktop ? 16 : 10,
                      showBottomNav ? 10 : 16,
                    ),
                    child: navigationShell,
                  ),
                ),
                if (showBottomNav)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: _MobileBottomBar(
                      currentIndex: navigationShell.currentIndex,
                      onSelectBranch: onSelectBranch ?? (_) {},
                    ),
                  ),
              ],
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
    this.padding = const EdgeInsets.all(24),
    this.radius = 20,
    this.blur = 20,
    this.background = const Color(0x14FFFFFF),
    this.borderColor = const Color(0x12FFFFFF),
    this.glowColor,
    this.shadowColor = const Color(0x66000000),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;
  final Color background;
  final Color borderColor;
  final Color? glowColor;
  final Color shadowColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: padding,
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
              width: 0.7,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.11),
                Colors.transparent,
                Colors.white.withValues(alpha: 0.03),
              ],
              stops: const [0.0, 0.32, 1.0],
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: background,
            border: Border.all(
              color: borderColor.withValues(
                  alpha: (borderColor.a + 0.06).clamp(0.0, 1.0)),
              width: 0.9,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.48),
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
              if (glowColor != null) ...[
                BoxShadow(
                  color: glowColor!.withValues(alpha: 0.10),
                  blurRadius: 38,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: glowColor!.withValues(alpha: 0.05),
                  blurRadius: 64,
                  spreadRadius: 6,
                ),
              ] else ...[
                BoxShadow(
                  color: const Color(0xFF37D8FF).withValues(alpha: 0.045),
                  blurRadius: 34,
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: const Color(0xFFFF4FD8).withValues(alpha: 0.035),
                  blurRadius: 54,
                  spreadRadius: -6,
                  offset: const Offset(0, 4),
                ),
              ],
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) return content;
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: content));
  }
}

class NeonCard extends StatelessWidget {
  const NeonCard({
    required this.child,
    required this.accent,
    this.secondaryAccent,
    this.radius = 20,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
    super.key,
  });

  final Widget child;
  final Color accent;
  final Color? secondaryAccent;
  final double radius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.34),
            blurRadius: 26,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: accent.withValues(alpha: 0.11),
            blurRadius: 34,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: (secondaryAccent ?? accent).withValues(alpha: 0.07),
            blurRadius: 58,
            spreadRadius: 4,
          ),
        ],
      ),
      child: GlassPanel(
        radius: radius,
        padding: padding,
        blur: 24,
        background: Colors.white.withValues(alpha: 0.06),
        borderColor: Colors.white.withValues(alpha: 0.06),
        glowColor: accent,
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class GlassButton extends StatefulWidget {
  const GlassButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.highlight = false,
    this.compact = false,
    this.trailingIcon = Icons.chevron_right_rounded,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool highlight;
  final bool compact;
  final IconData trailingIcon;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final scale = _pressed ? 0.98 : (_hovered ? 1.04 : 1.0);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: scale,
          child: Opacity(
            opacity: enabled ? 1 : 0.45,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(widget.compact ? 12 : 16),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(widget.compact ? 12 : 16),
                    gradient: widget.highlight
                        ? const LinearGradient(
                            colors: [Color(0xFF37D8FF), Color(0xFFFF4FD8)])
                        : const LinearGradient(
                            colors: [Color(0x22FFFFFF), Color(0x18FFFFFF)]),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: widget.highlight ? 0.12 : 0.08,
                      ),
                      width: 0.9,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.28),
                        blurRadius: 22,
                        offset: const Offset(0, 14),
                      ),
                      BoxShadow(
                        color: (widget.highlight
                                ? const Color(0xFF37D8FF)
                                : const Color(0xFF37D8FF))
                            .withValues(
                          alpha: widget.highlight
                              ? (_hovered ? 0.16 : 0.11)
                              : (_hovered ? 0.07 : 0.045),
                        ),
                        blurRadius: widget.highlight ? 34 : 26,
                        spreadRadius: widget.highlight ? 1 : 0,
                      ),
                      BoxShadow(
                        color: (widget.highlight
                                ? const Color(0xFFFF4FD8)
                                : const Color(0xFF8B5CF6))
                            .withValues(
                          alpha: widget.highlight
                              ? (_hovered ? 0.12 : 0.08)
                              : (_hovered ? 0.05 : 0.03),
                        ),
                        blurRadius: widget.highlight ? 52 : 34,
                        spreadRadius: widget.highlight ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.compact ? 14 : 18,
                        vertical: widget.compact ? 12 : 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon,
                              size: widget.compact ? 16 : 18,
                              color: Colors.white),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(widget.label,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: widget.compact ? 14 : 16,
                                  fontWeight: FontWeight.w700)),
                        ),
                        if (widget.trailingIcon != Icons.not_interested) ...[
                          const SizedBox(width: 8),
                          Icon(widget.trailingIcon,
                              size: widget.compact ? 16 : 18,
                              color: Colors.white),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreBadge extends StatelessWidget {
  const ScoreBadge(
      {required this.value,
      this.highlight = false,
      this.large = false,
      super.key});

  final String value;
  final bool highlight;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: large ? 16 : 12, vertical: large ? 10 : 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: highlight
            ? const LinearGradient(
                colors: [Color(0xFF37D8FF), Color(0xFF8B5CF6)])
            : null,
        color: highlight ? null : Colors.white.withValues(alpha: 0.08),
        border: Border.all(
          color: Colors.white.withValues(alpha: highlight ? 0.0 : 0.05),
          width: 0.8,
        ),
      ),
      child: Text(value,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: large ? 18 : 13)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: tinted
            ? const Color(0x2237D8FF)
            : Colors.white.withValues(alpha: 0.06),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: const Color(0xFF9FEFFF)),
            const SizedBox(width: 6),
          ],
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5)),
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(
      {required this.title,
      this.subtitle,
      this.trailing,
      this.compact = false,
      super.key});

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool compact;

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
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 16 : 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!,
                    style: const TextStyle(
                        color: Color(0xB3FFFFFF),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        height: 1.4)),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard(
      {required this.label,
      required this.value,
      this.icon,
      this.highlight = false,
      super.key});

  final String label;
  final String value;
  final IconData? icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 16,
      blur: 16,
      background: Colors.white.withValues(alpha: highlight ? 0.09 : 0.05),
      borderColor: Colors.white.withValues(alpha: highlight ? 0.08 : 0.04),
      glowColor: highlight ? const Color(0xFF37D8FF) : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                color: highlight ? const Color(0xFF8EEBFF) : Colors.white70,
                size: 16),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Color(0xB3FFFFFF), fontSize: 11.5)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class PanelListTile extends StatelessWidget {
  const PanelListTile(
      {required this.title,
      required this.subtitle,
      this.leading,
      this.trailing,
      this.highlight = false,
      super.key});

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 16,
      blur: 16,
      background: Colors.white.withValues(alpha: highlight ? 0.08 : 0.05),
      borderColor: Colors.white.withValues(alpha: highlight ? 0.07 : 0.04),
      glowColor: highlight ? const Color(0xFF37D8FF) : null,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 10)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xB3FFFFFF),
                        fontSize: 11.5,
                        height: 1.35)),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 10), trailing!],
        ],
      ),
    );
  }
}

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar(
      {required this.name, required this.colors, this.radius = 22, super.key});

  final String name;
  final List<Color> colors;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: colors),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.38), width: 1.4),
        boxShadow: [
          BoxShadow(color: colors.first.withValues(alpha: 0.35), blurRadius: 20)
        ],
      ),
      alignment: Alignment.center,
      child: Text(
          name.trim().isEmpty
              ? '?'
              : name.trim().characters.first.toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontSize: radius * 0.86,
              fontWeight: FontWeight.w800)),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.currentIndex,
    required this.onSelectBranch,
  });

  final int currentIndex;
  final ValueChanged<int> onSelectBranch;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 24,
      blur: 24,
      background: Colors.white.withValues(alpha: 0.05),
      borderColor: Colors.white.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BrandBadge(compact: true),
          const SizedBox(height: 22),
          for (final item in _primaryNavItems) ...[
            _SidebarNavTile(
              item: item,
              selected: currentIndex == item.branchIndex,
              onTap: () => onSelectBranch(item.branchIndex),
            ),
            const SizedBox(height: 8),
          ],
          const Spacer(),
          const GlassPanel(
            radius: 18,
            blur: 18,
            background: Color(0x14FFFFFF),
            borderColor: Color(0x1FFFFFFF),
            padding: EdgeInsets.all(12),
            child: Text('Cosmic glass UI\nwith cyan + pink glow.',
                style: TextStyle(
                    color: Color(0xB3FFFFFF), fontSize: 12.5, height: 1.35)),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavTile extends StatelessWidget {
  const _SidebarNavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _PrimaryNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border.all(
            color: Colors.white.withValues(alpha: selected ? 0.06 : 0.02),
            width: 0.8,
          ),
          boxShadow: selected
              ? [
                  const BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 16,
                    offset: Offset(0, 10),
                  ),
                  BoxShadow(
                    color: const Color(0xFF37D8FF).withValues(alpha: 0.10),
                    blurRadius: 24,
                  ),
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.06),
                    blurRadius: 36,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 18, color: Colors.white),
            const SizedBox(width: 10),
            Text(item.label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _BrandBadge extends StatelessWidget {
  const _BrandBadge({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: compact ? 32 : 30,
          height: compact ? 32 : 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                colors: [Color(0xFF133C69), Color(0xFF091B35)]),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.07), width: 0.8),
          ),
          alignment: Alignment.center,
          child: Text('Wb',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 12 : 11.5)),
        ),
        const SizedBox(width: 10),
        Text('ORAITIES',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: compact ? 13 : 12)),
      ],
    );
  }
}

class _MobileBottomBar extends StatelessWidget {
  const _MobileBottomBar({
    required this.currentIndex,
    required this.onSelectBranch,
  });

  final int currentIndex;
  final ValueChanged<int> onSelectBranch;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 18,
      blur: 20,
      background: Colors.white.withValues(alpha: 0.06),
      borderColor: Colors.white.withValues(alpha: 0.05),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        children: _primaryNavItems.map((item) {
          final selected = currentIndex == item.branchIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onSelectBranch(item.branchIndex),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: selected
                      ? const LinearGradient(
                          colors: [Color(0xFF37D8FF), Color(0xFF8B5CF6)])
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, size: 18, color: Colors.white),
                    const SizedBox(height: 4),
                    Text(item.shortLabel,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AppBackground extends StatelessWidget {
  const _AppBackground();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF091B35),
                  Color(0xFF241046),
                  Color(0xFF020308),
                ],
                stops: [0.0, 0.48, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(child: _BackgroundStreaks(dense: false)),
      ],
    );
  }
}

class _InnerCosmos extends StatelessWidget {
  const _InnerCosmos();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF08152D),
                  Color(0xFF1E103E),
                  Color(0xFF04050B),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(child: _BackgroundStreaks()),
      ],
    );
  }
}

class _BackgroundStreaks extends StatefulWidget {
  const _BackgroundStreaks({this.dense = true});

  final bool dense;

  @override
  State<_BackgroundStreaks> createState() => _BackgroundStreaksState();
}

class _BackgroundStreaksState extends State<_BackgroundStreaks>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: widget.dense ? 28 : 36),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter:
              _StreakPainter(progress: _controller.value, dense: widget.dense),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _StreakPainter extends CustomPainter {
  const _StreakPainter({required this.progress, required this.dense});

  final double progress;
  final bool dense;

  static const List<Color> _blobColors = [
    Color(0x3337D8FF),
    Color(0x40FF4FD8),
    Color(0x338B5CF6),
    Color(0x2637D8FF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    _paintGlowBlobs(canvas, size);
    _paintStreaks(canvas, size);
    _paintParticles(canvas, size);
  }

  void _paintGlowBlobs(Canvas canvas, Size size) {
    final blobs = dense
        ? const [
            (Offset(0.14, 0.18), 0.40, 0.05, 0.04),
            (Offset(0.84, 0.14), 0.36, -0.04, 0.03),
            (Offset(0.28, 0.84), 0.42, 0.04, -0.03),
            (Offset(0.82, 0.72), 0.34, -0.03, -0.03),
          ]
        : const [
            (Offset(0.12, 0.16), 0.46, 0.05, 0.04),
            (Offset(0.88, 0.22), 0.40, -0.04, 0.03),
            (Offset(0.24, 0.86), 0.44, 0.04, -0.03),
          ];

    for (var i = 0; i < blobs.length; i++) {
      final blob = blobs[i];
      final dx = _wave(progress * 0.55 + i * 0.12) * blob.$3 * size.width;
      final dy = _wave(progress * 0.45 + i * 0.19) * blob.$4 * size.height;
      final center =
          Offset(blob.$1.dx * size.width + dx, blob.$1.dy * size.height + dy);
      final radius = size.shortestSide * blob.$2;
      final color = _blobColors[i % _blobColors.length];
      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            center: Alignment.center,
            radius: 1,
            colors: [
              color,
              color.withValues(alpha: color.a * 0.42),
              color.withValues(alpha: color.a * 0.12),
              Colors.transparent,
            ],
            stops: const [0.0, 0.38, 0.72, 1.0],
          ).createShader(rect),
      );
    }
  }

  void _paintStreaks(Canvas canvas, Size size) {
    final streaks = [
      _AnimatedStreak(
        color: const Color(0xFF37D8FF),
        alpha: dense ? 0.14 : 0.11,
        width: dense ? 1.5 : 1.2,
        start: const Offset(0.02, 0.18),
        controlA: const Offset(0.24, 0.04),
        controlB: const Offset(0.68, 0.30),
        end: const Offset(0.96, 0.15),
        speed: 0.88,
        phase: 0.0,
      ),
      _AnimatedStreak(
        color: const Color(0xFFFF4FD8),
        alpha: dense ? 0.10 : 0.08,
        width: dense ? 1.2 : 1.0,
        start: const Offset(0.08, 0.72),
        controlA: const Offset(0.26, 0.56),
        controlB: const Offset(0.70, 0.84),
        end: const Offset(0.94, 0.60),
        speed: 0.72,
        phase: 0.22,
      ),
      _AnimatedStreak(
        color: const Color(0xFF8B5CF6),
        alpha: dense ? 0.08 : 0.06,
        width: 1.0,
        start: const Offset(0.12, 0.44),
        controlA: const Offset(0.34, 0.32),
        controlB: const Offset(0.58, 0.56),
        end: const Offset(0.88, 0.40),
        speed: 0.56,
        phase: 0.47,
      ),
    ];

    for (final streak in streaks) {
      final shiftX =
          _wave(progress * streak.speed + streak.phase) * 0.022 * size.width;
      final shiftY =
          _wave(progress * (streak.speed * 0.9) + streak.phase + 0.11) *
              0.016 *
              size.height;
      final path = Path()
        ..moveTo(
          streak.start.dx * size.width + shiftX,
          streak.start.dy * size.height + shiftY,
        )
        ..cubicTo(
          streak.controlA.dx * size.width - shiftX * 0.2,
          streak.controlA.dy * size.height + shiftY * 1.3,
          streak.controlB.dx * size.width + shiftX * 0.9,
          streak.controlB.dy * size.height - shiftY,
          streak.end.dx * size.width - shiftX * 0.4,
          streak.end.dy * size.height + shiftY * 0.4,
        );

      final bounds = path.getBounds().inflate(24);
      final basePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = streak.width
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            streak.color.withValues(alpha: streak.alpha * 0.55),
            streak.color.withValues(alpha: streak.alpha),
            streak.color.withValues(alpha: streak.alpha * 0.52),
            Colors.transparent,
          ],
          stops: const [0.0, 0.22, 0.5, 0.78, 1.0],
        ).createShader(bounds);
      canvas.drawPath(path, basePaint);

      final pulse = _unitWave(progress * streak.speed + streak.phase);
      final metrics = path.computeMetrics().toList();
      for (final metric in metrics) {
        final start = (metric.length * pulse).clamp(0.0, metric.length);
        final end = (start + metric.length * 0.12).clamp(0.0, metric.length);
        final highlight = metric.extractPath(start, end);
        canvas.drawPath(
          highlight,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = streak.width
            ..strokeCap = StrokeCap.round
            ..shader = LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                streak.color.withValues(alpha: dense ? 0.18 : 0.14),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds),
        );
      }
    }
  }

  void _paintParticles(Canvas canvas, Size size) {
    final count = dense ? 48 : 36;
    for (var i = 0; i < count; i++) {
      final seed = i + 1;
      final baseX = ((seed * 67) % 997) / 997;
      final baseY = ((seed * 41) % 991) / 991;
      final driftX =
          _wave(progress * (0.10 + (i % 5) * 0.015) + i * 0.17) * 0.055;
      final driftY =
          _wave(progress * (0.08 + (i % 7) * 0.012) + i * 0.11) * 0.075;
      final radius = i % 9 == 0 ? 1.8 : (i % 4 == 0 ? 1.3 : 1.0);
      final opacity = 0.05 + ((i % 6) * 0.018);
      final color =
          i.isEven ? const Color(0xFFB9F6FF) : const Color(0xFFFFD2F4);
      final offset = Offset(
        (baseX + driftX).clamp(0.0, 1.0) * size.width,
        (baseY + driftY).clamp(0.0, 1.0) * size.height,
      );
      canvas.drawCircle(
          offset, radius, Paint()..color = color.withValues(alpha: opacity));
    }
  }

  double _wave(double value) {
    final fractional = value - value.floorToDouble();
    return fractional < 0.5
        ? fractional * 2 - 0.5
        : 0.5 - ((fractional - 0.5) * 2);
  }

  double _unitWave(double value) {
    final fractional = value - value.floorToDouble();
    return Curves.easeInOut.transform(fractional);
  }

  @override
  bool shouldRepaint(covariant _StreakPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.dense != dense;
}

class _AnimatedStreak {
  const _AnimatedStreak({
    required this.color,
    required this.alpha,
    required this.width,
    required this.start,
    required this.controlA,
    required this.controlB,
    required this.end,
    required this.speed,
    required this.phase,
  });

  final Color color;
  final double alpha;
  final double width;
  final Offset start;
  final Offset controlA;
  final Offset controlB;
  final Offset end;
  final double speed;
  final double phase;
}

class _PrimaryNavItem {
  const _PrimaryNavItem({
    required this.label,
    required this.shortLabel,
    required this.branchIndex,
    required this.icon,
  });

  final String label;
  final String shortLabel;
  final int branchIndex;
  final IconData icon;
}

const _primaryNavItems = <_PrimaryNavItem>[
  _PrimaryNavItem(
    label: 'Home',
    shortLabel: 'Home',
    branchIndex: 0,
    icon: Icons.home_filled,
  ),
  _PrimaryNavItem(
    label: 'Leaderboard',
    shortLabel: 'Scores',
    branchIndex: 1,
    icon: Icons.emoji_events_outlined,
  ),
  _PrimaryNavItem(
    label: 'Setup',
    shortLabel: 'Setup',
    branchIndex: 2,
    icon: Icons.settings_outlined,
  ),
];
