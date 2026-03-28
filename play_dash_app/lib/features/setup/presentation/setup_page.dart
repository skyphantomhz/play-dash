import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_shell.dart';

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

  int _playerCount = 4;
  late final List<TextEditingController> _nameControllers = List.generate(
    _maxPlayers,
    (index) => TextEditingController(
        text: [
      'Mike Johnson',
      'Dipti Williams',
      'Camme Davis',
      'Sarah Williams',
      'Leo',
      'Noah',
      'Ava',
      'Luca'
    ][index]),
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
    try {
      context.go('/match/x01');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final preview = List<String>.generate(_playerCount, (index) {
      final value = _nameControllers[index].text.trim();
      return value.isEmpty ? 'Player ${index + 1}' : value;
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1180;
        return desktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 30,
                    child: _SetupHero(playerName: preview.last),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 38,
                    child: _SetupConfig(
                      playerCount: _playerCount,
                      minPlayers: _minPlayers,
                      maxPlayers: _maxPlayers,
                      nameControllers: _nameControllers,
                      onPlayerCountChanged: (value) =>
                          setState(() => _playerCount = value.round()),
                      onChanged: () => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 28,
                    child: _SetupSideRail(
                      preview: preview,
                      playerCount: _playerCount,
                      onStart: _startMatch,
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SetupHero(playerName: preview.last, compact: true),
                    const SizedBox(height: 12),
                    _SetupConfig(
                      playerCount: _playerCount,
                      minPlayers: _minPlayers,
                      maxPlayers: _maxPlayers,
                      nameControllers: _nameControllers,
                      onPlayerCountChanged: (value) =>
                          setState(() => _playerCount = value.round()),
                      onChanged: () => setState(() {}),
                      compact: true,
                    ),
                    const SizedBox(height: 12),
                    _SetupSideRail(
                      preview: preview,
                      playerCount: _playerCount,
                      onStart: _startMatch,
                      compact: true,
                    ),
                  ],
                ),
              );
      },
    );
  }
}

class _SetupHero extends StatelessWidget {
  const _SetupHero({required this.playerName, this.compact = false});

