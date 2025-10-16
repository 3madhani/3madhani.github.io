// lib/injection_container.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'core/services/enhanced_portfolio_service.dart';
import 'core/services/github_service.dart';
import 'feature/portfolio/presentation/bloc/portfolio_bloc/portfolio_bloc.dart';
import 'feature/portfolio/presentation/bloc/theme_cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await dotenv.load(fileName: '.env');
  final token = dotenv.env['GITHUB_TOKEN'];
  // Services
  sl.registerLazySingleton(() => GitHubService(token: token));
  sl.registerLazySingleton(() => EnhancedPortfolioService(sl<GitHubService>()));

  // BLoCs
  sl.registerFactory(
    () => PortfolioBloc(portfolioService: sl<EnhancedPortfolioService>()),
  );
  sl.registerLazySingleton(() => ThemeCubit());
}
