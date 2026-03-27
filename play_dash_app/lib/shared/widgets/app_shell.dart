import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _AppBackground()),
        Positioned.fill(child: child),
      ],
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({
    required this.child,
    this.desktopTopTabs = const <ShellTab>[
      ShellTab(label: 'Home', route: '/'),
      ShellTab(label: 'Leaderboard', route: '/leaderboard'),
      ShellTab(label: 'Tents', route: '/leaderboard'),
      ShellTab(label: 'History', route: '/leaderboard'),
    ],
    this.mobileTopTabs,
    this.showDesktopSidebar = true,
    this.showBottomNav = true,
    this.expandChild = false,
    super.key,
  });

  final Widget child;
  final List<ShellTab> desktopTopTabs;
  final List<ShellTab>? mobileTopTabs;
  final bool showDesktopSidebar;
  final bool showBottomNav;
  final bool expandChild;

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
                borderColor: Colors.white.withValues(alpha: 0.12),
                padding: EdgeInsets.all(isDesktop ? 14 : 8),
                child: isDesktop
                    ? Row(
                        children: [
                          if (showDesktopSidebar) ...[
                            const SizedBox(width: 220, child: _DesktopSidebar()),
                            const SizedBox(width: 16),
                          ],
                          Expanded(
                            child: _ShellSurface(
                              desktopTopTabs: desktopTopTabs,
                              mobileTopTabs: mobileTopTabs,
                              showBottomNav: false,
                              expandChild: expandChild,
                              child: child,
                            ),
                          ),
                        ],
                      )
                    : _ShellSurface(
                        desktopTopTabs: desktopTopTabs,
                        mobileTopTabs: mobileTopTabs,
                        showBottomNav: showBottomNav,
                        expandChild: expandChild,
                        child: child,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellSurface extends StatelessWidget {
  const _ShellSurface({
    required this.child,
    required this.desktopTopTabs,
    required this.mobileTopTabs,
    required this.showBottomNav,
    required this.expandChild,
  });

  final Widget child;
  final List<ShellTab> desktopTopTabs;
  final List<ShellTab>? mobileTopTabs;
  final bool showBottomNav;
  final bool expandChild;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1180;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isDesktop ? 26 : 24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0F24), Color(0xFF0B1330), Color(0xFF170A2F)],
        ),
        boxShadow: const [
          BoxShadow(
              color: Color(0x66000000), blurRadius: 30, offset: Offset(0, 18)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isDesktop ? 26 : 24),
        child: Stack(
          children: [
            const Positioned.fill(child: _InnerCosmos()),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      isDesktop ? 16 : 12, 12, isDesktop ? 16 : 12, 8),
                  child: isDesktop
                      ? _DesktopTopBar(tabs: desktopTopTabs)
                      : _MobileTopBar(tabs: mobileTopTabs ?? desktopTopTabs),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(isDesktop ? 16 : 10, 8,
                        isDesktop ? 16 : 10, showBottomNav ? 10 : 16),
                    child: expandChild
                        ? child
                        : SingleChildScrollView(child: child),
                  ),
                ),
                if (showBottomNav)
                  const Padding(
                      padding: EdgeInsets.all(10), child: _MobileBottomBar()),
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
    this.borderColor = const Color(0x1FFFFFFF),
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: background,
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                  color: shadowColor.withValues(alpha: 0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 10)),
              if (glowColor != null)
                BoxShadow(
                    color: glowColor!.withValues(alpha: 0.18), blurRadius: 28),
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
          BoxShadow(color: accent.withValues(alpha: 0.22), blurRadius: 26),
          BoxShadow(
              color: (secondaryAccent ?? accent).withValues(alpha: 0.14),
              blurRadius: 42),
        ],
      ),
      child: GlassPanel(
        radius: radius,
        padding: padding,
        blur: 24,
        background: Colors.white.withValues(alpha: 0.06),
        borderColor: Colors.white.withValues(alpha: 0.14),
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
                        color: Colors.white
                            .withValues(alpha: widget.highlight ? 0 : 0.10)),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.highlight
                                ? const Color(0xFF37D8FF)
                                : Colors.black)
                            .withValues(
                                alpha: widget.highlight
                                    ? (_hovered ? 0.42 : 0.28)
                                    : 0.24),
                        blurRadius:
                            widget.highlight ? (_hovered ? 40 : 30) : 18,
                        offset: const Offset(0, 12),
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
        color: highlight ? null : Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
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
      borderColor: Colors.white.withValues(alpha: highlight ? 0.18 : 0.10),
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
      borderColor: Colors.white.withValues(alpha: highlight ? 0.16 : 0.10),
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
            Border.all(color: Colors.white.withValues(alpha: 0.65), width: 2),
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

