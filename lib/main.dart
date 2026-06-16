import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stack_overthought/core/app_router/routes.dart';
import 'package:stack_overthought/core/ui_core/app_localizations.dart';
import 'package:stack_overthought/core/ui_core/app_theme.dart';
import 'package:stack_overthought/feature/pages/create_note_screen.dart';
import 'package:stack_overthought/feature/pages/home_screen.dart';
import 'package:stack_overthought/feature/pages/splash_screen.dart';
import 'package:stack_overthought/model/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: Routes.splash,
      routes: [
        GoRoute(
          path: Routes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: Routes.createNote,
          builder: (context, state) {
            final initial = state.extra as Note?;
            return CreateNotePage(initialNote: initial);
          },
        ),
      ],
    );
    return MaterialApp.router(
      title: 'Stack Overthought',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
