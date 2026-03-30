import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/history_providers.dart';
import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_record.dart';
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
    int startingPlayerIndex = 0,
    X01MatchSettings settings = const X01MatchSettings(),
  }) {
    _history.clear();
    _turnSnapshots.clear();
    _historySnapshots.clear();
    _throwHistory = <DartThrow>[];
    final initialPlayerIndex = players.isEmpty
        ? 0
        : startingPlayerIndex.clamp(0, players.length - 1).toInt();
    state = X01MatchState(
      currentPlayerIndex: initialPlayerIndex,
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
    _turnSnapshots
        .add(List<DartThrow>.from(previousState.game.currentTurnThrows));
    _historySnapshots.add(List<DartThrow>.from(_throwHistory));
    _throwHistory = [..._throwHistory, dartThrow];

    final winnerId =
        turnResult.finished ? currentPlayer.id : state.game.winnerPlayerId;

    state = state.copyWith(
      currentPlayerIndex: shouldMoveToNextPlayer
          ? _nextPlayerIndex(state.currentPlayerIndex, state.players.length)
          : state.currentPlayerIndex,
      game: state.game.copyWith(
        scores: Map.unmodifiable(updatedScores),
        currentTurnThrows: shouldAdvanceTurn
            ? const <DartThrow>[]
            : List.unmodifiable(updatedThrows),
        winnerPlayerId: winnerId,
      ),
    );

    // Persist to history when a winner is determined.
    if (winnerId != null && state.game.winnerPlayerId == winnerId) {
      _saveMatchRecord(
        players: state.players,
        scores: updatedScores,
        winnerId: winnerId,
        settings: settings,
      );
    }
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
    if (state.game.currentTurnThrows.isEmpty ||
        state.game.winnerPlayerId != null) {
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

  void rematch() {
    final settings = state.settings as X01MatchSettings;
    final players = state.players;
    final startingPlayerIndex = state.players.isEmpty
        ? 0
        : state.currentPlayerIndex.clamp(0, state.players.length - 1).toInt();

    _history.clear();
    _turnSnapshots.clear();
    _historySnapshots.clear();
    _throwHistory = <DartThrow>[];

    state = state.copyWith(
      currentPlayerIndex: startingPlayerIndex,
      players: players,
      settings: settings,
      game: X01GameState(
        scores: {
          for (final player in players) player.id: settings.startingScore,
        },
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

  void _saveMatchRecord({
    required List<Player> players,
    required Map<String, int> scores,
    required String winnerId,
    required X01MatchSettings settings,
  }) {
    final dartsPerPlayer = _countDartsPerPlayer(players);
    final record = MatchRecord(
      id: const Uuid().v4(),
      gameMode: GameMode.x01,
      playedAt: DateTime.now(),
      startingScore: settings.startingScore,
      playerResults: [
        for (final player in players)
          PlayerResult(
            playerId: player.id,
            playerName: player.name,
            won: player.id == winnerId,
            finalScore: scores[player.id] ?? 0,
            dartsThrown: dartsPerPlayer[player.id] ?? 0,
          ),
      ],
    );

    // Fire-and-forget: we don't await to avoid blocking game UI.
    ref.read(matchHistoryProvider.notifier).addRecord(record);
  }

  /// Counts how many darts each player threw during the entire match by
  /// walking through the flat [_throwHistory].  X01 assigns throws in
  /// round-robin turn order (up to 3 per turn).
  Map<String, int> _countDartsPerPlayer(List<Player> players) {
    if (players.isEmpty) return {};
    final counts = <String, int>{
      for (final p in players) p.id: 0,
    };
    var playerIdx = 0;
    var throwsInTurn = 0;
    for (final _ in _throwHistory) {
      final playerId = players[playerIdx].id;
      counts[playerId] = (counts[playerId] ?? 0) + 1;
      throwsInTurn++;
      if (throwsInTurn >= 3) {
        throwsInTurn = 0;
        playerIdx = (playerIdx + 1) % players.length;
      }
    }
    return counts;
  }
}
