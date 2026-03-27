import 'package:flutter_test/flutter_test.dart';
import 'package:play_dash_app/app/app.dart';

void main() {
  testWidgets('home page shows primary navigation actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PlayDashApp());
    await tester.pumpAndSettle();

    expect(find.text('Choose a game mode'), findsOneWidget);
    expect(find.text('Player Setup'), findsOneWidget);
    expect(find.text('Play X01'), findsOneWidget);
    expect(find.text('Play Cricket'), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
  });
}
