import 'package:flutter/material.dart';

import '../shared/widgets/app_shell.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PlayDashApp extends StatelessWidget {
  const PlayDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Play Dash',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
      builder: (context, child) => AppBackdrop(
        child: child ?? const SizedBox.shrink(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
