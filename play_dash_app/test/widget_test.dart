import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:play_dash_app/app/app.dart';
import 'package:play_dash_app/features/setup/presentation/setup_page.dart';
import 'package:play_dash_app/features/x01/application/x01_controller.dart';
import 'package:play_dash_app/features/x01/presentation/x01_game_page.dart';
import 'package:play_dash_app/shared/widgets/app_shell.dart';

void main() {
  testWidgets('home page shows primary glass navigation actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PlayDashApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('CRICKET'), findsOneWidget);
    expect(find.text('X01'), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('Quick Setup'), findsOneWidget);
    expect(find.byType(NeonCard), findsWidgets);
  });

  testWidgets('continue starts an X01 match with setup player names', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(_TestHarness(container: container));
    await tester.pump(const Duration(milliseconds: 200));

    final playerOneField = find.byType(TextField).at(0);
    final playerTwoField = find.byType(TextField).at(1);

    await tester.enterText(playerOneField, 'Alice');
    await tester.enterText(playerTwoField, 'Bob');
    await _tapStartGame(tester);

    final matchState = container.read(x01ControllerProvider);
    expect(
      matchState.players.map((player) => player.name).toList(),
      ['Alice', 'Bob', 'Camme Davis', 'Sarah Williams'],
    );
    expect(matchState.currentPlayerIndex, 0);
  });

  testWidgets('continue falls back to default names for blank players', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(_TestHarness(container: container));
    await tester.pump(const Duration(milliseconds: 200));

    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.enterText(find.byType(TextField).at(1), '');
    await _tapStartGame(tester);

    final matchState = container.read(x01ControllerProvider);
    expect(
      matchState.players.map((player) => player.name).toList(),
      ['Player 1', 'Player 2', 'Camme Davis', 'Sarah Williams'],
    );
  });
}

Future<void> _tapStartGame(WidgetTester tester) async {
  final startGameButton = find.text('Start Game').last;
  await tester.ensureVisible(startGameButton);
  await tester.tap(startGameButton);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
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
