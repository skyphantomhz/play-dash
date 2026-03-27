import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/player.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../x01/application/x01_controller.dart';
import '../../x01/presentation/x01_game_page.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  static const int _minPlayers = 1;
  static const int _maxPlayers = 8;

  int _playerCount = 2;
  bool _showMatchScreen = false;
  late final List<TextEditingController> _nameControllers = List.generate(
    _maxPlayers,
    (index) => TextEditingController(text: 'Player ${index + 1}'),
  );

  @override
  void dispose() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startMatch() {
    final players = List<Player>.generate(_playerCount, (index) {
      final value = _nameControllers[index].text.trim();
      return Player(
        id: 'player-${index + 1}',
        name: value.isEmpty ? 'Player ${index + 1}' : value,
      );
    });

    ref.read(x01ControllerProvider.notifier).startMatch(players: players);
    setState(() => _showMatchScreen = true);

    try {
      context.go('/match/x01');
    } catch (_) {
      // Fallback for embedded usage.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showMatchScreen) {
      return const X01GamePage();
    }

    final preview = List<String>.generate(_playerCount, (index) {
      final value = _nameControllers[index].text.trim();
      return value.isEmpty ? 'Player ${index + 1}' : value;
    });

    return AppShell(
      title: 'Player setup',
      subtitle:
          'The roster screen was rebuilt into a two-stage launch sheet: player controls on one side, session preview and readiness feedback on the other.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          StatusPill(
            label: 'Roster editing',
            icon: Icons.badge_outlined,
            tinted: true,
          ),
          StatusPill(
            label: 'Live launch preview',
            icon: Icons.rocket_launch_rounded,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1120;
          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _SetupForm(
                        playerCount: _playerCount,
                        minPlayers: _minPlayers,
                        maxPlayers: _maxPlayers,
                        nameControllers: _nameControllers,
                        onPlayerCountChanged: (value) =>
                            setState(() => _playerCount = value.round()),
                        onChanged: () => setState(() {}),
                        onStart: _startMatch,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 4,
                      child: _PreviewRail(
                        playerCount: _playerCount,
                        preview: preview,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _SetupForm(
                      playerCount: _playerCount,
                      minPlayers: _minPlayers,
                      maxPlayers: _maxPlayers,
                      nameControllers: _nameControllers,
                      onPlayerCountChanged: (value) =>
                          setState(() => _playerCount = value.round()),
                      onChanged: () => setState(() {}),
                      onStart: _startMatch,
                    ),
                    const SizedBox(height: 18),
                    _PreviewRail(playerCount: _playerCount, preview: preview),
                  ],
                );
        },
      ),
    );
  }
}

class _SetupForm extends StatelessWidget {
  const _SetupForm({
    required this.playerCount,
    required this.minPlayers,
    required this.maxPlayers,
    required this.nameControllers,
    required this.onPlayerCountChanged,
    required this.onChanged,
    required this.onStart,
  });

  final int playerCount;
  final int minPlayers;
  final int maxPlayers;
  final List<TextEditingController> nameControllers;
  final ValueChanged<double> onPlayerCountChanged;
  final VoidCallback onChanged;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 36,
      blur: 6,
      opacity: 0.42,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Roster builder',
            subtitle:
                'The launch form is torn down and rebuilt as a clear sequence: choose player count, name the roster, then start the match.',
          ),
          const SizedBox(height: 18),
          FrostPanel(
            radius: 28,
            blur: 5,
            backgroundOpacity: 0.34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Player count',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ScoreBadge(value: '$playerCount', highlight: true),
                  ],
                ),
                const SizedBox(height: 12),
                Slider(
                  value: playerCount.toDouble(),
                  min: minPlayers.toDouble(),
                  max: maxPlayers.toDouble(),
                  divisions: maxPlayers - minPlayers,
                  label: '$playerCount players',
                  onChanged: onPlayerCountChanged,
                ),
                Text(
                  playerCount == 1
                      ? 'Solo practice profile selected.'
                      : '$playerCount-player local session is ready.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              const MetricCard(
                label: 'Ruleset',
                value: '501 · Double out',
                icon: Icons.rule_folder_rounded,
                highlight: true,
              ),
              MetricCard(
                label: 'Ready slots',
                value: '$playerCount active',
                icon: Icons.groups_outlined,
              ),
            ],
          ),
          const SizedBox(height: 18),
          for (var index = 0; index < playerCount; index++) ...[
            FrostPanel(
              radius: 24,
              blur: 5,
              backgroundOpacity: 0.30,
              padding: const EdgeInsets.all(6),
              child: TextField(
                controller: nameControllers[index],
                textInputAction: index == playerCount - 1
                    ? TextInputAction.done
                    : TextInputAction.next,
                onChanged: (_) => onChanged(),
                onSubmitted: (_) {
                  if (index == playerCount - 1) onStart();
                },
                decoration: InputDecoration(
                  labelText: 'Player ${index + 1}',
                  hintText: 'Enter player name',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          GlassButton(
            onPressed: onStart,
            icon: Icons.play_arrow_rounded,
            label: 'Start match',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _PreviewRail extends StatelessWidget {
  const _PreviewRail({required this.playerCount, required this.preview});

  final int playerCount;
  final List<String> preview;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 36,
      blur: 6,
      opacity: 0.42,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Launch preview',
            subtitle:
                'The companion rail mirrors the main dashboard language with concise readiness cards and a compact player list.',
          ),
          const SizedBox(height: 18),
          const MetricCard(
            label: 'Mode',
            value: 'X01 launch',
            icon: Icons.sports_score_rounded,
            highlight: true,
          ),
          const SizedBox(height: 12),
          MetricCard(
            label: 'Players ready',
            value: '$playerCount',
            icon: Icons.check_circle_outline_rounded,
          ),
          const SizedBox(height: 18),
          FrostPanel(
            radius: 28,
            blur: 5,
            backgroundOpacity: 0.34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Entered roster',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                for (final name in preview) ...[
                  PanelListTile(
                    title: name,
                    subtitle: 'Ready for opening leg',
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.16),
                      child: Text(name.characters.first.toUpperCase()),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          const PanelListTile(
            title: 'Touch-first controls',
            subtitle: 'Inputs are larger, cleaner, and easier to scan on phones, tablets, and desktop web.',
            leading: Icon(Icons.touch_app_rounded),
          ),
        ],
      ),
    );
  }
}
