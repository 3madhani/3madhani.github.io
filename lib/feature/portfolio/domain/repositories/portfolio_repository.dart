import '../entities/project.dart';
import '../entities/skill.dart';
import '../entities/experience.dart';

abstract class PortfolioRepository {
  Future<List<Project>> getProjects();
  Future<List<Skill>> getSkills();
  Future<List<Experience>> getExperience();
}
