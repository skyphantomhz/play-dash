import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_settings.dart';
import '../../../shared/models/match_state.dart';
import '../../../shared/models/player.dart';
import '../domain/x01_engine.dart';

final x01ControllerProvider =
    NotifierProvider<X01Controller, X01MatchState>(X01Controller.new);

final x01CanUndoProvider = Provider<bool>((ref) {
  ref.watch(x01ControllerProvider);
  return ref.read(x01ControllerProvider.notifier).canUndo;
});

class X01Controller extends Notifier<X01MatchState> {
  final List<X01MatchState> _history = <X01MatchState>[];
  final List<List<DartThrow>> _turnSnapshots = <List<DartThrow>>[];
  final List<List<DartThrow>> _historySnapshots = <List<DartThrow>>[];
  List<DartThrow> _throwHistory = <DartThrow>[];

  bool get canUndo => _history.isNotEmpty;
  List<DartThrow> get throwHistory => List.unmodifiable(_throwHistory);

  @override
  X01MatchState build() {
    const X01MatchSettings settings = X01MatchSettings();
    final players = <Player>[
      const Player(id: 'player-1', name: 'Player 1'),
      const Player(id: 'player-2', name: 'Player 2'),
    ];
    _throwHistory = <DartThrow>[];
    return X01MatchState(
      players: players,
      settings: settings,
      game: X01GameState(
        scores: {
          for (final player in players) player.id: settings.startingScore,
        },
      ),
    );
  }

  void startMatch({
    required List<Player> players,
    X01MatchSettings settings = const X01MatchSettings(),
  }) {
    _history.clear();
    _turnSnapshots.clear();
    _historySnapshots.clear();
    _throwHistory = <DartThrow>[];
    state = X01MatchState(
      players: players,
      settings: settings,
      game: X01GameState(
        scores: {
          for (final player in players) player.id: settings.startingScore,
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
    final settings = state.settings as X01MatchSettings;
    final currentScore =
        state.game.scores[currentPlayer.id] ?? settings.startingScore;
    final updatedThrows = [...state.game.currentTurnThrows, dartThrow];

    final turnResult = X01Engine.applyTurn(
      currentScore: currentScore,
      throws: updatedThrows,
      settings: settings,
    );

    final updatedScores = Map<String, int>.from(state.game.scores)
      ..[currentPlayer.id] = turnResult.endingScore;

    final didUseAllDarts = updatedThrows.length >= 3;
    final shouldAdvanceTurn =
        turnResult.bust || turnResult.finished || didUseAllDarts;
    final shouldMoveToNextPlayer = turnResult.bust || didUseAllDarts;

    _history.add(previousState);
    _turnSnapshots.add(List<DartThrow>.from(previousState.game.currentTurnThrows));
    _historySnapshots.add(List<DartThrow>.from(_throwHistory));
    _throwHistory = [..._throwHistory, dartThrow];

    state = state.copyWith(
      currentPlayerIndex: shouldMoveToNextPlayer
          ? _nextPlayerIndex(state.currentPlayerIndex, state.players.length)
          : state.currentPlayerIndex,
      game: state.game.copyWith(
        scores: Map.unmodifiable(updatedScores),
        currentTurnThrows: shouldAdvanceTurn
            ? const <DartThrow>[]
            : List.unmodifiable(updatedThrows),
        winnerPlayerId:
            turnResult.finished ? currentPlayer.id : state.game.winnerPlayerId,
      ),
    );
  }

  void undo() {
    if (_history.isEmpty) {
      return;
    }

    state = _history.removeLast();
    final previousTurn = _turnSnapshots.removeLast();
    final previousHistory = _historySnapshots.removeLast();
    _throwHistory = List<DartThrow>.from(previousHistory);
    state = state.copyWith(
      game: state.game.copyWith(
        currentTurnThrows: List.unmodifiable(previousTurn),
      ),
    );
  }

  void resetCurrentTurn() {
    if (state.game.currentTurnThrows.isEmpty || state.game.winnerPlayerId != null) {
      return;
    }

    _history.add(state);
    _turnSnapshots.add(List<DartThrow>.from(state.game.currentTurnThrows));
    _historySnapshots.add(List<DartThrow>.from(_throwHistory));
    state = state.copyWith(
      currentPlayerIndex:
          _nextPlayerIndex(state.currentPlayerIndex, state.players.length),
      game: state.game.copyWith(
        currentTurnThrows: const <DartThrow>[],
      ),
    );
  }

  int _nextPlayerIndex(int currentIndex, int playerCount) {
    if (playerCount <= 1) {
      return 0;
    }

    return (currentIndex + 1) % playerCount;
  }
}
