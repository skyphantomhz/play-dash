import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/player.dart';
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
    for (final TextEditingController controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startMatch() {
    FocusScope.of(context).unfocus();

    final players = List<Player>.generate(_playerCount, (int index) {
      final trimmedName = _nameControllers[index].text.trim();
      final resolvedName = trimmedName.isEmpty
          ? 'Player ${index + 1}'
          : trimmedName;

      return Player(
        id: 'player-${index + 1}',
        name: resolvedName,
      );
    });

    ref.read(x01ControllerProvider.notifier).startMatch(players: players);
    context.go('/match/x01');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Player Setup')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Get everyone ready for the next match.',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how many players are joining and set their display names before starting.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Player count',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          '$_playerCount',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: _playerCount.toDouble(),
                      min: _minPlayers.toDouble(),
                      max: _maxPlayers.toDouble(),
                      divisions: _maxPlayers - _minPlayers,
                      label: '$_playerCount players',
                      onChanged: (double value) {
                        setState(() {
                          _playerCount = value.round();
                        });
                      },
                    ),
                    Text(
                      _playerCount == 1
                          ? 'Solo practice mode'
                          : 'Ready for $_playerCount players',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Player names', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            for (int index = 0; index < _playerCount; index++) ...[
              TextField(
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
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _startMatch,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
