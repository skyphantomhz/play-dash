import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/feedback_service.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const RepaintBoundary(child: _AppBackground()),
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
                background: const Color(0x1A0A1040),
                borderColor: const Color(0x3337D8FF),
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
            Border.all(color: const Color(0xFF37D8FF).withValues(alpha: 0.12), width: 1.0),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF04091E), Color(0xFF0F0835), Color(0xFF130626)],
        ),
        boxShadow: [
          const BoxShadow(
            color: Color(0x9902030A),
            blurRadius: 40,
            offset: Offset(0, 22),
          ),
          BoxShadow(
            color: const Color(0xFF37D8FF).withValues(alpha: 0.14),
            blurRadius: 54,
            spreadRadius: -10,
          ),
          BoxShadow(
            color: const Color(0xFFFF00CC).withValues(alpha: 0.10),
            blurRadius: 68,
            spreadRadius: -18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isDesktop ? 26 : 24),
        child: Stack(
          children: [
            const Positioned.fill(
                child: RepaintBoundary(child: _InnerCosmos())),
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
                    child: RepaintBoundary(child: navigationShell),
                  ),
                ),
                if (showBottomNav)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: RepaintBoundary(
                      child: _MobileBottomBar(
                        currentIndex: navigationShell.currentIndex,
                        onSelectBranch: onSelectBranch ?? (_) {},
                      ),
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
    this.background = const Color(0x1A0A1040), // very transparent dark blue/purple
    this.borderColor = const Color(0x2837D8FF), // subtle cyan border by default
    this.glowColor,
    this.shadowColor = const Color(0x66000000),
    this.onTap,
    this.useRepaintBoundary = true,
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
  final bool useRepaintBoundary;

  @override
  Widget build(BuildContext context) {
    Widget content = ClipRRect(
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
              color: Colors.white.withValues(alpha: 0.13),
              width: 0.8,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.14),
                Colors.transparent,
                Colors.white.withValues(alpha: 0.04),
              ],
              stops: const [0.0, 0.32, 1.0],
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: background,
            border: Border.all(
              color: borderColor.withValues(
                  alpha: (borderColor.a + 0.10).clamp(0.0, 1.0)),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.52),
                blurRadius: 32,
                offset: const Offset(0, 20),
              ),
              if (glowColor != null) ...[
                BoxShadow(
                  color: glowColor!.withValues(alpha: 0.22),
                  blurRadius: 42,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: glowColor!.withValues(alpha: 0.10),
                  blurRadius: 72,
                  spreadRadius: 8,
                ),
              ] else ...[
                BoxShadow(
                  color: const Color(0xFF37D8FF).withValues(alpha: 0.09),
                  blurRadius: 38,
                  spreadRadius: -1,
                ),
                BoxShadow(
                  color: const Color(0xFFFF4FD8).withValues(alpha: 0.07),
                  blurRadius: 60,
                  spreadRadius: -4,
                  offset: const Offset(0, 6),
                ),
              ],
            ],
          ),
          child: child,
        ),
      ),
    );

    if (useRepaintBoundary) {
      content = RepaintBoundary(child: content);
    }

    if (onTap == null) return content;
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onTap == null ? null : () { FeedbackService.instance.playImpact(); onTap!(); },
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
    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.40),
              blurRadius: 30,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: accent.withValues(alpha: 0.26),
              blurRadius: 44,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: (secondaryAccent ?? accent).withValues(alpha: 0.14),
              blurRadius: 72,
              spreadRadius: 6,
            ),
          ],
        ),
        child: GlassPanel(
          radius: radius,
          padding: padding,
          blur: 24,
          background: const Color(0x1A0A1040),
          borderColor: accent.withValues(alpha: 0.55),
          glowColor: accent,
          onTap: onTap == null ? null : () { FeedbackService.instance.playImpact(); onTap!(); },
          child: child,
        ),
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
                onTap: widget.onPressed == null ? null : () { FeedbackService.instance.playImpact(); widget.onPressed?.call(); },
                borderRadius: BorderRadius.circular(widget.compact ? 12 : 16),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(widget.compact ? 12 : 16),
                    gradient: widget.highlight
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF00D4FF), Color(0xFFFF00CC)],
                          )
                        : const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF1A2755), Color(0xFF0E1535)],
                          ),
                    border: Border.all(
                      color: widget.highlight
                          ? Colors.white.withValues(alpha: 0.25)
                          : const Color(0xFF37D8FF).withValues(alpha: 0.22),
                      width: widget.highlight ? 1.4 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.36),
                        blurRadius: 26,
                        offset: const Offset(0, 16),
                      ),
                      BoxShadow(
                        color: (widget.highlight
                                ? const Color(0xFF00D4FF)
                                : const Color(0xFF37D8FF))
                            .withValues(
                          alpha: widget.highlight
                              ? (_hovered ? 0.32 : 0.22)
                              : (_hovered ? 0.12 : 0.07),
                        ),
                        blurRadius: widget.highlight ? 42 : 28,
                        spreadRadius: widget.highlight ? 2 : 0,
                      ),
                      BoxShadow(
                        color: (widget.highlight
                                ? const Color(0xFFFF00CC)
                                : const Color(0xFF8B5CF6))
                            .withValues(
                          alpha: widget.highlight
                              ? (_hovered ? 0.24 : 0.16)
                              : (_hovered ? 0.07 : 0.04),
                        ),
                        blurRadius: widget.highlight ? 64 : 38,
                        spreadRadius: widget.highlight ? 4 : 0,
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
                                  fontWeight: FontWeight.w800,
                                  shadows: const [
                                    Shadow(
                                      color: Color(0x99000000),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ])),
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
      background: const Color(0x1A0A1040),
      borderColor: const Color(0x3337D8FF),
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
              onTap: () { FeedbackService.instance.playImpact(); onSelectBranch(item.branchIndex); },
            ),
            const SizedBox(height: 8),
          ],
          const Spacer(),
          const GlassPanel(
            radius: 18,
            blur: 18,
            background: Color(0x220A1040),
            borderColor: Color(0x3337D8FF),
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
      onTap: () { FeedbackService.instance.playImpact(); onTap(); },
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
      background: const Color(0x220A1040),
      borderColor: const Color(0x3337D8FF),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        children: _primaryNavItems.map((item) {
          final selected = currentIndex == item.branchIndex;
          return Expanded(
            child: InkWell(
              onTap: () { FeedbackService.instance.playImpact(); onSelectBranch(item.branchIndex); },
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
        // Vibrant cosmic base: dark navy top-left → deep space purple → dark bottom-right
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF03071A), // dark navy blue
                  Color(0xFF12063A), // deep space purple
                  Color(0xFF050113), // dark bottom right
                ],
                stops: [0.0, 0.50, 1.0],
              ),
            ),
          ),
        ),
        // Top-left vivid blue/cyan blob (~600 size, opacity 0.4)
        Positioned(
          top: -160,
          left: -120,
          child: _GlowBlob(
            size: 600,
            colors: [Color(0x6600E5FF), Color(0x0000E5FF)],
          ),
        ),
        // Middle-right / bottom vivid magenta/pink blob (~500 size, opacity 0.4)
        Positioned(
          bottom: -100,
          right: -80,
          child: _GlowBlob(
            size: 500,
            colors: [Color(0x66FF00CC), Color(0x00FF00CC)],
          ),
        ),
        // Extra upper-right subtle blue accent
        Positioned(
          top: -60,
          right: -140,
          child: _GlowBlob(
            size: 380,
            colors: [Color(0x330080FF), Color(0x000080FF)],
          ),
        ),
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
                  Color(0xFF040C22), // dark navy
                  Color(0xFF160840), // deep purple
                  Color(0xFF030610), // near-black
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: -120,
          left: -80,
          child: _GlowBlob(
            size: 380,
            colors: [Color(0x4437D8FF), Color(0x0037D8FF)],
          ),
        ),
        Positioned(
          top: 30,
          right: -130,
          child: _GlowBlob(
            size: 320,
            colors: [Color(0x44FF4FD8), Color(0x00FF4FD8)],
          ),
        ),
        Positioned(
          bottom: -160,
          right: 60,
          child: _GlowBlob(
            size: 360,
            colors: [Color(0x338B5CF6), Color(0x008B5CF6)],
          ),
        ),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: colors,
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }
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
