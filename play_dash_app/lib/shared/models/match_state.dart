import 'package:freezed_annotation/freezed_annotation.dart';

import 'dart_throw.dart';
import 'match_settings.dart';
import 'player.dart';

part 'match_state.freezed.dart';
part 'match_state.g.dart';

@Freezed(unionKey: 'type')
abstract class MatchState with _$MatchState {
  const factory MatchState.x01({
    @Default(0) int currentPlayerIndex,
    @Default(<Player>[]) List<Player> players,
    required MatchSettings settings,
    required X01GameState game,
  }) = X01MatchState;

  const factory MatchState.cricket({
    @Default(0) int currentPlayerIndex,
    @Default(<Player>[]) List<Player> players,
    required MatchSettings settings,
    required CricketGameState game,
  }) = CricketMatchState;

  factory MatchState.fromJson(Map<String, dynamic> json) =>
      _$MatchStateFromJson(json);
}

@freezed
abstract class X01GameState with _$X01GameState {
  const factory X01GameState({
    @Default(<String, int>{}) Map<String, int> scores,
    @Default(<DartThrow>[]) List<DartThrow> currentTurnThrows,
    String? winnerPlayerId,
    /// True for exactly one state update after a bust occurs, then cleared.
    @Default(false) bool lastTurnWasBust,
  }) = _X01GameState;

  factory X01GameState.fromJson(Map<String, dynamic> json) =>
      _$X01GameStateFromJson(json);
}

@freezed
abstract class CricketGameState with _$CricketGameState {
  const factory CricketGameState({
    @Default(<String, Map<int, int>>{}) Map<String, Map<int, int>> marks,
    @Default(<String, int>{}) Map<String, int> scores,
    String? winnerPlayerId,
  }) = _CricketGameState;

  factory CricketGameState.fromJson(Map<String, dynamic> json) =>
      _$CricketGameStateFromJson(json);
}
