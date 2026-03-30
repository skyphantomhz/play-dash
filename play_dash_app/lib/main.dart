import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'shared/services/feedback_service.dart';
import 'core/services/history_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FeedbackService.instance.init();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const PlayDashApp(),
    ),
  );
}
