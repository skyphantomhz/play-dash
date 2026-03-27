// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
MatchState _$MatchStateFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'x01':
      return X01MatchState.fromJson(json);
    case 'cricket':
      return CricketMatchState.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json, 'type', 'MatchState', 'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$MatchState {
  int get currentPlayerIndex;
  List<Player> get players;
  MatchSettings get settings;
  Object get game;

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MatchStateCopyWith<MatchState> get copyWith =>
      _$MatchStateCopyWithImpl<MatchState>(this as MatchState, _$identity);

  /// Serializes this MatchState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MatchState &&
            (identical(other.currentPlayerIndex, currentPlayerIndex) ||
                other.currentPlayerIndex == currentPlayerIndex) &&
            const DeepCollectionEquality().equals(other.players, players) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            const DeepCollectionEquality().equals(other.game, game));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentPlayerIndex,
      const DeepCollectionEquality().hash(players),
      settings,
      const DeepCollectionEquality().hash(game));

  @override
  String toString() {
    return 'MatchState(currentPlayerIndex: $currentPlayerIndex, players: $players, settings: $settings, game: $game)';
  }
}

/// @nodoc
abstract mixin class $MatchStateCopyWith<$Res> {
  factory $MatchStateCopyWith(
          MatchState value, $Res Function(MatchState) _then) =
      _$MatchStateCopyWithImpl;
  @useResult
  $Res call(
      {int currentPlayerIndex, List<Player> players, MatchSettings settings});

  $MatchSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$MatchStateCopyWithImpl<$Res> implements $MatchStateCopyWith<$Res> {
  _$MatchStateCopyWithImpl(this._self, this._then);

  final MatchState _self;
  final $Res Function(MatchState) _then;

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPlayerIndex = null,
    Object? players = null,
    Object? settings = null,
  }) {
    return _then(_self.copyWith(
      currentPlayerIndex: null == currentPlayerIndex
          ? _self.currentPlayerIndex
          : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
              as int,
      players: null == players
          ? _self.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      settings: null == settings
          ? _self.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as MatchSettings,
    ));
  }

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchSettingsCopyWith<$Res> get settings {
    return $MatchSettingsCopyWith<$Res>(_self.settings, (value) {
      return _then(_self.copyWith(settings: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MatchState].
extension MatchStatePatterns on MatchState {
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
    TResult Function(X01MatchState value)? x01,
    TResult Function(CricketMatchState value)? cricket,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchState() when x01 != null:
        return x01(_that);
      case CricketMatchState() when cricket != null:
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
    required TResult Function(X01MatchState value) x01,
    required TResult Function(CricketMatchState value) cricket,
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchState():
        return x01(_that);
      case CricketMatchState():
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
    TResult? Function(X01MatchState value)? x01,
    TResult? Function(CricketMatchState value)? cricket,
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchState() when x01 != null:
        return x01(_that);
      case CricketMatchState() when cricket != null:
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
    TResult Function(int currentPlayerIndex, List<Player> players,
            MatchSettings settings, X01GameState game)?
        x01,
    TResult Function(int currentPlayerIndex, List<Player> players,
            MatchSettings settings, CricketGameState game)?
        cricket,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchState() when x01 != null:
        return x01(_that.currentPlayerIndex, _that.players, _that.settings,
            _that.game);
      case CricketMatchState() when cricket != null:
        return cricket(_that.currentPlayerIndex, _that.players, _that.settings,
            _that.game);
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
    required TResult Function(int currentPlayerIndex, List<Player> players,
            MatchSettings settings, X01GameState game)
        x01,
    required TResult Function(int currentPlayerIndex, List<Player> players,
            MatchSettings settings, CricketGameState game)
        cricket,
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchState():
        return x01(_that.currentPlayerIndex, _that.players, _that.settings,
            _that.game);
      case CricketMatchState():
        return cricket(_that.currentPlayerIndex, _that.players, _that.settings,
            _that.game);
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
    TResult? Function(int currentPlayerIndex, List<Player> players,
            MatchSettings settings, X01GameState game)?
        x01,
    TResult? Function(int currentPlayerIndex, List<Player> players,
            MatchSettings settings, CricketGameState game)?
        cricket,
  }) {
    final _that = this;
    switch (_that) {
      case X01MatchState() when x01 != null:
        return x01(_that.currentPlayerIndex, _that.players, _that.settings,
            _that.game);
      case CricketMatchState() when cricket != null:
        return cricket(_that.currentPlayerIndex, _that.players, _that.settings,
            _that.game);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class X01MatchState implements MatchState {
  const X01MatchState(
      {this.currentPlayerIndex = 0,
      final List<Player> players = const <Player>[],
      required this.settings,
      required this.game,
      final String? $type})
      : _players = players,
        $type = $type ?? 'x01';
  factory X01MatchState.fromJson(Map<String, dynamic> json) =>
      _$X01MatchStateFromJson(json);

  @override
  @JsonKey()
  final int currentPlayerIndex;
  final List<Player> _players;
  @override
  @JsonKey()
  List<Player> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  final MatchSettings settings;
  @override
  final X01GameState game;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $X01MatchStateCopyWith<X01MatchState> get copyWith =>
      _$X01MatchStateCopyWithImpl<X01MatchState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$X01MatchStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is X01MatchState &&
            (identical(other.currentPlayerIndex, currentPlayerIndex) ||
                other.currentPlayerIndex == currentPlayerIndex) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.game, game) || other.game == game));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPlayerIndex,
      const DeepCollectionEquality().hash(_players), settings, game);

  @override
  String toString() {
    return 'MatchState.x01(currentPlayerIndex: $currentPlayerIndex, players: $players, settings: $settings, game: $game)';
  }
}

/// @nodoc
abstract mixin class $X01MatchStateCopyWith<$Res>
    implements $MatchStateCopyWith<$Res> {
  factory $X01MatchStateCopyWith(
          X01MatchState value, $Res Function(X01MatchState) _then) =
      _$X01MatchStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int currentPlayerIndex,
      List<Player> players,
      MatchSettings settings,
      X01GameState game});

  @override
  $MatchSettingsCopyWith<$Res> get settings;
  $X01GameStateCopyWith<$Res> get game;
}

