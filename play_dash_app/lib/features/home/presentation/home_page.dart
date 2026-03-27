import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Dash'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Choose a game mode',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.go('/setup'),
                    icon: const Icon(Icons.groups_2_outlined),
                    label: const Text('Player Setup'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.go('/match/x01'),
                    icon: const Icon(Icons.sports_score_outlined),
                    label: const Text('Play X01'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () => context.go('/match/cricket'),
                    icon: const Icon(Icons.track_changes_outlined),
                    label: const Text('Play Cricket'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/leaderboard'),
                    icon: const Icon(Icons.emoji_events_outlined),
                    label: const Text('Leaderboard'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
