// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerResult {
  String get playerId;
  String get playerName;
  bool get won;

  /// Final score value (remaining score for X01, accumulated points for Cricket).
  int get finalScore;

  /// Number of darts thrown during the match.
  int get dartsThrown;

  /// Create a copy of PlayerResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlayerResultCopyWith<PlayerResult> get copyWith =>
      _$PlayerResultCopyWithImpl<PlayerResult>(
          this as PlayerResult, _$identity);

  /// Serializes this PlayerResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlayerResult &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.won, won) || other.won == won) &&
            (identical(other.finalScore, finalScore) ||
                other.finalScore == finalScore) &&
            (identical(other.dartsThrown, dartsThrown) ||
                other.dartsThrown == dartsThrown));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, playerId, playerName, won, finalScore, dartsThrown);

  @override
  String toString() {
    return 'PlayerResult(playerId: $playerId, playerName: $playerName, won: $won, finalScore: $finalScore, dartsThrown: $dartsThrown)';
  }
}

/// @nodoc
abstract mixin class $PlayerResultCopyWith<$Res> {
  factory $PlayerResultCopyWith(
          PlayerResult value, $Res Function(PlayerResult) _then) =
      _$PlayerResultCopyWithImpl;
  @useResult
  $Res call(
      {String playerId,
      String playerName,
      bool won,
      int finalScore,
      int dartsThrown});
}

/// @nodoc
class _$PlayerResultCopyWithImpl<$Res> implements $PlayerResultCopyWith<$Res> {
  _$PlayerResultCopyWithImpl(this._self, this._then);

  final PlayerResult _self;
  final $Res Function(PlayerResult) _then;

