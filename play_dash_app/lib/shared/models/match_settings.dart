import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_settings.freezed.dart';
part 'match_settings.g.dart';

@Freezed(unionKey: 'type')
abstract class MatchSettings with _$MatchSettings {
  const factory MatchSettings.x01({
    @Default(501) int startingScore,
    @Default(false) bool doubleIn,
    @Default(true) bool doubleOut,
  }) = X01MatchSettings;

  const factory MatchSettings.cricket({
    @Default(false) bool cutThroat,
  }) = CricketMatchSettings;

  factory MatchSettings.fromJson(Map<String, dynamic> json) =>
      _$MatchSettingsFromJson(json);
}
