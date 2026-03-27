// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
MatchSettings _$MatchSettingsFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'x01':
      return X01MatchSettings.fromJson(json);
    case 'cricket':
      return CricketMatchSettings.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'type', 'MatchSettings',
          'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$MatchSettings {
  /// Serializes this MatchSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MatchSettings);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MatchSettings()';
  }
}

/// @nodoc
class $MatchSettingsCopyWith<$Res> {
  $MatchSettingsCopyWith(MatchSettings _, $Res Function(MatchSettings) __);
}

/// Adds pattern-matching-related methods to [MatchSettings].
extension MatchSettingsPatterns on MatchSettings {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(X01MatchSettings value)? x01,
    TResult Function(CricketMatchSettings value)? cricket,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchSettings() when x01 != null:
        return x01(_that);
      case CricketMatchSettings() when cricket != null:
        return cricket(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(X01MatchSettings value) x01,
    required TResult Function(CricketMatchSettings value) cricket,
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchSettings():
        return x01(_that);
      case CricketMatchSettings():
        return cricket(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(X01MatchSettings value)? x01,
    TResult? Function(CricketMatchSettings value)? cricket,
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchSettings() when x01 != null:
        return x01(_that);
      case CricketMatchSettings() when cricket != null:
        return cricket(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int startingScore, bool doubleIn, bool doubleOut)? x01,
    TResult Function(bool cutThroat)? cricket,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchSettings() when x01 != null:
        return x01(_that.startingScore, _that.doubleIn, _that.doubleOut);
      case CricketMatchSettings() when cricket != null:
        return cricket(_that.cutThroat);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int startingScore, bool doubleIn, bool doubleOut)
        x01,
    required TResult Function(bool cutThroat) cricket,
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchSettings():
        return x01(_that.startingScore, _that.doubleIn, _that.doubleOut);
      case CricketMatchSettings():
        return cricket(_that.cutThroat);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int startingScore, bool doubleIn, bool doubleOut)? x01,
    TResult? Function(bool cutThroat)? cricket,
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchSettings() when x01 != null:
        return x01(_that.startingScore, _that.doubleIn, _that.doubleOut);
      case CricketMatchSettings() when cricket != null:
        return cricket(_that.cutThroat);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class X01MatchSettings implements MatchSettings {
  const X01MatchSettings(
      {this.startingScore = 501,
      this.doubleIn = false,
      this.doubleOut = true,
      final String? $type})
      : $type = $type ?? 'x01';
  factory X01MatchSettings.fromJson(Map<String, dynamic> json) =>
      _$X01MatchSettingsFromJson(json);

  @JsonKey()
  final int startingScore;
  @JsonKey()
  final bool doubleIn;
  @JsonKey()
  final bool doubleOut;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of MatchSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $X01MatchSettingsCopyWith<X01MatchSettings> get copyWith =>
      _$X01MatchSettingsCopyWithImpl<X01MatchSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$X01MatchSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is X01MatchSettings &&
            (identical(other.startingScore, startingScore) ||
                other.startingScore == startingScore) &&
            (identical(other.doubleIn, doubleIn) ||
                other.doubleIn == doubleIn) &&
            (identical(other.doubleOut, doubleOut) ||
                other.doubleOut == doubleOut));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, startingScore, doubleIn, doubleOut);

  @override
  String toString() {
    return 'MatchSettings.x01(startingScore: $startingScore, doubleIn: $doubleIn, doubleOut: $doubleOut)';
  }
}

/// @nodoc
abstract mixin class $X01MatchSettingsCopyWith<$Res>
    implements $MatchSettingsCopyWith<$Res> {
  factory $X01MatchSettingsCopyWith(
          X01MatchSettings value, $Res Function(X01MatchSettings) _then) =
      _$X01MatchSettingsCopyWithImpl;
  @useResult
  $Res call({int startingScore, bool doubleIn, bool doubleOut});
}

/// @nodoc
class _$X01MatchSettingsCopyWithImpl<$Res>
    implements $X01MatchSettingsCopyWith<$Res> {
  _$X01MatchSettingsCopyWithImpl(this._self, this._then);

  final X01MatchSettings _self;
  final $Res Function(X01MatchSettings) _then;

  /// Create a copy of MatchSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startingScore = null,
    Object? doubleIn = null,
    Object? doubleOut = null,
  }) {
    return _then(X01MatchSettings(
      startingScore: null == startingScore
          ? _self.startingScore
          : startingScore // ignore: cast_nullable_to_non_nullable
              as int,
      doubleIn: null == doubleIn
          ? _self.doubleIn
          : doubleIn // ignore: cast_nullable_to_non_nullable
              as bool,
      doubleOut: null == doubleOut
          ? _self.doubleOut
          : doubleOut // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class CricketMatchSettings implements MatchSettings {
  const CricketMatchSettings({this.cutThroat = false, final String? $type})
      : $type = $type ?? 'cricket';
  factory CricketMatchSettings.fromJson(Map<String, dynamic> json) =>
      _$CricketMatchSettingsFromJson(json);

  @JsonKey()
  final bool cutThroat;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of MatchSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CricketMatchSettingsCopyWith<CricketMatchSettings> get copyWith =>
      _$CricketMatchSettingsCopyWithImpl<CricketMatchSettings>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CricketMatchSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CricketMatchSettings &&
            (identical(other.cutThroat, cutThroat) ||
                other.cutThroat == cutThroat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cutThroat);

  @override
  String toString() {
    return 'MatchSettings.cricket(cutThroat: $cutThroat)';
  }
}

/// @nodoc
abstract mixin class $CricketMatchSettingsCopyWith<$Res>
    implements $MatchSettingsCopyWith<$Res> {
  factory $CricketMatchSettingsCopyWith(CricketMatchSettings value,
          $Res Function(CricketMatchSettings) _then) =
      _$CricketMatchSettingsCopyWithImpl;
  @useResult
  $Res call({bool cutThroat});
}

/// @nodoc
class _$CricketMatchSettingsCopyWithImpl<$Res>
    implements $CricketMatchSettingsCopyWith<$Res> {
  _$CricketMatchSettingsCopyWithImpl(this._self, this._then);

  final CricketMatchSettings _self;
  final $Res Function(CricketMatchSettings) _then;

  /// Create a copy of MatchSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cutThroat = null,
  }) {
    return _then(CricketMatchSettings(
      cutThroat: null == cutThroat
          ? _self.cutThroat
          : cutThroat // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
