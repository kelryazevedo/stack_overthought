import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:stack_overthought/core/app_router/routes.dart';
import 'package:stack_overthought/core/ui_core/app_localizations.dart';
import 'package:stack_overthought/core/ui_core/app_theme.dart';
import 'package:stack_overthought/feature/controller/stack_overthought_cubit.dart';
import 'package:stack_overthought/feature/pages/home/home_screen.dart';
import 'package:stack_overthought/feature/pages/notes/create_note.dart';
import 'package:stack_overthought/feature/pages/notes/edit_note.dart';
import 'package:stack_overthought/feature/pages/splash_screen.dart';
import 'package:stack_overthought/repository/api/stack_overthought_api.dart';
import 'package:stack_overthought/repository/stack_overthought_contract.dart';

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
        GoRoute(path: Routes.splash, builder: (_, __) => const SplashScreen()),
        GoRoute(path: Routes.home, builder: (_, __) => const HomePage()),
        GoRoute(
          path: Routes.createNote,
          builder: (_, __) => const CreateNotePage(),
        ),
        GoRoute(path: Routes.editNote, builder: (_, __) => const EditNote()),
      ],
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => StackOverthoughtApi(client: Client()),
        ),

        RepositoryProvider(
          create: (context) =>
              StackOverthoughtRepository(context.read<StackOverthoughtApi>()),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            StackOverthoughtCubit(context.read<StackOverthoughtRepository>()),
        child: MaterialApp.router(
          title: 'Stack Overthought',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.appTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
  }
}
