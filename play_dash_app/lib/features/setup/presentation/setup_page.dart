import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/match_settings.dart';
import '../../../shared/models/player.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../cricket/application/cricket_controller.dart';
import '../../x01/application/x01_controller.dart';

enum SetupGameMode { x01, cricket }

enum SetupCheckoutMode { singleOut, doubleOut }

final setupGameModeProvider =
    NotifierProvider<SetupGameModeNotifier, SetupGameMode>(
      SetupGameModeNotifier.new,
    );
final setupStartingScoreProvider =
    NotifierProvider<SetupStartingScoreNotifier, int>(
      SetupStartingScoreNotifier.new,
    );
final setupCheckoutModeProvider =
    NotifierProvider<SetupCheckoutModeNotifier, SetupCheckoutMode>(
      SetupCheckoutModeNotifier.new,
    );

class SetupGameModeNotifier extends Notifier<SetupGameMode> {
  @override
  SetupGameMode build() => SetupGameMode.x01;

  void setMode(SetupGameMode mode) {
    state = mode;
  }
}

class SetupStartingScoreNotifier extends Notifier<int> {
  @override
  int build() => 301;

  void setStartingScore(int score) {
    state = score;
  }
}

class SetupCheckoutModeNotifier extends Notifier<SetupCheckoutMode> {
  @override
  SetupCheckoutMode build() => SetupCheckoutMode.doubleOut;

  void setCheckoutMode(SetupCheckoutMode mode) {
    state = mode;
  }
}

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
      ][index],
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
    final mode = ref.read(setupGameModeProvider);
    final startingScore = ref.read(setupStartingScoreProvider);
    final checkout = ref.read(setupCheckoutModeProvider);

    final players = List<Player>.generate(_playerCount, (index) {
      final value = _nameControllers[index].text.trim();
      return Player(
        id: 'player-${index + 1}',
        name: value.isEmpty ? 'Player ${index + 1}' : value,
      );
    });

    if (mode == SetupGameMode.x01) {
      ref.read(x01ControllerProvider.notifier).startMatch(
            players: players,
            settings: X01MatchSettings(
              startingScore: startingScore,
              doubleOut: checkout == SetupCheckoutMode.doubleOut,
            ),
          );
      context.go('/match/x01');
      return;
    }

    ref.read(cricketControllerProvider.notifier).startMatch(players: players);
    context.go('/match/cricket');
  }

  @override
  Widget build(BuildContext context) {
    final preview = List<String>.generate(_playerCount, (index) {
      final value = _nameControllers[index].text.trim();
      return value.isEmpty ? 'Player ${index + 1}' : value;
    });
    final mode = ref.watch(setupGameModeProvider);
    final startingScore = ref.watch(setupStartingScoreProvider);
    final checkout = ref.watch(setupCheckoutModeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1180;
        final content = desktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 30,
                    child: _SetupHero(
                      playerName: preview.last,
                      playerCount: _playerCount,
                      mode: mode,
                      startingScore: startingScore,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 38,
                    child: _SetupConfig(
                      playerCount: _playerCount,
                      minPlayers: _minPlayers,
                      maxPlayers: _maxPlayers,
                      mode: mode,
                      startingScore: startingScore,
                      checkout: checkout,
                      nameControllers: _nameControllers,
                      onPlayerCountChanged: (value) =>
                          setState(() => _playerCount = value.round()),
                      onChanged: () => setState(() {}),
                      onModeChanged: (value) => ref
                          .read(setupGameModeProvider.notifier)
                          .setMode(value),
                      onStartingScoreChanged: (value) => ref
                          .read(setupStartingScoreProvider.notifier)
                          .setStartingScore(value),
                      onCheckoutChanged: (value) => ref
                          .read(setupCheckoutModeProvider.notifier)
                          .setCheckoutMode(value),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 28,
                    child: _SetupSideRail(
                      preview: preview,
                      playerCount: _playerCount,
                      mode: mode,
                      startingScore: startingScore,
                      checkout: checkout,
                      onStart: _startMatch,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SetupHero(
                    playerName: preview.last,
                    playerCount: _playerCount,
                    mode: mode,
                    startingScore: startingScore,
                    compact: true,
                  ),
                  const SizedBox(height: 12),
                  _SetupConfig(
                    playerCount: _playerCount,
                    minPlayers: _minPlayers,
                    maxPlayers: _maxPlayers,
                    mode: mode,
                    startingScore: startingScore,
                    checkout: checkout,
                    nameControllers: _nameControllers,
                    onPlayerCountChanged: (value) =>
                        setState(() => _playerCount = value.round()),
                    onChanged: () => setState(() {}),
                    onModeChanged: (value) => ref
                        .read(setupGameModeProvider.notifier)
                        .setMode(value),
                    onStartingScoreChanged: (value) => ref
                        .read(setupStartingScoreProvider.notifier)
                        .setStartingScore(value),
                    onCheckoutChanged: (value) => ref
                        .read(setupCheckoutModeProvider.notifier)
                        .setCheckoutMode(value),
                    compact: true,
                  ),
                  const SizedBox(height: 12),
                  _SetupSideRail(
                    preview: preview,
                    playerCount: _playerCount,
                    mode: mode,
                    startingScore: startingScore,
                    checkout: checkout,
                    onStart: _startMatch,
                    compact: true,
                  ),
                ],
              );

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 8),
          child: content,
        );
      },
    );
  }
}

