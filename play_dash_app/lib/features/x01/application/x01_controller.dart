import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_settings.dart';
import '../../../shared/models/match_state.dart';
import '../../../shared/models/player.dart';
import '../domain/x01_engine.dart';

final x01ControllerProvider =
    NotifierProvider<X01Controller, X01MatchState>(X01Controller.new);

class X01Controller extends Notifier<X01MatchState> {
  @override
  X01MatchState build() {
    const X01MatchSettings settings = X01MatchSettings();
    final players = <Player>[
      const Player(id: 'player-1', name: 'Player 1'),
      const Player(id: 'player-2', name: 'Player 2'),
    ];

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

    final currentPlayer = state.players[state.currentPlayerIndex];
    final settings = state.settings as X01MatchSettings;
    final currentScore = state.game.scores[currentPlayer.id] ?? settings.startingScore;
    final updatedThrows = [...state.game.currentTurnThrows, dartThrow];

    final turnResult = X01Engine.applyTurn(
      currentScore: currentScore,
      throws: updatedThrows,
      settings: settings,
    );

    final updatedScores = Map<String, int>.from(state.game.scores)
      ..[currentPlayer.id] = turnResult.endingScore;

    final didUseAllDarts = updatedThrows.length >= 3;
    final shouldAdvanceTurn = turnResult.bust || turnResult.finished || didUseAllDarts;
    final shouldMoveToNextPlayer = turnResult.bust || didUseAllDarts;

    state = state.copyWith(
      currentPlayerIndex: shouldMoveToNextPlayer
          ? _nextPlayerIndex(state.currentPlayerIndex, state.players.length)
          : state.currentPlayerIndex,
      game: state.game.copyWith(
        scores: Map.unmodifiable(updatedScores),
        currentTurnThrows: shouldAdvanceTurn
            ? const <DartThrow>[]
            : List.unmodifiable(updatedThrows),
        winnerPlayerId: turnResult.finished ? currentPlayer.id : state.game.winnerPlayerId,
      ),
    );
  }

  void resetCurrentTurn() {
    state = state.copyWith(
      game: state.game.copyWith(currentTurnThrows: const <DartThrow>[]),
    );
  }

  int _nextPlayerIndex(int currentIndex, int playerCount) {
    if (playerCount <= 1) {
      return 0;
    }

    return (currentIndex + 1) % playerCount;
  }
}
