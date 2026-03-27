import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:play_dash_app/features/cricket/application/cricket_controller.dart';
import 'package:play_dash_app/features/x01/application/x01_controller.dart';
import 'package:play_dash_app/shared/models/dart_throw.dart';
import 'package:play_dash_app/shared/models/match_settings.dart';

void main() {
  test('x01 undo restores score and current turn state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final controller = container.read(x01ControllerProvider.notifier);

    controller.addThrow(const DartThrow(segment: 20, multiplier: 3));

    final afterThrow = container.read(x01ControllerProvider);
    final startingScore =
        (afterThrow.settings as X01MatchSettings).startingScore;
    expect(afterThrow.game.scores['player-1'], startingScore - 60);
    expect(afterThrow.game.currentTurnThrows, hasLength(1));
    expect(container.read(x01CanUndoProvider), isTrue);

    controller.undo();

    final undone = container.read(x01ControllerProvider);
    expect(undone.game.scores['player-1'], startingScore);
    expect(undone.game.currentTurnThrows, isEmpty);
    expect(container.read(x01CanUndoProvider), isFalse);
  });

  test('cricket undo restores marks and player turn', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final controller = container.read(cricketControllerProvider.notifier);

    controller.addThrow(const DartThrow(segment: 20, multiplier: 3));

    final afterThrow = container.read(cricketControllerProvider);
    expect(afterThrow.game.marks['player-1']?[20], 3);
    expect(afterThrow.currentPlayerIndex, 1);
    expect(container.read(cricketCanUndoProvider), isTrue);

    controller.undo();

    final undone = container.read(cricketControllerProvider);
    expect(undone.game.marks['player-1']?[20], 0);
    expect(undone.currentPlayerIndex, 0);
    expect(container.read(cricketCanUndoProvider), isFalse);
  });
}
