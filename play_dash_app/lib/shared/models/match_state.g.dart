// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X01MatchState _$X01MatchStateFromJson(Map<String, dynamic> json) =>
    X01MatchState(
      currentPlayerIndex: (json['currentPlayerIndex'] as num?)?.toInt() ?? 0,
      players: (json['players'] as List<dynamic>?)
              ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Player>[],
      settings:
          MatchSettings.fromJson(json['settings'] as Map<String, dynamic>),
      game: X01GameState.fromJson(json['game'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$X01MatchStateToJson(X01MatchState instance) =>
    <String, dynamic>{
      'currentPlayerIndex': instance.currentPlayerIndex,
      'players': instance.players,
      'settings': instance.settings,
      'game': instance.game,
      'type': instance.$type,
    };

CricketMatchState _$CricketMatchStateFromJson(Map<String, dynamic> json) =>
    CricketMatchState(
      currentPlayerIndex: (json['currentPlayerIndex'] as num?)?.toInt() ?? 0,
      players: (json['players'] as List<dynamic>?)
              ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Player>[],
      settings:
          MatchSettings.fromJson(json['settings'] as Map<String, dynamic>),
      game: CricketGameState.fromJson(json['game'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$CricketMatchStateToJson(CricketMatchState instance) =>
    <String, dynamic>{
      'currentPlayerIndex': instance.currentPlayerIndex,
      'players': instance.players,
      'settings': instance.settings,
      'game': instance.game,
      'type': instance.$type,
    };

_X01GameState _$X01GameStateFromJson(Map<String, dynamic> json) =>
    _X01GameState(
      scores: (json['scores'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
      currentTurnThrows: (json['currentTurnThrows'] as List<dynamic>?)
              ?.map((e) => DartThrow.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DartThrow>[],
      winnerPlayerId: json['winnerPlayerId'] as String?,
    );

Map<String, dynamic> _$X01GameStateToJson(_X01GameState instance) =>
    <String, dynamic>{
      'scores': instance.scores,
      'currentTurnThrows': instance.currentTurnThrows,
      'winnerPlayerId': instance.winnerPlayerId,
    };

_CricketGameState _$CricketGameStateFromJson(Map<String, dynamic> json) =>
    _CricketGameState(
      marks: (json['marks'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                (e as Map<String, dynamic>).map(
                  (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
                )),
          ) ??
          const <String, Map<int, int>>{},
      scores: (json['scores'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
      winnerPlayerId: json['winnerPlayerId'] as String?,
    );

Map<String, dynamic> _$CricketGameStateToJson(_CricketGameState instance) =>
    <String, dynamic>{
      'marks': instance.marks.map(
          (k, e) => MapEntry(k, e.map((k, e) => MapEntry(k.toString(), e)))),
      'scores': instance.scores,
      'winnerPlayerId': instance.winnerPlayerId,
    };