  /// Create a copy of PlayerResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? won = null,
    Object? finalScore = null,
    Object? dartsThrown = null,
  }) {
    return _then(_self.copyWith(
      playerId: null == playerId
          ? _self.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      playerName: null == playerName
          ? _self.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      won: null == won
          ? _self.won
          : won // ignore: cast_nullable_to_non_nullable
              as bool,
      finalScore: null == finalScore
          ? _self.finalScore
          : finalScore // ignore: cast_nullable_to_non_nullable
              as int,
      dartsThrown: null == dartsThrown
          ? _self.dartsThrown
          : dartsThrown // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [PlayerResult].
extension PlayerResultPatterns on PlayerResult {
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
    TResult Function(_PlayerResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlayerResult() when $default != null:
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
    TResult Function(_PlayerResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerResult():
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
    TResult? Function(_PlayerResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerResult() when $default != null:
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
    TResult Function(String playerId, String playerName, bool won,
            int finalScore, int dartsThrown)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlayerResult() when $default != null:
        return $default(_that.playerId, _that.playerName, _that.won,
            _that.finalScore, _that.dartsThrown);
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
    TResult Function(String playerId, String playerName, bool won,
            int finalScore, int dartsThrown)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerResult():
        return $default(_that.playerId, _that.playerName, _that.won,
            _that.finalScore, _that.dartsThrown);
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
    TResult? Function(String playerId, String playerName, bool won,
            int finalScore, int dartsThrown)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerResult() when $default != null:
        return $default(_that.playerId, _that.playerName, _that.won,
            _that.finalScore, _that.dartsThrown);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PlayerResult implements PlayerResult {
  const _PlayerResult(
      {required this.playerId,
      required this.playerName,
      required this.won,
      this.finalScore = 0,
      this.dartsThrown = 0});
  factory _PlayerResult.fromJson(Map<String, dynamic> json) =>
      _$PlayerResultFromJson(json);

  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final bool won;

  /// Final score value (remaining score for X01, accumulated points for Cricket).
  @override
  @JsonKey()
  final int finalScore;

  /// Number of darts thrown during the match.
  @override
  @JsonKey()
  final int dartsThrown;

  /// Create a copy of PlayerResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlayerResultCopyWith<_PlayerResult> get copyWith =>
      __$PlayerResultCopyWithImpl<_PlayerResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PlayerResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlayerResult &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.won, won) || other.won == won) &&
            (identical(other.finalScore, finalScore) ||
                other.finalScore == finalScore) &&
            (identical(other.dartsThrown, dartsThrown) ||
                other.dartsThrown == dartsThrown));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, playerId, playerName, won, finalScore, dartsThrown);

  @override
  String toString() {
    return 'PlayerResult(playerId: $playerId, playerName: $playerName, won: $won, finalScore: $finalScore, dartsThrown: $dartsThrown)';
  }
}

/// @nodoc
abstract mixin class _$PlayerResultCopyWith<$Res>
    implements $PlayerResultCopyWith<$Res> {
  factory _$PlayerResultCopyWith(
          _PlayerResult value, $Res Function(_PlayerResult) _then) =
      __$PlayerResultCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String playerId,
      String playerName,
      bool won,
      int finalScore,
      int dartsThrown});
}

/// @nodoc
class __$PlayerResultCopyWithImpl<$Res>
    implements _$PlayerResultCopyWith<$Res> {
  __$PlayerResultCopyWithImpl(this._self, this._then);

  final _PlayerResult _self;
  final $Res Function(_PlayerResult) _then;

  /// Create a copy of PlayerResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? won = null,
    Object? finalScore = null,
    Object? dartsThrown = null,
  }) {
    return _then(_PlayerResult(
      playerId: null == playerId
          ? _self.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      playerName: null == playerName
          ? _self.playerName
          : playerName // ignore: cast_nullable_to_non_nullable
              as String,
      won: null == won
          ? _self.won
          : won // ignore: cast_nullable_to_non_nullable
              as bool,
      finalScore: null == finalScore
          ? _self.finalScore
          : finalScore // ignore: cast_nullable_to_non_nullable
              as int,
      dartsThrown: null == dartsThrown
          ? _self.dartsThrown
          : dartsThrown // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$MatchRecord {
  String get id;
  GameMode get gameMode;
  DateTime get playedAt;
  List<PlayerResult> get playerResults;

  /// For X01: the starting score (301 / 501 / 701).
  int? get startingScore;

  /// For Cricket: whether cut-throat rules were used.
  bool get cutThroat;

  /// Create a copy of MatchRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MatchRecordCopyWith<MatchRecord> get copyWith =>
      _$MatchRecordCopyWithImpl<MatchRecord>(this as MatchRecord, _$identity);

  /// Serializes this MatchRecord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MatchRecord &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gameMode, gameMode) ||
                other.gameMode == gameMode) &&
            (identical(other.playedAt, playedAt) ||
                other.playedAt == playedAt) &&
            const DeepCollectionEquality()
                .equals(other.playerResults, playerResults) &&
            (identical(other.startingScore, startingScore) ||
                other.startingScore == startingScore) &&
            (identical(other.cutThroat, cutThroat) ||
                other.cutThroat == cutThroat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      gameMode,
      playedAt,
      const DeepCollectionEquality().hash(playerResults),
      startingScore,
      cutThroat);

  @override
  String toString() {
    return 'MatchRecord(id: $id, gameMode: $gameMode, playedAt: $playedAt, playerResults: $playerResults, startingScore: $startingScore, cutThroat: $cutThroat)';
  }
}

/// @nodoc
abstract mixin class $MatchRecordCopyWith<$Res> {
  factory $MatchRecordCopyWith(
          MatchRecord value, $Res Function(MatchRecord) _then) =
      _$MatchRecordCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      GameMode gameMode,
      DateTime playedAt,
      List<PlayerResult> playerResults,
      int? startingScore,
      bool cutThroat});
}

/// @nodoc
class _$MatchRecordCopyWithImpl<$Res> implements $MatchRecordCopyWith<$Res> {
  _$MatchRecordCopyWithImpl(this._self, this._then);

  final MatchRecord _self;
  final $Res Function(MatchRecord) _then;

