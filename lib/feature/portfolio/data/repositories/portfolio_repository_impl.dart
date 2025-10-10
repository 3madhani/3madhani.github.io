import '../../domain/entities/experience.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/skill.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_datasource.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDatasource localDataSource;

  PortfolioRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Experience>> getExperience() async {
    return await localDataSource.getExperience();
  }

  @override
  Future<List<Project>> getProjects() async {
    return await localDataSource.getProjects();
  }

  @override
  Future<List<Skill>> getSkills() async {
    return await localDataSource.getSkills();
  }
}
