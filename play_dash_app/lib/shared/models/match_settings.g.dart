// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

X01MatchSettings _$X01MatchSettingsFromJson(Map<String, dynamic> json) =>
    X01MatchSettings(
      startingScore: (json['startingScore'] as num?)?.toInt() ?? 501,
      doubleIn: json['doubleIn'] as bool? ?? false,
      doubleOut: json['doubleOut'] as bool? ?? true,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$X01MatchSettingsToJson(X01MatchSettings instance) =>
    <String, dynamic>{
      'startingScore': instance.startingScore,
      'doubleIn': instance.doubleIn,
      'doubleOut': instance.doubleOut,
      'type': instance.$type,
    };

CricketMatchSettings _$CricketMatchSettingsFromJson(
        Map<String, dynamic> json) =>
    CricketMatchSettings(
      cutThroat: json['cutThroat'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$CricketMatchSettingsToJson(
        CricketMatchSettings instance) =>
    <String, dynamic>{
      'cutThroat': instance.cutThroat,
      'type': instance.$type,
    };
