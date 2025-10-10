import '../entities/experience.dart';
import '../repositories/portfolio_repository.dart';

class GetExperience {
  final PortfolioRepository repository;

  GetExperience(this.repository);

  Future<List<Experience>> call() async {
    return await repository.getExperience();
  }
}