class _SetupHero extends StatelessWidget {
  const _SetupHero({
    required this.playerName,
    required this.playerCount,
    required this.mode,
    required this.startingScore,
    this.compact = false,
  });

  final String playerName;
  final int playerCount;
  final SetupGameMode mode;
  final int startingScore;
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
              PlayerAvatar(
                name: playerName,
                colors: const [Color(0xFFFF4FD8), Color(0xFF8B5CF6)],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Setup Game',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: compact ? 18 : 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$playerName  ·  $playerCount players  ·  ${mode.label}',
                      style: const TextStyle(
                        color: Color(0xB3FFFFFF),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            mode == SetupGameMode.x01 ? '$startingScore' : 'CRICKET',
            style: TextStyle(
              color: const Color(0xFFBDF5FF),
              fontSize: compact ? 56 : 68,
              fontWeight: FontWeight.w900,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mode == SetupGameMode.x01
                ? '${mode.label}  |  $playerCount players'
                : 'Classic Cricket  |  $playerCount players',
            style: const TextStyle(
              color: Color(0xB3FFFFFF),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SetupTab(label: mode.label, active: true),
              _SetupTab(label: '$playerCount Players'),
              _SetupTab(label: playerName),
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
    required this.mode,
    required this.startingScore,
    required this.checkout,
    required this.nameControllers,
    required this.onPlayerCountChanged,
    required this.onChanged,
    required this.onModeChanged,
    required this.onStartingScoreChanged,
    required this.onCheckoutChanged,
    this.compact = false,
  });

  final int playerCount;
  final int minPlayers;
  final int maxPlayers;
  final SetupGameMode mode;
  final int startingScore;
  final SetupCheckoutMode checkout;
  final List<TextEditingController> nameControllers;
  final ValueChanged<double> onPlayerCountChanged;
  final VoidCallback onChanged;
  final ValueChanged<SetupGameMode> onModeChanged;
  final ValueChanged<int> onStartingScoreChanged;
  final ValueChanged<SetupCheckoutMode> onCheckoutChanged;
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
            subtitle: 'Configure the mode, target, checkout, and player roster.',
            trailing: ScoreBadge(value: '$playerCount Players', highlight: true),
          ),
          const SizedBox(height: 16),
          Slider(
            value: playerCount.toDouble(),
            min: minPlayers.toDouble(),
            max: maxPlayers.toDouble(),
            divisions: maxPlayers - minPlayers,
            label: '$playerCount',
            onChanged: onPlayerCountChanged,
          ),
          const SizedBox(height: 10),
          _SelectionCard(
            label: 'Mode',
            icon: Icons.sports_score_rounded,
            child: SegmentedButton<SetupGameMode>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: SetupGameMode.x01, label: Text('X01')),
                ButtonSegment(value: SetupGameMode.cricket, label: Text('Cricket')),
              ],
              selected: {mode},
              onSelectionChanged: (values) => onModeChanged(values.first),
            ),
          ),
          const SizedBox(height: 12),
          if (mode == SetupGameMode.x01) ...[
            _SelectionCard(
              label: 'Target',
              icon: Icons.flag_rounded,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [301, 501, 701]
                    .map(
                      (value) => ChoiceChip(
                        label: Text('$value'),
                        selected: startingScore == value,
                        onSelected: (_) => onStartingScoreChanged(value),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            _SelectionCard(
              label: 'Checkout',
              icon: Icons.adjust_rounded,
              child: SegmentedButton<SetupCheckoutMode>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: SetupCheckoutMode.singleOut,
                    label: Text('Single Out'),
                  ),
                  ButtonSegment(
                    value: SetupCheckoutMode.doubleOut,
                    label: Text('Double Out'),
                  ),
                ],
                selected: {checkout},
                onSelectionChanged: (values) => onCheckoutChanged(values.first),
              ),
            ),
            const SizedBox(height: 12),
          ] else ...[
            const Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                MetricCard(
                  label: 'Mode',
                  value: 'Cricket',
                  icon: Icons.sports_martial_arts_rounded,
                  highlight: true,
                ),
                MetricCard(
                  label: 'Marks',
                  value: '15-20 + Bull',
                  icon: Icons.filter_alt_rounded,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          for (int i = 0; i < playerCount; i++) ...[
            TextField(
              controller: nameControllers[i],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                labelText: 'Player ${i + 1}',
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _SetupSideRail extends StatelessWidget {
  const _SetupSideRail({
    required this.preview,
    required this.playerCount,
    required this.mode,
    required this.startingScore,
    required this.checkout,
    required this.onStart,
    this.compact = false,
  });

  final List<String> preview;
  final int playerCount;
  final SetupGameMode mode;
  final int startingScore;
  final SetupCheckoutMode checkout;
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
                title: 'Player Preview',
                subtitle: 'Live roster preview mirrors slider and text input changes.',
              ),
              const SizedBox(height: 14),
              for (final entry in preview.asMap().entries) ...[
                PanelListTile(
                  title: entry.value,
                  subtitle: entry.key == 0 ? 'Starts first' : 'Player ${entry.key + 1}',
                  leading: PlayerAvatar(
                    name: entry.value,
                    colors: [
                      entry.key.isEven
                          ? const Color(0xFF37D8FF)
                          : const Color(0xFFFF4FD8),
                      const Color(0xFF8B5CF6),
                    ],
                    radius: 18,
                  ),
                  trailing: ScoreBadge(
                    value: '#${entry.key + 1}',
                    highlight: entry.key == 0,
                  ),
                  highlight: entry.key == 0,
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        GlassPanel(
          radius: 20,
          blur: 22,
          background: Colors.white.withValues(alpha: 0.06),
          borderColor: Colors.white.withValues(alpha: 0.12),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _DropdownLine(title: 'Game Mode', value: mode.label),
              const SizedBox(height: 10),
              _DropdownLine(
                title: 'Target',
                value: mode == SetupGameMode.x01 ? '$startingScore' : '15-20 + Bull',
              ),
              const SizedBox(height: 10),
              _DropdownLine(
                title: 'Checkout',
                value: mode == SetupGameMode.x01 ? checkout.label : 'Marks Win',
              ),
              const SizedBox(height: 10),
              _DropdownLine(title: 'Start Order', value: preview.first),
              const SizedBox(height: 10),
              _DropdownLine(
                title: 'Speaker & Scoreboard',
                value: '$playerCount Players',
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: GlassButton(
                  label: 'Start Game',
                  icon: Icons.play_arrow_rounded,
                  highlight: true,
                  onPressed: onStart,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectionCard extends StatelessWidget {
  const _SelectionCard({
    required this.label,
    required this.icon,
    required this.child,
  });

  final String label;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: 18,
      blur: 18,
      background: Colors.white.withValues(alpha: 0.05),
      borderColor: Colors.white.withValues(alpha: 0.08),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF9FEFFF), size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF9FEFFF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

extension on SetupGameMode {
  String get label => this == SetupGameMode.x01 ? 'X01' : 'Cricket';
}

extension on SetupCheckoutMode {
  String get label => this == SetupCheckoutMode.singleOut
      ? 'Single Out'
      : 'Double Out';
}