/// @nodoc
class _$X01MatchStateCopyWithImpl<$Res>
    implements $X01MatchStateCopyWith<$Res> {
  _$X01MatchStateCopyWithImpl(this._self, this._then);

  final X01MatchState _self;
  final $Res Function(X01MatchState) _then;

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentPlayerIndex = null,
    Object? players = null,
    Object? settings = null,
    Object? game = null,
  }) {
    return _then(X01MatchState(
      currentPlayerIndex: null == currentPlayerIndex
          ? _self.currentPlayerIndex
          : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
              as int,
      players: null == players
          ? _self._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      settings: null == settings
          ? _self.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as MatchSettings,
      game: null == game
          ? _self.game
          : game // ignore: cast_nullable_to_non_nullable
              as X01GameState,
    ));
  }

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchSettingsCopyWith<$Res> get settings {
    return $MatchSettingsCopyWith<$Res>(_self.settings, (value) {
      return _then(_self.copyWith(settings: value));
    });
  }

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $X01GameStateCopyWith<$Res> get game {
    return $X01GameStateCopyWith<$Res>(_self.game, (value) {
      return _then(_self.copyWith(game: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class CricketMatchState implements MatchState {
  const CricketMatchState(
      {this.currentPlayerIndex = 0,
      final List<Player> players = const <Player>[],
      required this.settings,
      required this.game,
      final String? $type})
      : _players = players,
        $type = $type ?? 'cricket';
  factory CricketMatchState.fromJson(Map<String, dynamic> json) =>
      _$CricketMatchStateFromJson(json);

  @override
  @JsonKey()
  final int currentPlayerIndex;
  final List<Player> _players;
  @override
  @JsonKey()
  List<Player> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  final MatchSettings settings;
  @override
  final CricketGameState game;

  @JsonKey(name: 'type')
  final String $type;

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CricketMatchStateCopyWith<CricketMatchState> get copyWith =>
      _$CricketMatchStateCopyWithImpl<CricketMatchState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CricketMatchStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CricketMatchState &&
            (identical(other.currentPlayerIndex, currentPlayerIndex) ||
                other.currentPlayerIndex == currentPlayerIndex) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.game, game) || other.game == game));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentPlayerIndex,
      const DeepCollectionEquality().hash(_players), settings, game);

  @override
  String toString() {
    return 'MatchState.cricket(currentPlayerIndex: $currentPlayerIndex, players: $players, settings: $settings, game: $game)';
  }
}

/// @nodoc
abstract mixin class $CricketMatchStateCopyWith<$Res>
    implements $MatchStateCopyWith<$Res> {
  factory $CricketMatchStateCopyWith(
          CricketMatchState value, $Res Function(CricketMatchState) _then) =
      _$CricketMatchStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int currentPlayerIndex,
      List<Player> players,
      MatchSettings settings,
      CricketGameState game});

  @override
  $MatchSettingsCopyWith<$Res> get settings;
  $CricketGameStateCopyWith<$Res> get game;
}