class ShellTab {
  const ShellTab({required this.label, required this.route});

  final String label;
  final String route;
}

class _DesktopTopBar extends StatelessWidget {
  const _DesktopTopBar({required this.tabs});

  final List<ShellTab> tabs;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return Row(
      children: [
        const _BrandBadge(compact: false),
        const SizedBox(width: 18),
        for (final tab in tabs) ...[
          _TopTabChip(tab: tab, selected: location == tab.route),
          const SizedBox(width: 8),
        ],
        const Spacer(),
        const Icon(Icons.notifications_none_rounded,
            size: 18, color: Colors.white70),
        const SizedBox(width: 12),
        const Icon(Icons.search_rounded, size: 18, color: Colors.white70),
        const SizedBox(width: 12),
        _TopTabChip(
            tab: const ShellTab(label: 'Settings', route: '/settings'),
            selected: location == '/settings',
            icon: Icons.settings_outlined),
      ],
    );
  }
}

class _MobileTopBar extends StatelessWidget {
  const _MobileTopBar({required this.tabs});

  final List<ShellTab> tabs;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return Row(
      children: [
        const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0x2237D8FF),
            child: Icon(Icons.person, color: Colors.white, size: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final tab in tabs.take(4)) ...[
                  _TopTabChip(
                      tab: tab, selected: location == tab.route, mobile: true),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return GlassPanel(
      radius: 24,
      blur: 24,
      background: Colors.white.withValues(alpha: 0.05),
      borderColor: Colors.white.withValues(alpha: 0.12),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BrandBadge(compact: true),
          const SizedBox(height: 22),
          for (final item in _navItems) ...[
            _SidebarNavTile(item: item, selected: location == item.route),
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

class _TopTabChip extends StatelessWidget {
  const _TopTabChip(
      {required this.tab,
      required this.selected,
      this.mobile = false,
      this.icon});

  final ShellTab tab;
  final bool selected;
  final bool mobile;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(tab.route),
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
            horizontal: mobile ? 10 : 12, vertical: mobile ? 7 : 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.transparent,
          border: Border.all(
              color: Colors.white.withValues(alpha: selected ? 0.14 : 0.0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: mobile ? 12 : 14, color: Colors.white70),
              const SizedBox(width: 6),
            ],
            Text(tab.label,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: mobile ? 11 : 12.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _SidebarNavTile extends StatelessWidget {
  const _SidebarNavTile({required this.item, required this.selected});

  final _NavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(item.route),
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
              color: Colors.white.withValues(alpha: selected ? 0.14 : 0.03)),
          boxShadow: selected
              ? [const BoxShadow(color: Color(0x4437D8FF), blurRadius: 20)]
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
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
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
  const _MobileBottomBar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return GlassPanel(
      radius: 18,
      blur: 20,
      background: Colors.white.withValues(alpha: 0.06),
      borderColor: Colors.white.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        children: _navItems.take(4).map((item) {
          final selected = location == item.route;
          return Expanded(
            child: InkWell(
              onTap: () => context.go(item.route),
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
                    Color(0xFF060816),
                    Color(0xFF0B1330),
                    Color(0xFF140A2E)
                  ]),
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
                    Color(0xFF050917),
                    Color(0xFF0B1330),
                    Color(0xFF160B31)
                  ]),
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
    Color(0x4037D8FF),
    Color(0x33FF4FD8),
    Color(0x2E8B5CF6),
    Color(0x2237D8FF),
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
            (Offset(0.12, 0.16), 0.28, 0.08, 0.06),
            (Offset(0.88, 0.22), 0.26, -0.07, 0.05),
            (Offset(0.24, 0.82), 0.30, 0.06, -0.05),
            (Offset(0.78, 0.72), 0.22, -0.05, -0.04),
          ]
        : const [
            (Offset(0.10, 0.12), 0.34, 0.08, 0.05),
            (Offset(0.90, 0.28), 0.30, -0.08, 0.06),
            (Offset(0.22, 0.88), 0.32, 0.07, -0.04),
          ];

    for (var i = 0; i < blobs.length; i++) {
      final blob = blobs[i];
      final dx = _wave(progress + i * 0.13) * blob.$3 * size.width;
      final dy = _wave(progress * 0.8 + i * 0.21) * blob.$4 * size.height;
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
            colors: [
              color,
              color.withValues(alpha: color.a * 0.45),
              Colors.transparent
            ],
          ).createShader(rect),
      );
    }
  }

  void _paintStreaks(Canvas canvas, Size size) {
    final streaks = [
      _AnimatedStreak(
        color: const Color(0xFF37D8FF),
        alpha: dense ? 0.26 : 0.22,
        width: dense ? 1.7 : 1.45,
        start: Offset(0.04, 0.17),
        controlA: Offset(0.28, 0.02),
        controlB: Offset(0.70, 0.32),
        end: Offset(0.98, 0.16),
        speed: 1.0,
        phase: 0.0,
      ),
      _AnimatedStreak(
        color: const Color(0xFFFF4FD8),
        alpha: dense ? 0.22 : 0.18,
        width: dense ? 1.35 : 1.2,
        start: Offset(0.06, 0.74),
        controlA: Offset(0.22, 0.56),
        controlB: Offset(0.72, 0.86),
        end: Offset(0.97, 0.60),
        speed: 0.82,
        phase: 0.22,
      ),
      _AnimatedStreak(
        color: const Color(0xFF8B5CF6),
        alpha: dense ? 0.14 : 0.12,
        width: 1.1,
        start: Offset(0.12, 0.46),
        controlA: Offset(0.36, 0.30),
        controlB: Offset(0.58, 0.58),
        end: Offset(0.90, 0.42),
        speed: 0.64,
        phase: 0.47,
      ),
    ];

    for (final streak in streaks) {
      final shiftX =
          _wave(progress * streak.speed + streak.phase) * 0.04 * size.width;
      final shiftY =
          _wave(progress * (streak.speed * 0.9) + streak.phase + 0.11) *
              0.03 *
              size.height;
      final path = Path()
        ..moveTo(streak.start.dx * size.width + shiftX,
            streak.start.dy * size.height + shiftY)
        ..cubicTo(
          streak.controlA.dx * size.width - shiftX * 0.2,
          streak.controlA.dy * size.height + shiftY * 1.3,
          streak.controlB.dx * size.width + shiftX * 0.9,
          streak.controlB.dy * size.height - shiftY,
          streak.end.dx * size.width - shiftX * 0.4,
          streak.end.dy * size.height + shiftY * 0.4,
        );

      final basePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = streak.width
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            streak.color.withValues(alpha: streak.alpha),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(path, basePaint);

      final pulse = _unitWave(progress * streak.speed + streak.phase);
      final metrics = path.computeMetrics().toList();
      for (final metric in metrics) {
        final start = (metric.length * pulse).clamp(0.0, metric.length);
        final end = (start + metric.length * 0.18).clamp(0.0, metric.length);
        final highlight = metric.extractPath(start, end);
        canvas.drawPath(
          highlight,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = streak.width + 0.9
            ..strokeCap = StrokeCap.round
            ..shader = LinearGradient(
              colors: [
                streak.color.withValues(alpha: 0.0),
                streak.color.withValues(alpha: dense ? 0.72 : 0.62),
                Colors.white.withValues(alpha: dense ? 0.18 : 0.12),
              ],
            ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
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

class _NavItem {
  const _NavItem(
      {required this.label,
      required this.shortLabel,
      required this.route,
      required this.icon});

  final String label;
  final String shortLabel;
  final String route;
  final IconData icon;
}

const _navItems = <_NavItem>[
  _NavItem(
      label: 'Home', shortLabel: 'Home', route: '/', icon: Icons.home_filled),
  _NavItem(
      label: 'Leaderboard',
      shortLabel: 'Leads',
      route: '/leaderboard',
      icon: Icons.emoji_events_outlined),
  _NavItem(
      label: 'Stats',
      shortLabel: 'Stats',
      route: '/leaderboard',
      icon: Icons.bar_chart_rounded),
  _NavItem(
      label: 'History',
      shortLabel: 'History',
      route: '/leaderboard',
      icon: Icons.history_rounded),
  _NavItem(
      label: 'Settings',
      shortLabel: 'Setup',
      route: '/settings',
      icon: Icons.settings_outlined),
];
