import '../../../shared/models/dart_throw.dart';

class CricketThrowResult {
  const CricketThrowResult({
    required this.updatedMarks,
    required this.segment,
    required this.marksAdded,
    required this.overflowMarks,
    required this.scoreAdded,
    required this.closed,
  });

  final Map<int, int> updatedMarks;
  final int segment;
  final int marksAdded;
  final int overflowMarks;
  final int scoreAdded;
  final bool closed;
}

class CricketEngine {
  const CricketEngine._();

  static const List<int> scoringSegments = <int>[15, 16, 17, 18, 19, 20, 25];

  static CricketThrowResult applyThrow({
    required Map<int, int> currentMarks,
    required DartThrow dartThrow,
    bool scoreOverflow = false,
  }) {
    final segment = dartThrow.segment;
    final updatedMarks = Map<int, int>.from(currentMarks);

    if (!scoringSegments.contains(segment)) {
      return CricketThrowResult(
        updatedMarks: updatedMarks,
        segment: segment,
        marksAdded: 0,
        overflowMarks: 0,
        scoreAdded: 0,
        closed: (updatedMarks[segment] ?? 0) >= 3,
      );
    }

    final current = ((updatedMarks[segment] ?? 0).clamp(0, 3) as num).toInt();
    final attemptedMarks = (dartThrow.multiplier.clamp(0, 3) as num).toInt();
    final next = ((current + attemptedMarks).clamp(0, 3) as num).toInt();
    final marksAdded = next - current;
    final overflowMarks = attemptedMarks - marksAdded;

    updatedMarks[segment] = next;

    return CricketThrowResult(
      updatedMarks: Map.unmodifiable(updatedMarks),
      segment: segment,
      marksAdded: marksAdded,
      overflowMarks: overflowMarks,
      scoreAdded: scoreOverflow ? overflowMarks * _segmentValue(segment) : 0,
      closed: next >= 3,
    );
  }

  static int _segmentValue(int segment) => segment == 25 ? 25 : segment;
}