/// @nodoc
class _$CricketMatchStateCopyWithImpl<$Res>
    implements $CricketMatchStateCopyWith<$Res> {
  _$CricketMatchStateCopyWithImpl(this._self, this._then);

  final CricketMatchState _self;
  final $Res Function(CricketMatchState) _then;

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentPlayerIndex = null,
    Object? players = null,
    Object? settings = null,
    Object? game = null,
  }) {
    return _then(CricketMatchState(
      currentPlayerIndex: null == currentPlayerIndex
          ? _self.currentPlayerIndex
          : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
              as int,
      players: null == players
          ? _self._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      settings: null == settings
          ? _self.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as MatchSettings,
      game: null == game
          ? _self.game
          : game // ignore: cast_nullable_to_non_nullable
              as CricketGameState,
    ));
  }

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchSettingsCopyWith<$Res> get settings {
    return $MatchSettingsCopyWith<$Res>(_self.settings, (value) {
      return _then(_self.copyWith(settings: value));
    });
  }

  /// Create a copy of MatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CricketGameStateCopyWith<$Res> get game {
    return $CricketGameStateCopyWith<$Res>(_self.game, (value) {
      return _then(_self.copyWith(game: value));
    });
  }
}

/// @nodoc
mixin _$X01GameState {
  Map<String, int> get scores;
  List<DartThrow> get currentTurnThrows;
  String? get winnerPlayerId;

  /// Create a copy of X01GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $X01GameStateCopyWith<X01GameState> get copyWith =>
      _$X01GameStateCopyWithImpl<X01GameState>(
          this as X01GameState, _$identity);

  /// Serializes this X01GameState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is X01GameState &&
            const DeepCollectionEquality().equals(other.scores, scores) &&
            const DeepCollectionEquality()
                .equals(other.currentTurnThrows, currentTurnThrows) &&
            (identical(other.winnerPlayerId, winnerPlayerId) ||
                other.winnerPlayerId == winnerPlayerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(scores),
      const DeepCollectionEquality().hash(currentTurnThrows),
      winnerPlayerId);

  @override
  String toString() {
    return 'X01GameState(scores: $scores, currentTurnThrows: $currentTurnThrows, winnerPlayerId: $winnerPlayerId)';
  }
}

/// @nodoc
abstract mixin class $X01GameStateCopyWith<$Res> {
  factory $X01GameStateCopyWith(
          X01GameState value, $Res Function(X01GameState) _then) =
      _$X01GameStateCopyWithImpl;
  @useResult
  $Res call(
      {Map<String, int> scores,
      List<DartThrow> currentTurnThrows,
      String? winnerPlayerId});
}

/// @nodoc
class _$X01GameStateCopyWithImpl<$Res> implements $X01GameStateCopyWith<$Res> {
  _$X01GameStateCopyWithImpl(this._self, this._then);

  final X01GameState _self;
  final $Res Function(X01GameState) _then;

