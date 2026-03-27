import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_settings.dart';
import '../../../shared/models/match_state.dart';
import '../../../shared/models/player.dart';
import '../domain/cricket_engine.dart';

final cricketControllerProvider =
    NotifierProvider<CricketController, CricketMatchState>(CricketController.new);

class CricketController extends Notifier<CricketMatchState> {
  static const List<int> _segments = <int>[15, 16, 17, 18, 19, 20, 25];

  @override
  CricketMatchState build() {
    const CricketMatchSettings settings = CricketMatchSettings();
    final players = <Player>[
      const Player(id: 'player-1', name: 'Player 1'),
      const Player(id: 'player-2', name: 'Player 2'),
    ];

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

  void addThrow(DartThrow dartThrow) {
    if (state.players.isEmpty || state.game.winnerPlayerId != null) {
      return;
    }

    final currentPlayer = state.players[state.currentPlayerIndex];
    final currentMarks = Map<int, int>.from(state.game.marks[currentPlayer.id] ?? _emptyMarks());
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

    final winnerId = _resolveWinner(updatedMarks, updatedScores);

    state = state.copyWith(
      currentPlayerIndex: winnerId == null
          ? _nextPlayerIndex(state.currentPlayerIndex, state.players.length)
          : state.currentPlayerIndex,
      game: state.game.copyWith(
        marks: Map.unmodifiable(updatedMarks),
        scores: Map.unmodifiable(updatedScores),
        winnerPlayerId: winnerId,
      ),
    );
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

    closedPlayers.sort((a, b) => (scores[b.id] ?? 0).compareTo(scores[a.id] ?? 0));
    return closedPlayers.first.id;
  }

  int _nextPlayerIndex(int currentIndex, int playerCount) {
    if (playerCount <= 1) {
      return 0;
    }

    return (currentIndex + 1) % playerCount;
  }
}
