import '../../../shared/models/dart_throw.dart';
import '../../../shared/models/match_settings.dart';

class X01TurnResult {
  const X01TurnResult({
    required this.startingScore,
    required this.endingScore,
    required this.pointsScored,
    required this.bust,
    required this.finished,
    required this.countedThrows,
  });

  final int startingScore;
  final int endingScore;
  final int pointsScored;
  final bool bust;
  final bool finished;
  final List<DartThrow> countedThrows;
}

class X01Engine {
  const X01Engine._();

  static X01TurnResult applyTurn({
    required int currentScore,
    required List<DartThrow> throws,
    required X01MatchSettings settings,
  }) {
    final countedThrows = <DartThrow>[];
    var score = currentScore;
    var hasOpenedScoring =
        !settings.doubleIn || currentScore != settings.startingScore;

    for (final dartThrow in throws) {
      if (!hasOpenedScoring) {
        if (_isDouble(dartThrow)) {
          hasOpenedScoring = true;
        } else {
          continue;
        }
      }

      final throwScore = _scoreFor(dartThrow);
      final remaining = score - throwScore;

      if (remaining < 0) {
        return _bustResult(
          startingScore: currentScore,
          countedThrows: countedThrows,
        );
      }

      if (remaining == 0) {
        if (settings.doubleOut && !_isDouble(dartThrow)) {
          return _bustResult(
            startingScore: currentScore,
            countedThrows: countedThrows,
          );
        }

        countedThrows.add(dartThrow);
        return X01TurnResult(
          startingScore: currentScore,
          endingScore: 0,
          pointsScored: currentScore,
          bust: false,
          finished: true,
          countedThrows: List.unmodifiable(countedThrows),
        );
      }

      if (settings.doubleOut && remaining == 1) {
        return _bustResult(
          startingScore: currentScore,
          countedThrows: countedThrows,
        );
      }

      score = remaining;
      countedThrows.add(dartThrow);
    }

    return X01TurnResult(
      startingScore: currentScore,
      endingScore: score,
      pointsScored: currentScore - score,
      bust: false,
      finished: score == 0,
      countedThrows: List.unmodifiable(countedThrows),
    );
  }

  static X01TurnResult _bustResult({
    required int startingScore,
    required List<DartThrow> countedThrows,
  }) {
    return X01TurnResult(
      startingScore: startingScore,
      endingScore: startingScore,
      pointsScored: 0,
      bust: true,
      finished: false,
      countedThrows: List.unmodifiable(countedThrows),
    );
  }

  static int _scoreFor(DartThrow dartThrow) =>
      dartThrow.segment * dartThrow.multiplier;

  static bool _isDouble(DartThrow dartThrow) =>
      dartThrow.multiplier == 2 ||
      (dartThrow.segment == 25 && dartThrow.multiplier == 2);
}
