import 'package:flutter/material.dart';

import '../shared/widgets/app_shell.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class PlayDashApp extends StatelessWidget {
  const PlayDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const AppBackdrop(child: SizedBox.expand()),
          MaterialApp.router(
            title: 'Play Dash',
            theme: AppTheme.light.copyWith(
              scaffoldBackgroundColor: Colors.transparent,
              canvasColor: Colors.transparent,
            ),
            darkTheme: AppTheme.dark.copyWith(
              scaffoldBackgroundColor: Colors.transparent,
              canvasColor: Colors.transparent,
            ),
            themeMode: ThemeMode.dark,
            routerConfig: appRouter,
            builder: (context, child) => ColoredBox(
              color: Colors.transparent,
              child: child ?? const SizedBox.shrink(),
            ),
            debugShowCheckedModeBanner: false,
          ),
        ],
      ),
    );
  }
}
