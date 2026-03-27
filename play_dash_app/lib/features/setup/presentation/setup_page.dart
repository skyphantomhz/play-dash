import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/player.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../x01/application/x01_controller.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  static const int _minPlayers = 1;
  static const int _maxPlayers = 8;

  int _playerCount = 2;
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
    context.go('/match/x01');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppShell(
      title: 'Player setup',
      subtitle:
          'Configure the lineup once, then move straight into a match with less friction and better readability.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 960;

          final formPanel = GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  title: 'Match roster',
                  subtitle:
                      'Use larger tap targets and fewer steps so players can set up quickly on mobile or tablet.',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Player count', style: theme.textTheme.titleMedium),
                    Text('$_playerCount',
                        style: theme.textTheme.headlineMedium),
                  ],
                ),
                const SizedBox(height: 8),
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
                Text(
                  _playerCount == 1
                      ? 'Solo practice mode'
                      : 'Ready for $_playerCount players',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _startMatch,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(18),
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
                const SizedBox(height: 24),
                ...List<Widget>.generate(_playerCount, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TextField(
                      controller: _nameControllers[index],
                      textInputAction: index == _playerCount - 1
                          ? TextInputAction.done
                          : TextInputAction.next,
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
                const SizedBox(height: 10),
              ],
            ),
          );

          final checklistPanel = GlassPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  title: 'Quick checklist',
                  subtitle:
                      'A small secondary panel reduces cognitive load and keeps the main form focused.',
                ),
                const SizedBox(height: 18),
                const MetricCard(
                  label: 'Format',
                  value: 'X01 ready',
                  icon: Icons.sports_score_outlined,
                  highlight: true,
                ),
                const SizedBox(height: 12),
                MetricCard(
                  label: 'Display names',
                  value: '$_playerCount active',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 12),
                const MetricCard(
                  label: 'Best on',
                  value: 'Phone, tablet, desktop',
                  icon: Icons.devices_outlined,
                ),
              ],
            ),
          );

          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: formPanel),
                    const SizedBox(width: 20),
                    Expanded(flex: 3, child: checklistPanel),
                  ],
                )
              : formPanel;
        },
      ),
    );
  }
}
