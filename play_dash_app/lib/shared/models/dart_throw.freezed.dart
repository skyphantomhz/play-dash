// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dart_throw.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DartThrow {
  int get segment;
  int get multiplier;

  /// Create a copy of DartThrow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DartThrowCopyWith<DartThrow> get copyWith =>
      _$DartThrowCopyWithImpl<DartThrow>(this as DartThrow, _$identity);

  /// Serializes this DartThrow to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DartThrow &&
            (identical(other.segment, segment) || other.segment == segment) &&
            (identical(other.multiplier, multiplier) ||
                other.multiplier == multiplier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, segment, multiplier);

  @override
  String toString() {
    return 'DartThrow(segment: $segment, multiplier: $multiplier)';
  }
}

/// @nodoc
abstract mixin class $DartThrowCopyWith<$Res> {
  factory $DartThrowCopyWith(DartThrow value, $Res Function(DartThrow) _then) =
      _$DartThrowCopyWithImpl;
  @useResult
  $Res call({int segment, int multiplier});
}

/// @nodoc
class _$DartThrowCopyWithImpl<$Res> implements $DartThrowCopyWith<$Res> {
  _$DartThrowCopyWithImpl(this._self, this._then);

  final DartThrow _self;
  final $Res Function(DartThrow) _then;

  /// Create a copy of DartThrow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? segment = null,
    Object? multiplier = null,
  }) {
    return _then(_self.copyWith(
      segment: null == segment
          ? _self.segment
          : segment // ignore: cast_nullable_to_non_nullable
              as int,
      multiplier: null == multiplier
          ? _self.multiplier
          : multiplier // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [DartThrow].
extension DartThrowPatterns on DartThrow {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_DartThrow value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DartThrow() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_DartThrow value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DartThrow():
        return $default(_that);
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_DartThrow value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DartThrow() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int segment, int multiplier)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DartThrow() when $default != null:
        return $default(_that.segment, _that.multiplier);
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
  TResult when<TResult extends Object?>(
    TResult Function(int segment, int multiplier) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DartThrow():
        return $default(_that.segment, _that.multiplier);
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int segment, int multiplier)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DartThrow() when $default != null:
        return $default(_that.segment, _that.multiplier);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DartThrow implements DartThrow {
  const _DartThrow({required this.segment, required this.multiplier});
  factory _DartThrow.fromJson(Map<String, dynamic> json) =>
      _$DartThrowFromJson(json);

  @override
  final int segment;
  @override
  final int multiplier;

  /// Create a copy of DartThrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DartThrowCopyWith<_DartThrow> get copyWith =>
      __$DartThrowCopyWithImpl<_DartThrow>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DartThrowToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DartThrow &&
            (identical(other.segment, segment) || other.segment == segment) &&
            (identical(other.multiplier, multiplier) ||
                other.multiplier == multiplier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, segment, multiplier);

  @override
  String toString() {
    return 'DartThrow(segment: $segment, multiplier: $multiplier)';
  }
}

/// @nodoc
abstract mixin class _$DartThrowCopyWith<$Res>
    implements $DartThrowCopyWith<$Res> {
  factory _$DartThrowCopyWith(
          _DartThrow value, $Res Function(_DartThrow) _then) =
      __$DartThrowCopyWithImpl;
  @override
  @useResult
  $Res call({int segment, int multiplier});
}

/// @nodoc
class __$DartThrowCopyWithImpl<$Res> implements _$DartThrowCopyWith<$Res> {
  __$DartThrowCopyWithImpl(this._self, this._then);

  final _DartThrow _self;
  final $Res Function(_DartThrow) _then;

  /// Create a copy of DartThrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? segment = null,
    Object? multiplier = null,
  }) {
    return _then(_DartThrow(
      segment: null == segment
          ? _self.segment
          : segment // ignore: cast_nullable_to_non_nullable
              as int,
      multiplier: null == multiplier
          ? _self.multiplier
          : multiplier // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
