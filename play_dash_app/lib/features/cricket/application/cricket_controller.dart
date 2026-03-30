import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/history_providers.dart';
import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_record.dart';
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
  List<DartThrow> get currentTurnThrows =>
      List.unmodifiable(_currentTurnThrows);

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
      scoreOverflow: false,
    );

    final updatedMarks = Map<String, Map<int, int>>.from(state.game.marks)
      ..[currentPlayer.id] = Map.unmodifiable(throwResult.updatedMarks);

    final updatedScores = Map<String, int>.from(state.game.scores);

    if (throwResult.overflowMarks > 0) {
      final opponentsNotClosed = state.players.where((p) {
        if (p.id == currentPlayer.id) return false;
        final oppMarks = state.game.marks[p.id]?[throwResult.segment] ?? 0;
        return oppMarks < 3;
      }).toList();

      if (opponentsNotClosed.isNotEmpty) {
        final points = throwResult.overflowMarks *
            (throwResult.segment == 25 ? 25 : throwResult.segment);
        if (!settings.cutThroat) {
          updatedScores[currentPlayer.id] = currentScore + points;
        } else {
          for (final opp in opponentsNotClosed) {
            updatedScores[opp.id] = (updatedScores[opp.id] ?? 0) + points;
          }
        }
      }
    }

    final updatedCurrentTurnThrows = [..._currentTurnThrows, dartThrow];

    final winnerId =
        _resolveWinner(updatedMarks, updatedScores, settings.cutThroat);
    final shouldAdvanceTurn =
        winnerId != null || updatedCurrentTurnThrows.length >= 3;

    _history.add(previousState);
    _turnSnapshots.add(List<DartThrow>.from(_currentTurnThrows));
    _historySnapshots.add(List<DartThrow>.from(_throwHistory));
    _throwHistory = [..._throwHistory, dartThrow];
    _currentTurnThrows =
        shouldAdvanceTurn ? <DartThrow>[] : updatedCurrentTurnThrows;

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

    // Persist to history when a winner is determined.
    if (winnerId != null) {
      _saveMatchRecord(
        players: state.players,
        scores: updatedScores,
        winnerId: winnerId,
        settings: settings,
      );
    }
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

  void rematch() {
    final settings = state.settings as CricketMatchSettings;
    final players = state.players;
    final startingPlayerIndex = state.players.isEmpty
        ? 0
        : state.currentPlayerIndex.clamp(0, state.players.length - 1).toInt();

    _history.clear();
    _turnSnapshots.clear();
    _historySnapshots.clear();
    _throwHistory = <DartThrow>[];
    _currentTurnThrows = <DartThrow>[];

    state = state.copyWith(
      currentPlayerIndex: startingPlayerIndex,
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

  Map<int, int> _emptyMarks() => {
        for (final segment in _segments) segment: 0,
      };

  String? _resolveWinner(
    Map<String, Map<int, int>> marks,
    Map<String, int> scores,
    bool cutThroat,
  ) {
    final closedPlayers = state.players.where((player) {
      final playerMarks = marks[player.id] ?? const <int, int>{};
      return _segments.every((segment) => (playerMarks[segment] ?? 0) >= 3);
    }).toList();

    if (closedPlayers.isEmpty) {
      return null;
    }

    if (state.players.length == 1) {
      return closedPlayers.first.id;
    }

    for (final player in closedPlayers) {
      final playerScore = scores[player.id] ?? 0;
      bool isWinner = true;
      for (final opp in state.players) {
        if (opp.id == player.id) continue;
        final oppScore = scores[opp.id] ?? 0;
        if (cutThroat) {
          if (playerScore > oppScore) {
            isWinner = false;
            break;
          }
        } else {
          if (playerScore < oppScore) {
            isWinner = false;
            break;
          }
        }
      }
      if (isWinner) {
        return player.id;
      }
    }

    return null;
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
    required CricketMatchSettings settings,
  }) {
    final record = MatchRecord(
      id: const Uuid().v4(),
      gameMode: GameMode.cricket,
      playedAt: DateTime.now(),
      cutThroat: settings.cutThroat,
      playerResults: [
        for (final player in players)
          PlayerResult(
            playerId: player.id,
            playerName: player.name,
            won: player.id == winnerId,
            finalScore: scores[player.id] ?? 0,
            dartsThrown: players.isNotEmpty
                ? _throwHistory.length ~/ players.length
                : 0,
          ),
      ],
    );

    // Fire-and-forget: we don't await to avoid blocking game UI.
    ref.read(matchHistoryProvider.notifier).addRecord(record);
  }
}
