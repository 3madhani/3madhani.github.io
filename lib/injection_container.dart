import 'package:get_it/get_it.dart';

import 'feature/portfolio/data/datasources/portfolio_local_datasource.dart';
import 'feature/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'feature/portfolio/domain/repositories/portfolio_repository.dart';
import 'feature/portfolio/domain/usecases/get_experience.dart';
import 'feature/portfolio/domain/usecases/get_projects.dart';
import 'feature/portfolio/domain/usecases/get_skills.dart';
import 'feature/portfolio/presentation/bloc/portfolio_bloc/portfolio_bloc.dart';
import 'feature/portfolio/presentation/bloc/theme_cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () =>
        PortfolioBloc(getProjects: sl(), getSkills: sl(), getExperience: sl()),
  );

  sl.registerLazySingleton(() => ThemeCubit());

  // Use cases
  sl.registerLazySingleton(() => GetProjects(sl()));
  sl.registerLazySingleton(() => GetSkills(sl()));
  sl.registerLazySingleton(() => GetExperience(sl()));

  // Repository
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PortfolioLocalDatasource>(
    () => PortfolioLocalDatasource(),
  );
}
