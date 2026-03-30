import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_record.freezed.dart';
part 'match_record.g.dart';

/// The type of game that was played.
enum GameMode { x01, cricket }

/// A summary of a player's performance within a single match.
@freezed
abstract class PlayerResult with _$PlayerResult {
  const factory PlayerResult({
    required String playerId,
    required String playerName,
    required bool won,
    /// Final score value (remaining score for X01, accumulated points for Cricket).
    @Default(0) int finalScore,
    /// Number of darts thrown during the match.
    @Default(0) int dartsThrown,
  }) = _PlayerResult;

  factory PlayerResult.fromJson(Map<String, dynamic> json) =>
      _$PlayerResultFromJson(json);
}

/// An immutable record of a completed match, persisted to SharedPreferences.
@freezed
abstract class MatchRecord with _$MatchRecord {
  const factory MatchRecord({
    required String id,
    required GameMode gameMode,
    required DateTime playedAt,
    required List<PlayerResult> playerResults,
    /// For X01: the starting score (301 / 501 / 701).
    int? startingScore,
    /// For Cricket: whether cut-throat rules were used.
    @Default(false) bool cutThroat,
  }) = _MatchRecord;

  factory MatchRecord.fromJson(Map<String, dynamic> json) =>
      _$MatchRecordFromJson(json);
}
