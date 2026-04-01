import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/feedback_service.dart';
import '../../../shared/widgets/app_shell.dart';
import '../application/feedback_settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  // ── palette ──────────────────────────────────────────────────────────────
  static const _cyan = Color(0xFF37D8FF);
  static const _purple = Color(0xFF8B5CF6);
  static const _pink = Color(0xFFFF4FD8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(feedbackSettingsProvider);
    final notifier = ref.read(feedbackSettingsProvider.notifier);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1180;

    Widget body = _SettingsBody(
      settings: settings,
      notifier: notifier,
      isDesktop: isDesktop,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: body,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main body
// ─────────────────────────────────────────────────────────────────────────────

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({
    required this.settings,
    required this.notifier,
    required this.isDesktop,
  });

  final FeedbackSettingsState settings;
  final FeedbackSettingsNotifier notifier;
  final bool isDesktop;

  static const _cyan = Color(0xFF37D8FF);
  static const _purple = Color(0xFF8B5CF6);
  static const _pink = Color(0xFFFF4FD8);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: isDesktop ? 28 : 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Page heading ────────────────────────────────────────────
              _PageHeader(isDesktop: isDesktop),
              SizedBox(height: isDesktop ? 28 : 20),

              // ── Preferences card ────────────────────────────────────────
              NeonCard(
                accent: _cyan,
                secondaryAccent: _purple,
                radius: 22,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeading(
                      title: 'Preferences',
                      subtitle: 'Customise your play experience.',
                      compact: false,
                    ),
                    const SizedBox(height: 16),
                    _ToggleRow(
                      icon: Icons.vibration_rounded,
                      accentColor: _cyan,
                      label: 'Haptic Feedback',
                      description: 'Vibrate on button taps and score inputs.',
                      value: settings.hapticsEnabled,
                      onChanged: (v) => notifier.setHapticsEnabled(v),
                    ),
                    const SizedBox(height: 10),
                    _ToggleRow(
                      icon: Icons.music_note_rounded,
                      accentColor: _purple,
                      label: 'Sound Effects',
                      description: 'Play audio cues during matches.',
                      value: settings.audioEnabled,
                      onChanged: (v) => notifier.setAudioEnabled(v),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isDesktop ? 18 : 14),

              // ── Feedback card ────────────────────────────────────────────
              NeonCard(
                accent: _pink,
                secondaryAccent: _purple,
                radius: 22,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeading(
                      title: 'Feedback',
                      subtitle: 'Help us improve Play Dash.',
                      compact: false,
                    ),
                    const SizedBox(height: 16),
                    _FeedbackButton(context: context),
                  ],
                ),
              ),

              SizedBox(height: isDesktop ? 18 : 14),

              // ── About card ───────────────────────────────────────────────
              NeonCard(
                accent: _purple,
                secondaryAccent: _pink,
                radius: 22,
                padding: const EdgeInsets.all(20),
                child: const _AboutSection(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page header
// ─────────────────────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: isDesktop ? 48 : 40,
          height: isDesktop ? 48 : 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF37D8FF), Color(0xFF8B5CF6)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF37D8FF).withValues(alpha: 0.35),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            Icons.tune_rounded,
            color: Colors.white,
            size: isDesktop ? 24 : 20,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 26 : 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const Text(
              'Manage your app preferences',
              style: TextStyle(
                color: Color(0xB3FFFFFF),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Toggle row
// ─────────────────────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.accentColor,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color accentColor;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 16,
      blur: 16,
      background: Colors.white.withValues(alpha: 0.04),
      borderColor: accentColor.withValues(alpha: value ? 0.35 : 0.12),
      glowColor: value ? accentColor : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Icon chip
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: accentColor.withValues(alpha: value ? 0.20 : 0.08),
              border: Border.all(
                color: accentColor.withValues(alpha: value ? 0.40 : 0.15),
                width: 1.0,
              ),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(width: 12),
          // Label + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xB3FFFFFF),
                    fontSize: 11.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Toggle
          Switch.adaptive(
            value: value,
            onChanged: (v) {
              FeedbackService.instance.playImpact();
              onChanged(v);
            },
            activeColor: accentColor,
            activeTrackColor: accentColor.withValues(alpha: 0.30),
            inactiveThumbColor: Colors.white38,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.08),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feedback button
// ─────────────────────────────────────────────────────────────────────────────

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({required this.context});

  final BuildContext context;

  void _sendFeedback(BuildContext ctx) {
    FeedbackService.instance.playSuccess();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A2755),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: const Color(0xFF37D8FF).withValues(alpha: 0.35),
            width: 1.0,
          ),
        ),
        content: const Row(
          children: [
            Icon(Icons.favorite_rounded, color: Color(0xFFFF4FD8), size: 18),
            SizedBox(width: 10),
            Text(
              'Thanks for your feedback!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      label: 'Send Feedback',
      icon: Icons.send_rounded,
      highlight: true,
      trailingIcon: Icons.not_interested,
      onPressed: () => _sendFeedback(context),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// About section
// ─────────────────────────────────────────────────────────────────────────────

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  static const _cyan = Color(0xFF37D8FF);
  static const _purple = Color(0xFF8B5CF6);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          title: 'About App',
          subtitle: 'Build information and credits.',
        ),
        const SizedBox(height: 16),
        // App identity row
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF37D8FF), Color(0xFF8B5CF6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _cyan.withValues(alpha: 0.30),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_bar_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Play Dash',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Version 0.1.3',
                  style: TextStyle(
                    color: Color(0xB3FFFFFF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        GlassPanel(
          radius: 14,
          blur: 14,
          background: Colors.white.withValues(alpha: 0.04),
          borderColor: Colors.white.withValues(alpha: 0.06),
          padding: const EdgeInsets.all(14),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A fast, beautiful darts scoring companion built for pubs, '
                'garages, and competitive evenings. Supports X01 and Cricket '
                'game modes with real-time tracking.',
                style: TextStyle(
                  color: Color(0xCCFFFFFF),
                  fontSize: 12.5,
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '© 2024 Play Dash. All rights reserved.',
                style: TextStyle(
                  color: Color(0x80FFFFFF),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
