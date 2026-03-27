import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.child,
    this.desktopTopTabs = const <ShellTab>[
      ShellTab(label: 'Home', route: '/'),
      ShellTab(label: 'Leaderboard', route: '/leaderboard'),
      ShellTab(label: 'Stats', route: '/leaderboard'),
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
      backgroundColor: const Color(0xFFF5F2F0),
      body: Stack(
        children: [
          const Positioned.fill(child: _PageBackdrop()),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1540),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isDesktop ? 34 : 12,
                    isDesktop ? 26 : 10,
                    isDesktop ? 34 : 12,
                    isDesktop ? 26 : 12,
                  ),
                  child: FrostPanel(
                    radius: isDesktop ? 28 : 26,
                    blur: 10,
                    backgroundOpacity: 0.16,
                    borderOpacity: 0.18,
                    padding: EdgeInsets.all(isDesktop ? 16 : 10),
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showDesktopSidebar) ...[
                                const SizedBox(width: 210, child: _DesktopSidebar()),
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
                        : _PhoneFrame(
                            child: _ShellSurface(
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
          ),
        ],
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

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isDesktop ? 24 : 22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xCC0A1432), Color(0xCC0F1037), Color(0xCC200B33)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 36,
            offset: Offset(0, 22),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isDesktop ? 24 : 22),
        child: Stack(
          children: [
            const Positioned.fill(child: _CosmicBackdrop()),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(isDesktop ? 18 : 12, 12, isDesktop ? 18 : 12, 8),
                  child: isDesktop
                      ? _DesktopTopBar(tabs: desktopTopTabs)
                      : _MobileTopBar(tabs: mobileTopTabs ?? desktopTopTabs),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(isDesktop ? 18 : 10, 4, isDesktop ? 18 : 10, showBottomNav ? 10 : 16),
                    child: expandChild
                        ? child
                        : SingleChildScrollView(
                            child: child,
                          ),
                  ),
                ),
                if (showBottomNav)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: _MobileBottomBar(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
          const SizedBox(width: 10),
        ],
        const Spacer(),
        const Icon(Icons.notifications_none_rounded, size: 18, color: Colors.white70),
        const SizedBox(width: 12),
        const Icon(Icons.search_rounded, size: 18, color: Colors.white70),
        const SizedBox(width: 12),
        _GhostChip(
          label: 'Settings',
          icon: Icons.settings_outlined,
          onTap: () => context.go('/settings'),
        ),
        const SizedBox(width: 8),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white.withValues(alpha: 0.06),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: const Icon(Icons.crop_square_rounded, size: 12, color: Colors.white70),
        ),
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
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 12, backgroundColor: Color(0x3364D4FF), child: Icon(Icons.person, size: 14, color: Colors.white)),
            const Spacer(),
            for (final tab in tabs.take(4)) ...[
              _TopTabChip(tab: tab, selected: location == tab.route, mobile: true),
              const SizedBox(width: 6),
            ],
          ],
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
    return FrostPanel(
      radius: 22,
      blur: 8,
      backgroundOpacity: 0.12,
      borderOpacity: 0.16,
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
          FrostPanel(
            radius: 18,
            blur: 6,
            backgroundOpacity: 0.10,
            borderOpacity: 0.14,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text(
                  'Subtle blur, luminous borders, and tighter spacing rebuilt to match the reference.',
                  style: TextStyle(color: Color(0xB3E9ECFF), fontSize: 12.5, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FrostPanel extends StatelessWidget {
  const FrostPanel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 22,
    this.blur = 8,
    this.backgroundOpacity = 0.14,
    this.borderOpacity = 0.18,
    this.gradient,
    this.shadowColor,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double blur;
  final double backgroundOpacity;
  final double borderOpacity;
  final Gradient? gradient;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    const Color(0x66131E42).withValues(alpha: backgroundOpacity + 0.10),
                    const Color(0x66210F34).withValues(alpha: backgroundOpacity + 0.06),
                  ],
                ),
            border: Border.all(color: Colors.white.withValues(alpha: borderOpacity)),
            boxShadow: [
              BoxShadow(
                color: (shadowColor ?? Colors.black).withValues(alpha: 0.20),
                blurRadius: 24,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class NeonCard extends StatelessWidget {
  const NeonCard({
    required this.child,
    required this.accent,
    this.secondaryAccent,
    this.padding = const EdgeInsets.all(18),
    this.radius = 24,
    super.key,
  });

  final Widget child;
  final Color accent;
  final Color? secondaryAccent;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: radius,
      blur: 9,
      backgroundOpacity: 0.14,
      borderOpacity: 0.28,
      shadowColor: accent,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accent.withValues(alpha: 0.26),
          (secondaryAccent ?? accent).withValues(alpha: 0.10),
          const Color(0x5510172F),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class GlassButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(compact ? 18 : 24);
    final gradient = highlight
        ? const LinearGradient(
            colors: [Color(0xFF2CB6FF), Color(0xFF2A84FF), Color(0xFF6B4CFF)],
          )
        : const LinearGradient(
            colors: [Color(0x66FFFFFF), Color(0x33214874), Color(0x332B154B)],
          );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: gradient,
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            boxShadow: [
              BoxShadow(
                color: (highlight ? const Color(0xFF4DB4FF) : Colors.black).withValues(alpha: 0.26),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 18, vertical: compact ? 12 : 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: compact ? 18 : 20, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: compact ? 14 : 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(trailingIcon, size: compact ? 18 : 20, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreBadge extends StatelessWidget {
  const ScoreBadge({
    required this.value,
    this.highlight = false,
    this.large = false,
    super.key,
  });

  final String value;
  final bool highlight;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final gradient = highlight
        ? const LinearGradient(colors: [Color(0xFF2AB4FF), Color(0xFF14D9FF)])
        : const LinearGradient(colors: [Color(0x33FFFFFF), Color(0x222A4E7A)]);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: large ? 18 : 12, vertical: large ? 12 : 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: gradient,
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: large ? 18 : 13,
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    this.subtitle,
    this.trailing,
    this.compact = false,
    super.key,
  });

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
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: compact ? 16 : 20,
                  letterSpacing: -0.4,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Color(0xB3E8EDFF),
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: (tinted ? const Color(0xFF2BB8FF) : Colors.white).withValues(alpha: tinted ? 0.14 : 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: tinted ? const Color(0xFF78E2FF) : Colors.white70),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
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
    return FrostPanel(
      radius: 18,
      blur: 6,
      backgroundOpacity: highlight ? 0.18 : 0.10,
      borderOpacity: highlight ? 0.22 : 0.14,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: highlight ? const Color(0xFF7DE6FF) : Colors.white70),
            const SizedBox(width: 10),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xB3E8EDFF), fontSize: 11.5)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14.5)),
            ],
          ),
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
      radius: 18,
      blur: 6,
      backgroundOpacity: highlight ? 0.18 : 0.10,
      borderOpacity: highlight ? 0.22 : 0.14,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 10)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(color: Color(0xB3E8EDFF), fontSize: 11.5, height: 1.35)),
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
  const PlayerAvatar({
    required this.name,
    required this.colors,
    this.radius = 22,
    super.key,
  });

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
        border: Border.all(color: Colors.white.withValues(alpha: 0.55), width: 2),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.38),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        name.trim().isEmpty ? '?' : name.trim().characters.first.toUpperCase(),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: radius * 0.9),
      ),
    );
  }
}

