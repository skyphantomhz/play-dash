import 'package:flutter/gestures.dart';
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
            scrollBehavior: const _PlayDashScrollBehavior(),
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

class _PlayDashScrollBehavior extends MaterialScrollBehavior {
  const _PlayDashScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.all(false),
        trackVisibility: WidgetStateProperty.all(false),
        thickness: WidgetStateProperty.all(2.0),
        radius: const Radius.circular(10),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => const Color(0xFF9FEFFF).withValues(
            alpha: states.contains(WidgetState.hovered) ? 0.24 : 0.12,
          ),
        ),
      ),
      child: Scrollbar(
        controller: details.controller,
        thumbVisibility: false,
        interactive: true,
        radius: const Radius.circular(10),
        thickness: 2.0,
        child: child,
      ),
    );
  }
}
