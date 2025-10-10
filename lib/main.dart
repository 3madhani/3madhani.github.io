import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/themes/app_theme.dart';
import 'feature/portfolio/presentation/bloc/portfolio_bloc/portfolio_bloc.dart';
import 'feature/portfolio/presentation/bloc/portfolio_bloc/portfolio_event.dart';
import 'feature/portfolio/presentation/bloc/theme_cubit/theme_cubit.dart';
import 'feature/portfolio/presentation/bloc/theme_cubit/theme_state.dart';
import 'feature/portfolio/presentation/pages/home_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => GetIt.instance<ThemeCubit>()..loadTheme(),
        ),
        BlocProvider<PortfolioBloc>(
          create: (_) =>
              GetIt.instance<PortfolioBloc>()..add(const LoadPortfolioData()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Flutter Magician Portfolio',
            debugShowCheckedModeBanner: false,
            themeMode: themeState.themeMode,
            theme: AppTheme.lightTheme(themeState.seedColor),
            darkTheme: AppTheme.darkTheme(themeState.seedColor),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
