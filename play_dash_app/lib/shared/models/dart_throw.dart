import 'package:freezed_annotation/freezed_annotation.dart';

part 'dart_throw.freezed.dart';
part 'dart_throw.g.dart';

@freezed
abstract class DartThrow with _$DartThrow {
  const factory DartThrow({
    required int segment,
    required int multiplier,
  }) = _DartThrow;

  factory DartThrow.fromJson(Map<String, dynamic> json) =>
      _$DartThrowFromJson(json);
}