  final String playerName;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFFFF4FD8),
      secondaryAccent: const Color(0xFF8B5CF6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PlayerAvatar(
                  name: 'Sarah',
                  colors: [Color(0xFFFF4FD8), Color(0xFF8B5CF6)]),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Setup Game',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: compact ? 18 : 20)),
                    const SizedBox(height: 4),
                    Text('$playerName  ·  24/10  ·  Days',
                        style: const TextStyle(
                            color: Color(0xB3FFFFFF), fontSize: 11.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('301',
              style: TextStyle(
                  color: const Color(0xFFBDF5FF),
                  fontSize: compact ? 56 : 68,
                  fontWeight: FontWeight.w900,
                  height: 0.95)),
          const SizedBox(height: 8),
          const Text('S.01  |  Score 5',
              style: TextStyle(
                  color: Color(0xB3FFFFFF), fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: _SetupTab(label: 'Global', active: true)),
              SizedBox(width: 8),
              Expanded(child: _SetupTab(label: 'Friends')),
              SizedBox(width: 8),
              Expanded(child: _SetupTab(label: 'This Month')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SetupConfig extends StatelessWidget {
  const _SetupConfig({
    required this.playerCount,
    required this.minPlayers,
    required this.maxPlayers,
    required this.nameControllers,
    required this.onPlayerCountChanged,
    required this.onChanged,
    this.compact = false,
  });

  final int playerCount;
  final int minPlayers;
  final int maxPlayers;
  final List<TextEditingController> nameControllers;
  final ValueChanged<double> onPlayerCountChanged;
  final VoidCallback onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFF37D8FF),
      secondaryAccent: const Color(0xFF8B5CF6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
              title: 'Setup Game',
              subtitle:
                  'Glass inputs, cyan focus, and stacked controls to match the mobile setup panel.',
              trailing:
                  ScoreBadge(value: '$playerCount Players', highlight: true)),
          const SizedBox(height: 16),
          Slider(
              value: playerCount.toDouble(),
              min: minPlayers.toDouble(),
              max: maxPlayers.toDouble(),
              divisions: maxPlayers - minPlayers,
              onChanged: onPlayerCountChanged),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              MetricCard(
                  label: 'Mode',
                  value: 'X01',
                  icon: Icons.sports_score_rounded,
                  highlight: true),
              MetricCard(
                  label: 'Target',
                  value: '301 / 501',
                  icon: Icons.flag_rounded),
              MetricCard(
                  label: 'Checkout',
                  value: 'Single Out',
                  icon: Icons.adjust_rounded),
            ],
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < playerCount; i++) ...[
            TextField(
              controller: nameControllers[i],
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                  labelText: 'Player ${i + 1}',
                  prefixIcon: const Icon(Icons.person_outline_rounded)),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _SetupSideRail extends StatelessWidget {
  const _SetupSideRail(
      {required this.preview,
      required this.playerCount,
      required this.onStart,
      this.compact = false});

  final List<String> preview;
  final int playerCount;
  final VoidCallback onStart;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NeonCard(
          accent: const Color(0xFFFF4FD8),
          secondaryAccent: const Color(0xFF8B5CF6),
          child: Column(
            children: [
              const SectionHeading(
                  title: 'Best Order',
                  subtitle:
                      'Shortlist the roster with bright chips and compact player rows.'),
              const SizedBox(height: 14),
              for (final entry in preview.asMap().entries) ...[
                PanelListTile(
                  title: entry.value,
                  subtitle: entry.key == 0
                      ? '80'
                      : entry.key == 1
                          ? '40'
                          : '00',
                  leading: PlayerAvatar(
                      name: entry.value,
                      colors: [
                        entry.key.isEven
                            ? const Color(0xFF37D8FF)
                            : const Color(0xFFFF4FD8),
                        const Color(0xFF8B5CF6)
                      ],
                      radius: 18),
                  trailing: ScoreBadge(
                      value: entry.key == 0
                          ? '80'
                          : entry.key == 1
                              ? '40'
                              : '00',
                      highlight: entry.key == 1),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        NeonCard(
          accent: const Color(0xFFFF4FD8),
          secondaryAccent: const Color(0xFF37D8FF),
          child: Column(
            children: [
              const _DropdownLine(title: 'Stay Game', value: 'X01'),
              const SizedBox(height: 10),
              const _DropdownLine(title: 'Start Order', value: 'Mike Johnson'),
              const SizedBox(height: 10),
              const _DropdownLine(title: 'Scoring', value: 'Single Out'),
              const SizedBox(height: 10),
              const _DropdownLine(title: 'Best Games', value: 'Best 7 legs'),
              const SizedBox(height: 10),
              _DropdownLine(
                  title: 'Speaker & Scoreboard', value: '$playerCount Players'),
              const SizedBox(height: 18),
              SizedBox(
                  width: double.infinity,
                  child: GlassButton(
                      label: 'Start Game',
                      icon: Icons.play_arrow_rounded,
                      highlight: true,
                      onPressed: onStart)),
            ],
          ),
        ),
      ],
    );
  }
}

class _DropdownLine extends StatelessWidget {
  const _DropdownLine({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 16,
      blur: 18,
      background: Colors.white.withValues(alpha: 0.05),
      borderColor: Colors.white.withValues(alpha: 0.10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700))),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF9FEFFF), fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          const Icon(Icons.expand_more_rounded,
              color: Colors.white70, size: 18),
        ],
      ),
    );
  }
}

class _SetupTab extends StatelessWidget {
  const _SetupTab({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: active
            ? const LinearGradient(
                colors: [Color(0xFF37D8FF), Color(0xFF4DA3FF)])
            : null,
        color: active ? null : Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}
