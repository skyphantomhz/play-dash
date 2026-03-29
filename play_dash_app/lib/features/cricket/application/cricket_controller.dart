import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_settings.dart';
import '../../../shared/models/match_state.dart';
import '../../../shared/models/player.dart';
import '../domain/cricket_engine.dart';

final cricketControllerProvider =
    NotifierProvider<CricketController, CricketMatchState>(
        CricketController.new);

final cricketCanUndoProvider = Provider<bool>((ref) {
  ref.watch(cricketControllerProvider);
  return ref.read(cricketControllerProvider.notifier).canUndo;
});

class CricketController extends Notifier<CricketMatchState> {
  static const List<int> _segments = <int>[15, 16, 17, 18, 19, 20, 25];
  final List<CricketMatchState> _history = <CricketMatchState>[];
  final List<List<DartThrow>> _turnSnapshots = <List<DartThrow>>[];
  final List<List<DartThrow>> _historySnapshots = <List<DartThrow>>[];
  List<DartThrow> _throwHistory = <DartThrow>[];
  List<DartThrow> _currentTurnThrows = <DartThrow>[];

  bool get canUndo => _history.isNotEmpty;
  List<DartThrow> get throwHistory => List.unmodifiable(_throwHistory);
  List<DartThrow> get currentTurnThrows => List.unmodifiable(_currentTurnThrows);

  @override
  CricketMatchState build() {
    const CricketMatchSettings settings = CricketMatchSettings();
    final players = <Player>[
      const Player(id: 'player-1', name: 'Player 1'),
      const Player(id: 'player-2', name: 'Player 2'),
    ];
    _throwHistory = <DartThrow>[];
    _currentTurnThrows = <DartThrow>[];

    return CricketMatchState(
      players: players,
      settings: settings,
      game: CricketGameState(
        marks: {
          for (final player in players) player.id: _emptyMarks(),
        },
        scores: {
          for (final player in players) player.id: 0,
        },
      ),
    );
  }

  void startMatch({
    required List<Player> players,
    int startingPlayerIndex = 0,
    CricketMatchSettings settings = const CricketMatchSettings(),
  }) {
    _history.clear();
    _turnSnapshots.clear();
    _historySnapshots.clear();
    _throwHistory = <DartThrow>[];
    _currentTurnThrows = <DartThrow>[];
    final initialPlayerIndex = players.isEmpty
        ? 0
        : startingPlayerIndex.clamp(0, players.length - 1).toInt();
    state = CricketMatchState(
      currentPlayerIndex: initialPlayerIndex,
      players: players,
      settings: settings,
      game: CricketGameState(
        marks: {
          for (final player in players) player.id: _emptyMarks(),
        },
        scores: {
          for (final player in players) player.id: 0,
        },
      ),
    );
  }

  void addThrow(DartThrow dartThrow) {
    if (state.players.isEmpty || state.game.winnerPlayerId != null) {
      return;
    }

    final previousState = state;
    final currentPlayer = state.players[state.currentPlayerIndex];
    final currentMarks =
        Map<int, int>.from(state.game.marks[currentPlayer.id] ?? _emptyMarks());
    final currentScore = state.game.scores[currentPlayer.id] ?? 0;
    final settings = state.settings as CricketMatchSettings;

    final throwResult = CricketEngine.applyThrow(
      currentMarks: currentMarks,
      dartThrow: dartThrow,
      scoreOverflow: !settings.cutThroat,
    );

    final updatedMarks = Map<String, Map<int, int>>.from(state.game.marks)
      ..[currentPlayer.id] = Map.unmodifiable(throwResult.updatedMarks);
    final updatedScores = Map<String, int>.from(state.game.scores)
      ..[currentPlayer.id] = currentScore + throwResult.scoreAdded;
    final updatedCurrentTurnThrows = [..._currentTurnThrows, dartThrow];

    final winnerId = _resolveWinner(updatedMarks, updatedScores);
    final shouldAdvanceTurn =
        winnerId != null || updatedCurrentTurnThrows.length >= 3;

    _history.add(previousState);
    _turnSnapshots.add(List<DartThrow>.from(_currentTurnThrows));
    _historySnapshots.add(List<DartThrow>.from(_throwHistory));
    _throwHistory = [..._throwHistory, dartThrow];
    _currentTurnThrows = shouldAdvanceTurn ? <DartThrow>[] : updatedCurrentTurnThrows;

    state = state.copyWith(
      currentPlayerIndex: shouldAdvanceTurn
          ? _nextPlayerIndex(state.currentPlayerIndex, state.players.length)
          : state.currentPlayerIndex,
      game: state.game.copyWith(
        marks: Map.unmodifiable(updatedMarks),
        scores: Map.unmodifiable(updatedScores),
        winnerPlayerId: winnerId,
      ),
    );
  }

  void resetCurrentTurn() {
    if (_currentTurnThrows.isEmpty || state.game.winnerPlayerId != null) {
      return;
    }

    _history.add(state);
    _turnSnapshots.add(List<DartThrow>.from(_currentTurnThrows));
    _historySnapshots.add(List<DartThrow>.from(_throwHistory));
    _currentTurnThrows = <DartThrow>[];
    state = state.copyWith(
      currentPlayerIndex:
          _nextPlayerIndex(state.currentPlayerIndex, state.players.length),
    );
  }

  void undo() {
    if (_history.isEmpty) {
      return;
    }

    state = _history.removeLast();
    _currentTurnThrows = _turnSnapshots.removeLast();
    _throwHistory = _historySnapshots.removeLast();
    state = state.copyWith(currentPlayerIndex: state.currentPlayerIndex);
  }

  Map<int, int> _emptyMarks() => {
        for (final segment in _segments) segment: 0,
      };

  String? _resolveWinner(
    Map<String, Map<int, int>> marks,
    Map<String, int> scores,
  ) {
    final closedPlayers = state.players.where((player) {
      final playerMarks = marks[player.id] ?? const <int, int>{};
      return _segments.every((segment) => (playerMarks[segment] ?? 0) >= 3);
    }).toList();

    if (closedPlayers.isEmpty) {
      return null;
    }

    closedPlayers
        .sort((a, b) => (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0));
    return closedPlayers.first.id;
  }

  int _nextPlayerIndex(int currentIndex, int playerCount) {
    if (playerCount <= 1) {
      return 0;
    }

    return (currentIndex + 1) % playerCount;
  }
}
