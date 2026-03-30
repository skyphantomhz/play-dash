// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerResult _$PlayerResultFromJson(Map<String, dynamic> json) =>
    _PlayerResult(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      won: json['won'] as bool,
      finalScore: (json['finalScore'] as num?)?.toInt() ?? 0,
      dartsThrown: (json['dartsThrown'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PlayerResultToJson(_PlayerResult instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'won': instance.won,
      'finalScore': instance.finalScore,
      'dartsThrown': instance.dartsThrown,
    };

_MatchRecord _$MatchRecordFromJson(Map<String, dynamic> json) => _MatchRecord(
      id: json['id'] as String,
      gameMode: $enumDecode(_$GameModeEnumMap, json['gameMode']),
      playedAt: DateTime.parse(json['playedAt'] as String),
      playerResults: (json['playerResults'] as List<dynamic>)
          .map((e) => PlayerResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      startingScore: (json['startingScore'] as num?)?.toInt(),
      cutThroat: json['cutThroat'] as bool? ?? false,
    );

Map<String, dynamic> _$MatchRecordToJson(_MatchRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameMode': _$GameModeEnumMap[instance.gameMode]!,
      'playedAt': instance.playedAt.toIso8601String(),
      'playerResults': instance.playerResults,
      'startingScore': instance.startingScore,
      'cutThroat': instance.cutThroat,
    };

const _$GameModeEnumMap = {
  GameMode.x01: 'x01',
  GameMode.cricket: 'cricket',
};