  /// Create a copy of X01GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scores = null,
    Object? currentTurnThrows = null,
    Object? winnerPlayerId = freezed,
  }) {
    return _then(_self.copyWith(
      scores: null == scores
          ? _self.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      currentTurnThrows: null == currentTurnThrows
          ? _self.currentTurnThrows
          : currentTurnThrows // ignore: cast_nullable_to_non_nullable
              as List<DartThrow>,
      winnerPlayerId: freezed == winnerPlayerId
          ? _self.winnerPlayerId
          : winnerPlayerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [X01GameState].
extension X01GameStatePatterns on X01GameState {
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
    TResult Function(_X01GameState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _X01GameState() when $default != null:
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
    TResult Function(_X01GameState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _X01GameState():
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
    TResult? Function(_X01GameState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _X01GameState() when $default != null:
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
    TResult Function(Map<String, int> scores, List<DartThrow> currentTurnThrows,
            String? winnerPlayerId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _X01GameState() when $default != null:
        return $default(
            _that.scores, _that.currentTurnThrows, _that.winnerPlayerId);
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
    TResult Function(Map<String, int> scores, List<DartThrow> currentTurnThrows,
            String? winnerPlayerId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _X01GameState():
        return $default(
            _that.scores, _that.currentTurnThrows, _that.winnerPlayerId);
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
    TResult? Function(Map<String, int> scores,
            List<DartThrow> currentTurnThrows, String? winnerPlayerId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _X01GameState() when $default != null:
        return $default(
            _that.scores, _that.currentTurnThrows, _that.winnerPlayerId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _X01GameState implements X01GameState {
  const _X01GameState(
      {final Map<String, int> scores = const <String, int>{},
      final List<DartThrow> currentTurnThrows = const <DartThrow>[],
      this.winnerPlayerId})
      : _scores = scores,
        _currentTurnThrows = currentTurnThrows;
  factory _X01GameState.fromJson(Map<String, dynamic> json) =>
      _$X01GameStateFromJson(json);

  final Map<String, int> _scores;
  @override
  @JsonKey()
  Map<String, int> get scores {
    if (_scores is EqualUnmodifiableMapView) return _scores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_scores);
  }

  final List<DartThrow> _currentTurnThrows;
  @override
  @JsonKey()
  List<DartThrow> get currentTurnThrows {
    if (_currentTurnThrows is EqualUnmodifiableListView)
      return _currentTurnThrows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentTurnThrows);
  }

  @override
  final String? winnerPlayerId;

  /// Create a copy of X01GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$X01GameStateCopyWith<_X01GameState> get copyWith =>
      __$X01GameStateCopyWithImpl<_X01GameState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$X01GameStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _X01GameState &&
            const DeepCollectionEquality().equals(other._scores, _scores) &&
            const DeepCollectionEquality()
                .equals(other._currentTurnThrows, _currentTurnThrows) &&
            (identical(other.winnerPlayerId, winnerPlayerId) ||
                other.winnerPlayerId == winnerPlayerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_scores),
      const DeepCollectionEquality().hash(_currentTurnThrows),
      winnerPlayerId);

  @override
  String toString() {
    return 'X01GameState(scores: $scores, currentTurnThrows: $currentTurnThrows, winnerPlayerId: $winnerPlayerId)';
  }
}

/// @nodoc
abstract mixin class _$X01GameStateCopyWith<$Res>
    implements $X01GameStateCopyWith<$Res> {
  factory _$X01GameStateCopyWith(
          _X01GameState value, $Res Function(_X01GameState) _then) =
      __$X01GameStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Map<String, int> scores,
      List<DartThrow> currentTurnThrows,
      String? winnerPlayerId});
}

/// @nodoc
class __$X01GameStateCopyWithImpl<$Res>
    implements _$X01GameStateCopyWith<$Res> {
  __$X01GameStateCopyWithImpl(this._self, this._then);

  final _X01GameState _self;
  final $Res Function(_X01GameState) _then;

  /// Create a copy of X01GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? scores = null,
    Object? currentTurnThrows = null,
    Object? winnerPlayerId = freezed,
  }) {
    return _then(_X01GameState(
      scores: null == scores
          ? _self._scores
          : scores // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      currentTurnThrows: null == currentTurnThrows
          ? _self._currentTurnThrows
          : currentTurnThrows // ignore: cast_nullable_to_non_nullable
              as List<DartThrow>,
      winnerPlayerId: freezed == winnerPlayerId
          ? _self.winnerPlayerId
          : winnerPlayerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$CricketGameState {
  Map<String, Map<int, int>> get marks;
  Map<String, int> get scores;
  String? get winnerPlayerId;

  /// Create a copy of CricketGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CricketGameStateCopyWith<CricketGameState> get copyWith =>
      _$CricketGameStateCopyWithImpl<CricketGameState>(
          this as CricketGameState, _$identity);

  /// Serializes this CricketGameState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CricketGameState &&
            const DeepCollectionEquality().equals(other.marks, marks) &&
            const DeepCollectionEquality().equals(other.scores, scores) &&
            (identical(other.winnerPlayerId, winnerPlayerId) ||
                other.winnerPlayerId == winnerPlayerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(marks),
      const DeepCollectionEquality().hash(scores),
      winnerPlayerId);

  @override
  String toString() {
    return 'CricketGameState(marks: $marks, scores: $scores, winnerPlayerId: $winnerPlayerId)';
  }
}

/// @nodoc
abstract mixin class $CricketGameStateCopyWith<$Res> {
  factory $CricketGameStateCopyWith(
          CricketGameState value, $Res Function(CricketGameState) _then) =
      _$CricketGameStateCopyWithImpl;
  @useResult
  $Res call(
      {Map<String, Map<int, int>> marks,
      Map<String, int> scores,
      String? winnerPlayerId});
}

/// @nodoc
class _$CricketGameStateCopyWithImpl<$Res>
    implements $CricketGameStateCopyWith<$Res> {
  _$CricketGameStateCopyWithImpl(this._self, this._then);

  final CricketGameState _self;
  final $Res Function(CricketGameState) _then;

  /// Create a copy of CricketGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? marks = null,
    Object? scores = null,
    Object? winnerPlayerId = freezed,
  }) {
    return _then(_self.copyWith(
      marks: null == marks
          ? _self.marks
          : marks // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<int, int>>,
      scores: null == scores
          ? _self.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      winnerPlayerId: freezed == winnerPlayerId
          ? _self.winnerPlayerId
          : winnerPlayerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CricketGameState].
extension CricketGameStatePatterns on CricketGameState {
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
    TResult Function(_CricketGameState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CricketGameState() when $default != null:
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
    TResult Function(_CricketGameState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CricketGameState():
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
    TResult? Function(_CricketGameState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CricketGameState() when $default != null:
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
    TResult Function(Map<String, Map<int, int>> marks, Map<String, int> scores,
            String? winnerPlayerId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CricketGameState() when $default != null:
        return $default(_that.marks, _that.scores, _that.winnerPlayerId);
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
    TResult Function(Map<String, Map<int, int>> marks, Map<String, int> scores,
            String? winnerPlayerId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CricketGameState():
        return $default(_that.marks, _that.scores, _that.winnerPlayerId);
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
    TResult? Function(Map<String, Map<int, int>> marks, Map<String, int> scores,
            String? winnerPlayerId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CricketGameState() when $default != null:
        return $default(_that.marks, _that.scores, _that.winnerPlayerId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CricketGameState implements CricketGameState {
  const _CricketGameState(
      {final Map<String, Map<int, int>> marks = const <String, Map<int, int>>{},
      final Map<String, int> scores = const <String, int>{},
      this.winnerPlayerId})
      : _marks = marks,
        _scores = scores;
  factory _CricketGameState.fromJson(Map<String, dynamic> json) =>
      _$CricketGameStateFromJson(json);

  final Map<String, Map<int, int>> _marks;
  @override
  @JsonKey()
  Map<String, Map<int, int>> get marks {
    if (_marks is EqualUnmodifiableMapView) return _marks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_marks);
  }

  final Map<String, int> _scores;
  @override
  @JsonKey()
  Map<String, int> get scores {
    if (_scores is EqualUnmodifiableMapView) return _scores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_scores);
  }

  @override
  final String? winnerPlayerId;

  /// Create a copy of CricketGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CricketGameStateCopyWith<_CricketGameState> get copyWith =>
      __$CricketGameStateCopyWithImpl<_CricketGameState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CricketGameStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CricketGameState &&
            const DeepCollectionEquality().equals(other._marks, _marks) &&
            const DeepCollectionEquality().equals(other._scores, _scores) &&
            (identical(other.winnerPlayerId, winnerPlayerId) ||
                other.winnerPlayerId == winnerPlayerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_marks),
      const DeepCollectionEquality().hash(_scores),
      winnerPlayerId);

  @override
  String toString() {
    return 'CricketGameState(marks: $marks, scores: $scores, winnerPlayerId: $winnerPlayerId)';
  }
}

/// @nodoc
abstract mixin class _$CricketGameStateCopyWith<$Res>
    implements $CricketGameStateCopyWith<$Res> {
  factory _$CricketGameStateCopyWith(
          _CricketGameState value, $Res Function(_CricketGameState) _then) =
      __$CricketGameStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Map<String, Map<int, int>> marks,
      Map<String, int> scores,
      String? winnerPlayerId});
}

/// @nodoc
class __$CricketGameStateCopyWithImpl<$Res>
    implements _$CricketGameStateCopyWith<$Res> {
  __$CricketGameStateCopyWithImpl(this._self, this._then);

  final _CricketGameState _self;
  final $Res Function(_CricketGameState) _then;

  /// Create a copy of CricketGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? marks = null,
    Object? scores = null,
    Object? winnerPlayerId = freezed,
  }) {
    return _then(_CricketGameState(
      marks: null == marks
          ? _self._marks
          : marks // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<int, int>>,
      scores: null == scores
          ? _self._scores
          : scores // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      winnerPlayerId: freezed == winnerPlayerId
          ? _self.winnerPlayerId
          : winnerPlayerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
