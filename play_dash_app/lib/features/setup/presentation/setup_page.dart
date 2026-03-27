import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    (int index) => TextEditingController(text: 'Player ${index + 1}'),
  );

  @override
  void dispose() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startMatch() {
    FocusScope.of(context).unfocus();

    final players = List<Player>.generate(_playerCount, (int index) {
      final trimmedName = _nameControllers[index].text.trim();
      final resolvedName =
          trimmedName.isEmpty ? 'Player ${index + 1}' : trimmedName;

      return Player(id: 'player-${index + 1}', name: resolvedName);
    });

    ref.read(x01ControllerProvider.notifier).startMatch(players: players);
    setState(() => _showMatchScreen = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_showMatchScreen) {
      return const X01GamePage();
    }

    final previewNames = List<String>.generate(_playerCount, (index) {
      final trimmed = _nameControllers[index].text.trim();
      return trimmed.isEmpty ? 'Player ${index + 1}' : trimmed;
    });

    return AppShell(
      title: 'Player setup',
      subtitle:
          'Configure the lineup once, then move straight into a match with less friction and better readability.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          StatusPill(label: 'Large tap targets', icon: Icons.touch_app_rounded),
          StatusPill(label: 'Fast roster flow', icon: Icons.speed_rounded),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 960;

          final formPanel = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 28 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  title: 'Match roster',
                  subtitle:
                      'Use larger tap targets and fewer steps so players can set up quickly on mobile, tablet, or desktop.',
                ),
                const SizedBox(height: 24),
                GlassPanel(
                  radius: 22,
                  blur: 14,
                  opacity: 0.42,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Player count',
                              style: theme.textTheme.titleMedium),
                          Text(
                            '$_playerCount',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Slider(
                        value: _playerCount.toDouble(),
                        min: _minPlayers.toDouble(),
                        max: _maxPlayers.toDouble(),
                        divisions: _maxPlayers - _minPlayers,
                        label: '$_playerCount players',
                        onChanged: (value) {
                          setState(() => _playerCount = value.round());
                        },
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _playerCount == 1
                              ? 'Solo practice mode'
                              : 'Ready for $_playerCount players',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    MetricCard(
                      label: 'Active names',
                      value: '$_playerCount players',
                      icon: Icons.badge_outlined,
                      compact: true,
                    ),
                    const MetricCard(
                      label: 'Mode',
                      value: 'X01 ready',
                      icon: Icons.sports_score_outlined,
                      highlight: true,
                      compact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...List<Widget>.generate(_playerCount, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TextField(
                      controller: _nameControllers[index],
                      textInputAction: index == _playerCount - 1
                          ? TextInputAction.done
                          : TextInputAction.next,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) {
                        if (index == _playerCount - 1) {
                          _startMatch();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Player ${index + 1}',
                        hintText: 'Enter player name',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _startMatch,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary.withValues(alpha: 0.88),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.24),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Continue',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          final checklistPanel = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 28 : 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  title: 'Quick checklist',
                  subtitle:
                      'A lightweight secondary panel keeps the main form focused and gives players confidence before the match begins.',
                ),
                const SizedBox(height: 20),
                const MetricCard(
                  label: 'Display fit',
                  value: 'Phone, tablet, desktop',
                  icon: Icons.devices_outlined,
                ),
                const SizedBox(height: 12),
                MetricCard(
                  label: 'Roster status',
                  value:
                      _playerCount > 1 ? 'Multiplayer ready' : 'Practice ready',
                  icon: Icons.group_add_outlined,
                ),
                const SizedBox(height: 12),
                const MetricCard(
                  label: 'Next step',
                  value: 'Launch match',
                  icon: Icons.arrow_forward_rounded,
                  highlight: true,
                ),
                const SizedBox(height: 18),
                GlassPanel(
                  radius: 22,
                  blur: 14,
                  opacity: 0.44,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'X01 Game',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Current player: ${previewNames.first}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: previewNames
                            .map(
                              (name) => StatusPill(
                                label: name,
                                icon: Icons.person_outline,
                                tinted: name == previewNames.first,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: formPanel),
                    const SizedBox(width: 20),
                    Expanded(flex: 3, child: checklistPanel),
                  ],
                )
              : Column(
                  children: [
                    formPanel,
                    const SizedBox(height: 20),
                    checklistPanel,
                  ],
                );
        },
      ),
    );
  }
}
