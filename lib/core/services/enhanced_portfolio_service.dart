// lib/core/services/enhanced_portfolio_service.dart
import '../../feature/portfolio/data/personal_data.dart';
import '../../feature/portfolio/domain/entities/experience.dart';
import '../../feature/portfolio/domain/entities/project.dart';
import '../../feature/portfolio/domain/entities/skill.dart';
import '../services/github_service.dart';
import '../services/project_mapper_service.dart';

class EnhancedPortfolioService {
  final GitHubService _gitHubService = GitHubService();

  List<Experience> getAllExperiences() {
    return personalExperiences;
  }

  Future<List<Project>> getAllProjects() async {
    try {
      final List<Project> allProjects = List.from(cvFeaturedProjects);

      final githubRepos = await _gitHubService.fetchAllRepos();
      final githubProjects = ProjectMapperService.mapGitHubReposToProjects(
        githubRepos,
      );

      for (final githubProject in githubProjects) {
        final isAlreadyFeatured = cvFeaturedProjects.any(
          (featured) =>
              _isSimilarProject(featured.title, githubProject.title) ||
              featured.githubUrl.contains(
                githubProject.githubUrl.split('/').last,
              ),
        );

        if (!isAlreadyFeatured) {
          allProjects.add(githubProject);
        }
      }

      allProjects.sort((a, b) {
        if (a.isFeatured && !b.isFeatured) return -1;
        if (!a.isFeatured && b.isFeatured) return 1;
        return 0;
      });

      return allProjects;
    } catch (e) {
      return cvFeaturedProjects;
    }
  }

  List<Skill> getAllSkills() {
    return personalSkills;
  }

  bool _isSimilarProject(String title1, String title2) {
    final t1 = title1.toLowerCase().replaceAll(' ', '');
    final t2 = title2.toLowerCase().replaceAll(' ', '');
    return t1.contains(t2) || t2.contains(t1);
  }
}
