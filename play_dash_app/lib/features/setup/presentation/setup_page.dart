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
          name: value.isEmpty ? 'Player ${index + 1}' : value);
    });

    ref.read(x01ControllerProvider.notifier).startMatch(players: players);
    setState(() => _showMatchScreen = true);

    try {
      context.go('/match/x01');
    } catch (_) {
      // Local fallback already activated above.
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
          'The roster screen was rebuilt into a two-panel control sheet with clearer hierarchy, larger form rhythm, and faster confirmation before jumping into a match.',
      hero: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          StatusPill(
              label: 'Large tap targets',
              icon: Icons.touch_app_rounded,
              tinted: true),
          StatusPill(
              label: 'Responsive roster',
              icon: Icons.view_compact_alt_outlined),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 980;
          final form = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 28 : 22),
            radius: 32,
            blur: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  title: 'Match roster',
                  subtitle:
                      'One primary panel handles player count, names, and action confirmation so setup feels direct and predictable.',
                ),
                const SizedBox(height: 22),
                FrostPanel(
                  radius: 26,
                  blur: 6,
                  backgroundOpacity: 0.46,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Player count',
                              style: Theme.of(context).textTheme.titleMedium),
                          Text('$_playerCount',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Slider(
                        value: _playerCount.toDouble(),
                        min: _minPlayers.toDouble(),
                        max: _maxPlayers.toDouble(),
                        divisions: _maxPlayers - _minPlayers,
                        label: '$_playerCount players',
                        onChanged: (value) =>
                            setState(() => _playerCount = value.round()),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _playerCount == 1
                              ? 'Solo practice mode'
                              : 'Ready for $_playerCount players',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
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
                    MetricCard(
                        label: 'Active names',
                        value: '$_playerCount players',
                        compact: true,
                        icon: Icons.badge_outlined),
                    const MetricCard(
                        label: 'Mode',
                        value: 'X01 ready',
                        compact: true,
                        icon: Icons.sports_score_outlined,
                        highlight: true),
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
                        if (index == _playerCount - 1) _startMatch();
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
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.92),
                          Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValues(alpha: 0.84),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.22),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Continue',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          final previewPanel = GlassPanel(
            padding: EdgeInsets.all(constraints.maxWidth >= 720 ? 28 : 22),
            radius: 32,
            blur: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  title: 'Quick checklist',
                  subtitle:
                      'A secondary summary panel mirrors the reference style with stacked glass cards and concise pre-match confirmations.',
                ),
                const SizedBox(height: 22),
                const MetricCard(
                    label: 'Board state',
                    value: 'Ready to score',
                    icon: Icons.track_changes_outlined,
                    highlight: true),
                const SizedBox(height: 12),
                const MetricCard(
                    label: 'Ruleset',
                    value: '501 · Double out',
                    icon: Icons.rule_folder_outlined),
                const SizedBox(height: 18),
                FrostPanel(
                  radius: 26,
                  blur: 6,
                  backgroundOpacity: 0.46,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Players',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      ...preview.map((name) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.16),
                                  ),
                                  alignment: Alignment.center,
                                  child:
                                      Text(name.characters.first.toUpperCase()),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Text(name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );

          return wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 6, child: form),
                  const SizedBox(width: 20),
                  Expanded(flex: 4, child: previewPanel)
                ])
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [form, const SizedBox(height: 20), previewPanel]);
        },
      ),
    );
  }
}