class ShellTab {
  const ShellTab({required this.label, required this.route});

  final String label;
  final String route;
}

class _TopTabChip extends StatelessWidget {
  const _TopTabChip({required this.tab, required this.selected, this.mobile = false});

  final ShellTab tab;
  final bool selected;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(tab.route),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mobile ? 10 : 12, vertical: mobile ? 7 : 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? Colors.white.withValues(alpha: 0.10) : Colors.transparent,
        ),
        child: Text(
          tab.label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: mobile ? 11 : 12.5,
          ),
        ),
      ),
    );
  }
}

class _GhostChip extends StatelessWidget {
  const _GhostChip({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
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
          width: compact ? 34 : 30,
          height: compact ? 34 : 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(colors: [Color(0xFF0D4077), Color(0xFF071D3C)]),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          alignment: Alignment.center,
          child: Text('Wb', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: compact ? 12 : 11.5)),
        ),
        const SizedBox(width: 10),
        if (compact)
          const Text('ORAITIES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13))
        else
          const Text('ORAITIES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
      ],
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: selected
              ? const LinearGradient(colors: [Color(0x332DB6FF), Color(0x22145AFF)])
              : null,
          border: Border.all(color: Colors.white.withValues(alpha: selected ? 0.22 : 0.06)),
          boxShadow: selected
              ? const [BoxShadow(color: Color(0x222DB6FF), blurRadius: 16, offset: Offset(0, 8))]
              : null,
        ),
        child: Row(
          children: [
            Icon(item.icon, size: 18, color: Colors.white),
            const SizedBox(width: 10),
            Text(item.label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _MobileBottomBar extends StatelessWidget {
  const _MobileBottomBar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return FrostPanel(
      radius: 18,
      blur: 8,
      backgroundOpacity: 0.14,
      borderOpacity: 0.16,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                  gradient: selected ? const LinearGradient(colors: [Color(0xFF2CAFFF), Color(0xFF6E49FF)]) : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, size: 18, color: Colors.white),
                    const SizedBox(height: 4),
                    Text(item.shortLabel, style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700)),
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

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 430;
    if (!narrow) return child;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: child,
      ),
    );
  }
}

