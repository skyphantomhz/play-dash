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

  int _playerCount = 4;
  bool _showMatchScreen = false;
  late final List<TextEditingController> _nameControllers = List.generate(
    _maxPlayers,
    (index) => TextEditingController(
      text: ['Mike Johnson', 'Dipti Williams', 'Camme Davis', 'Sarah Williams', 'Leo', 'Noah', 'Ava', 'Luca'][index],
    ),
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
      return Player(id: 'player-${index + 1}', name: value.isEmpty ? 'Player ${index + 1}' : value);
    });
    ref.read(x01ControllerProvider.notifier).startMatch(players: players);
    setState(() => _showMatchScreen = true);
    try {
      context.go('/match/x01');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_showMatchScreen) return const X01GamePage();

    final preview = List<String>.generate(_playerCount, (index) {
      final value = _nameControllers[index].text.trim();
      return value.isEmpty ? 'Player ${index + 1}' : value;
    });

    return AppShell(
      expandChild: true,
      mobileTopTabs: const [
        ShellTab(label: 'Home', route: '/'),
        ShellTab(label: 'Setup', route: '/setup'),
        ShellTab(label: 'Game', route: '/match/x01'),
        ShellTab(label: 'Stats', route: '/leaderboard'),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth >= 1180;
          return desktop
              ? Row(
                  children: [
                    Expanded(
                      flex: 38,
                      child: _SetupConfiguration(
                        playerCount: _playerCount,
                        minPlayers: _minPlayers,
                        maxPlayers: _maxPlayers,
                        nameControllers: _nameControllers,
                        onPlayerCountChanged: (value) => setState(() => _playerCount = value.round()),
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(flex: 26, child: _SetupRoster(preview: preview)),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 24,
                      child: _SetupActions(playerCount: _playerCount, onStart: _startMatch),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _MobileSetupScore(preview: preview),
                    const SizedBox(height: 12),
                    _SetupConfiguration(
                      playerCount: _playerCount,
                      minPlayers: _minPlayers,
                      maxPlayers: _maxPlayers,
                      nameControllers: _nameControllers,
                      onPlayerCountChanged: (value) => setState(() => _playerCount = value.round()),
                      onChanged: () => setState(() {}),
                      compact: true,
                    ),
                    const SizedBox(height: 12),
                    _SetupActions(playerCount: _playerCount, onStart: _startMatch, compact: true),
                  ],
                );
        },
      ),
    );
  }
}

class _SetupConfiguration extends StatelessWidget {
  const _SetupConfiguration({
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
      accent: const Color(0xFF2DB6FF),
      secondaryAccent: const Color(0xFF6E49FF),
      radius: compact ? 20 : 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            title: 'Setup Game',
            subtitle: compact ? 'Stay / Header / Single re-entry' : 'Select mode, roster, and scoring before launch.',
            trailing: ScoreBadge(value: '$playerCount Players', highlight: true),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(child: _SegmentToggle(label: 'Global', active: true)),
              SizedBox(width: 8),
              Expanded(child: _SegmentToggle(label: 'Friends')),
              SizedBox(width: 8),
              Expanded(child: _SegmentToggle(label: 'This Month')),
            ],
          ),
          const SizedBox(height: 14),
          Slider(
            value: playerCount.toDouble(),
            min: minPlayers.toDouble(),
            max: maxPlayers.toDouble(),
            divisions: maxPlayers - minPlayers,
            onChanged: onPlayerCountChanged,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              MetricCard(label: 'Mode', value: 'X01', icon: Icons.sports_score_rounded, highlight: true),
              MetricCard(label: 'Target', value: '301 / 501', icon: Icons.flag_rounded),
              MetricCard(label: 'Checkout', value: 'Single Out', icon: Icons.adjust_rounded),
            ],
          ),
          const SizedBox(height: 16),
          for (int index = 0; index < playerCount; index++) ...[
            FrostPanel(
              radius: 18,
              backgroundOpacity: 0.12,
              borderOpacity: 0.16,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: TextField(
                controller: nameControllers[index],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                onChanged: (_) => onChanged(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Player ${index + 1}',
                  labelStyle: const TextStyle(color: Color(0xB3E8EDFF)),
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: Colors.white70),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _SetupRoster extends StatelessWidget {
  const _SetupRoster({required this.preview});

  final List<String> preview;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFFFF4BDD),
      secondaryAccent: const Color(0xFF6E49FF),
      child: Column(
        children: [
          const SectionHeading(title: 'Best Order', subtitle: 'Drag-free stacked roster with bright score chips.'),
          const SizedBox(height: 14),
          for (int index = 0; index < preview.length; index++) ...[
            PanelListTile(
              title: preview[index],
              subtitle: index == 0 ? '00' : index == 1 ? '40' : '00',
              leading: PlayerAvatar(
                name: preview[index],
                colors: [index.isEven ? const Color(0xFF2DB6FF) : const Color(0xFFFF5A87), const Color(0xFF6E49FF)],
              ),
              trailing: ScoreBadge(value: index == 0 ? '80' : index == 1 ? '40' : '00', highlight: index == 1),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _SetupActions extends StatelessWidget {
  const _SetupActions({required this.playerCount, required this.onStart, this.compact = false});

  final int playerCount;
  final VoidCallback onStart;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      accent: const Color(0xFFFF4BDD),
      secondaryAccent: const Color(0xFF2DB6FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(title: 'Game Settings', subtitle: 'Mirror the mobile setup panel shown in the reference.'),
          const SizedBox(height: 14),
          const _DropdownLine(title: 'Stay Game', value: 'X01'),
          const SizedBox(height: 10),
          const _DropdownLine(title: 'Start Order', value: 'Mike Johnson'),
          const SizedBox(height: 10),
          const _DropdownLine(title: 'Scoring', value: 'Single Out'),
          const SizedBox(height: 10),
          const _DropdownLine(title: 'Round Count', value: 'Best of 5'),
          const SizedBox(height: 10),
          _DropdownLine(title: 'Roster', value: '$playerCount Players'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: GlassButton(
              label: 'Start Game',
              icon: Icons.play_arrow_rounded,
              onPressed: onStart,
              highlight: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileSetupScore extends StatelessWidget {
  const _MobileSetupScore({required this.preview});

  final List<String> preview;

  @override
  Widget build(BuildContext context) {
    return const NeonCard(
      accent: Color(0xFFFF4BDD),
      secondaryAccent: Color(0xFF6E49FF),
      child: Column(
        children: [
          Row(
            children: [
              PlayerAvatar(name: 'Sarah', colors: [Color(0xFFFF5A87), Color(0xFF6E49FF)]),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Setup Game', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                    Text('Warm Corness  ·  24/10  ·  Deym', style: TextStyle(color: Color(0xB3E8EDFF), fontSize: 11.5)),
                  ],
                ),
              ),
              ScoreBadge(value: '301', highlight: true, large: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _DropdownLine extends StatelessWidget {
  const _DropdownLine({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: 16,
      backgroundOpacity: 0.12,
      borderOpacity: 0.16,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
          Text(value, style: const TextStyle(color: Color(0xFF7FE5FF), fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          const Icon(Icons.expand_more_rounded, color: Colors.white70, size: 18),
        ],
      ),
    );
  }
}

class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: active ? const LinearGradient(colors: [Color(0xFF2DB6FF), Color(0xFF6E49FF)]) : null,
        color: active ? null : Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}
