import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:play_dash_app/app/app.dart';
import 'package:play_dash_app/features/setup/presentation/setup_page.dart';
import 'package:play_dash_app/features/x01/application/x01_controller.dart';
import 'package:play_dash_app/features/x01/presentation/x01_game_page.dart';

void main() {
  testWidgets('home page shows primary navigation actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PlayDashApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choose a game mode'), findsOneWidget);
    expect(find.text('Player Setup'), findsOneWidget);
    expect(find.text('Play X01'), findsOneWidget);
    expect(find.text('Play Cricket'), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
  });

  testWidgets('continue starts an X01 match with setup player names', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(_TestHarness(container: container));
    await tester.pumpAndSettle();

    final playerOneField = find.byType(TextField).at(0);
    final playerTwoField = find.byType(TextField).at(1);

    await tester.enterText(playerOneField, 'Alice');
    await tester.enterText(playerTwoField, 'Bob');
    await _tapContinue(tester);

    final matchState = container.read(x01ControllerProvider);
    expect(matchState.players.map((player) => player.name), ['Alice', 'Bob']);
    expect(matchState.currentPlayerIndex, 0);
  });

  testWidgets('continue falls back to default names for blank players', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(_TestHarness(container: container));
    await tester.pumpAndSettle();

    final playerTwoField = find.byType(TextField).at(1);
    await tester.enterText(playerTwoField, '');
    await _tapContinue(tester);

    final matchState = container.read(x01ControllerProvider);
    expect(matchState.players.map((player) => player.name),
        ['Player 1', 'Player 2']);
  });
}

Future<void> _tapContinue(WidgetTester tester) async {
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

class _TestHarness extends StatelessWidget {
  _TestHarness({required this.container});

  final ProviderContainer container;
  late final GoRouter _router = GoRouter(
    initialLocation: '/setup',
    routes: <RouteBase>[
      GoRoute(
        path: '/setup',
        builder: (BuildContext context, GoRouterState state) =>
            const SetupScreen(),
      ),
      GoRoute(
        path: '/match/x01',
        builder: (BuildContext context, GoRouterState state) =>
            const X01GamePage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}