  /// Create a copy of MatchRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameMode = null,
    Object? playedAt = null,
    Object? playerResults = null,
    Object? startingScore = freezed,
    Object? cutThroat = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      gameMode: null == gameMode
          ? _self.gameMode
          : gameMode // ignore: cast_nullable_to_non_nullable
              as GameMode,
      playedAt: null == playedAt
          ? _self.playedAt
          : playedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      playerResults: null == playerResults
          ? _self.playerResults
          : playerResults // ignore: cast_nullable_to_non_nullable
              as List<PlayerResult>,
      startingScore: freezed == startingScore
          ? _self.startingScore
          : startingScore // ignore: cast_nullable_to_non_nullable
              as int?,
      cutThroat: null == cutThroat
          ? _self.cutThroat
          : cutThroat // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MatchRecord].
extension MatchRecordPatterns on MatchRecord {
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
    TResult Function(_MatchRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MatchRecord() when $default != null:
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
    TResult Function(_MatchRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchRecord():
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
    TResult? Function(_MatchRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchRecord() when $default != null:
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
    TResult Function(
            String id,
            GameMode gameMode,
            DateTime playedAt,
            List<PlayerResult> playerResults,
            int? startingScore,
            bool cutThroat)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MatchRecord() when $default != null:
        return $default(_that.id, _that.gameMode, _that.playedAt,
            _that.playerResults, _that.startingScore, _that.cutThroat);
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
    TResult Function(
            String id,
            GameMode gameMode,
            DateTime playedAt,
            List<PlayerResult> playerResults,
            int? startingScore,
            bool cutThroat)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchRecord():
        return $default(_that.id, _that.gameMode, _that.playedAt,
            _that.playerResults, _that.startingScore, _that.cutThroat);
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
    TResult? Function(
            String id,
            GameMode gameMode,
            DateTime playedAt,
            List<PlayerResult> playerResults,
            int? startingScore,
            bool cutThroat)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MatchRecord() when $default != null:
        return $default(_that.id, _that.gameMode, _that.playedAt,
            _that.playerResults, _that.startingScore, _that.cutThroat);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MatchRecord implements MatchRecord {
  const _MatchRecord(
      {required this.id,
      required this.gameMode,
      required this.playedAt,
      required final List<PlayerResult> playerResults,
      this.startingScore,
      this.cutThroat = false})
      : _playerResults = playerResults;
  factory _MatchRecord.fromJson(Map<String, dynamic> json) =>
      _$MatchRecordFromJson(json);

  @override
  final String id;
  @override
  final GameMode gameMode;
  @override
  final DateTime playedAt;
  final List<PlayerResult> _playerResults;
  @override
  List<PlayerResult> get playerResults {
    if (_playerResults is EqualUnmodifiableListView) return _playerResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerResults);
  }

  /// For X01: the starting score (301 / 501 / 701).
  @override
  final int? startingScore;

  /// For Cricket: whether cut-throat rules were used.
  @override
  @JsonKey()
  final bool cutThroat;

  /// Create a copy of MatchRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MatchRecordCopyWith<_MatchRecord> get copyWith =>
      __$MatchRecordCopyWithImpl<_MatchRecord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MatchRecordToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MatchRecord &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gameMode, gameMode) ||
                other.gameMode == gameMode) &&
            (identical(other.playedAt, playedAt) ||
                other.playedAt == playedAt) &&
            const DeepCollectionEquality()
                .equals(other._playerResults, _playerResults) &&
            (identical(other.startingScore, startingScore) ||
                other.startingScore == startingScore) &&
            (identical(other.cutThroat, cutThroat) ||
                other.cutThroat == cutThroat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      gameMode,
      playedAt,
      const DeepCollectionEquality().hash(_playerResults),
      startingScore,
      cutThroat);

  @override
  String toString() {
    return 'MatchRecord(id: $id, gameMode: $gameMode, playedAt: $playedAt, playerResults: $playerResults, startingScore: $startingScore, cutThroat: $cutThroat)';
  }
}

/// @nodoc
abstract mixin class _$MatchRecordCopyWith<$Res>
    implements $MatchRecordCopyWith<$Res> {
  factory _$MatchRecordCopyWith(
          _MatchRecord value, $Res Function(_MatchRecord) _then) =
      __$MatchRecordCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      GameMode gameMode,
      DateTime playedAt,
      List<PlayerResult> playerResults,
      int? startingScore,
      bool cutThroat});
}

/// @nodoc
class __$MatchRecordCopyWithImpl<$Res> implements _$MatchRecordCopyWith<$Res> {
  __$MatchRecordCopyWithImpl(this._self, this._then);

  final _MatchRecord _self;
  final $Res Function(_MatchRecord) _then;

  /// Create a copy of MatchRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? gameMode = null,
    Object? playedAt = null,
    Object? playerResults = null,
    Object? startingScore = freezed,
    Object? cutThroat = null,
  }) {
    return _then(_MatchRecord(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      gameMode: null == gameMode
          ? _self.gameMode
          : gameMode // ignore: cast_nullable_to_non_nullable
              as GameMode,
      playedAt: null == playedAt
          ? _self.playedAt
          : playedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      playerResults: null == playerResults
          ? _self._playerResults
          : playerResults // ignore: cast_nullable_to_non_nullable
              as List<PlayerResult>,
      startingScore: freezed == startingScore
          ? _self.startingScore
          : startingScore // ignore: cast_nullable_to_non_nullable
              as int?,
      cutThroat: null == cutThroat
          ? _self.cutThroat
          : cutThroat // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
