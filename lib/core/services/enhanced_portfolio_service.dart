import '../../feature/portfolio/data/personal_data.dart';
import '../../feature/portfolio/domain/entities/experience.dart';
import '../../feature/portfolio/domain/entities/project.dart';
import '../../feature/portfolio/domain/entities/skill.dart';
import '../services/github_service.dart';
import '../services/project_mapper_service.dart';

class EnhancedPortfolioService {
  final GitHubService _gitHubService;

  EnhancedPortfolioService(this._gitHubService);

  List<Experience> getAllExperiences() {
    return personalExperiences;
  }

  Future<List<Project>> getAllProjects() async {
    try {
      final repos = await _gitHubService.fetchAllRepos();
      final projects = ProjectMapperService.mapGitHubReposToProjects(repos);
      projects.sort((a, b) {
        if (a.isFeatured && !b.isFeatured) return -1;
        if (!a.isFeatured && b.isFeatured) return 1;
        return 0;
      });
      return projects;
    } catch (e) {
      return cvFeaturedProjects;
    }
  }

  List<Skill> getAllSkills() {
    return personalSkills;
  }
}