class _PageBackdrop extends StatelessWidget {
  const _PageBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF4F0EF), Color(0xFFF7F4F4)],
            ),
          ),
        ),
        Positioned(top: 70, left: -40, child: _OuterGlow(color: Color(0x557541FF), size: 220)),
        Positioned(top: 160, right: -50, child: _OuterGlow(color: Color(0x5529D0FF), size: 240)),
        Positioned(bottom: -70, left: 120, child: _OuterGlow(color: Color(0x55FF4FBC), size: 260)),
      ],
    );
  }
}

class _CosmicBackdrop extends StatelessWidget {
  const _CosmicBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.1, -0.2),
                radius: 1.2,
                colors: [Color(0xFF132A63), Color(0xFF0A1537), Color(0xFF130A33)],
              ),
            ),
          ),
        ),
        Positioned(left: -40, top: 40, child: _OuterGlow(color: Color(0xAA17BFFF), size: 200)),
        Positioned(right: -50, top: 80, child: _OuterGlow(color: Color(0xAAFF4ADF), size: 220)),
        Positioned(left: 160, bottom: -30, child: _OuterGlow(color: Color(0xAA693CFF), size: 260)),
        Positioned.fill(child: _StarLayer()),
      ],
    );
  }
}

class _OuterGlow extends StatelessWidget {
  const _OuterGlow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0.18), Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class _StarLayer extends StatelessWidget {
  const _StarLayer();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _StarsPainter());
  }
}

class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[
      for (int i = 0; i < 70; i++) Offset((i * 73 % 1000) / 1000 * size.width, (i * 37 % 1000) / 1000 * size.height),
    ];
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.40);
    for (final point in points) {
      canvas.drawCircle(point, 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NavItem {
  const _NavItem({required this.label, required this.shortLabel, required this.route, required this.icon});

  final String label;
  final String shortLabel;
  final String route;
  final IconData icon;
}

const _navItems = <_NavItem>[
  _NavItem(label: 'Home', shortLabel: 'Home', route: '/', icon: Icons.home_filled),
  _NavItem(label: 'Leaderboard', shortLabel: 'Leads', route: '/leaderboard', icon: Icons.emoji_events_outlined),
  _NavItem(label: 'Stats', shortLabel: 'Stats', route: '/leaderboard', icon: Icons.bar_chart_rounded),
  _NavItem(label: 'History', shortLabel: 'History', route: '/leaderboard', icon: Icons.history_rounded),
  _NavItem(label: 'Settings', shortLabel: 'Setup', route: '/settings', icon: Icons.settings_outlined),
];
