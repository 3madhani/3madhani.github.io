// lib/core/services/project_mapper_service.dart
import '../../feature/portfolio/domain/entities/project.dart';
import '../services/github_service.dart';

class ProjectMapperService {
  static const _knownTechnologies = [
    'flutter',
    'react',
    'vue',
    'nodejs',
    'firebase',
    'mongodb',
    'postgresql',
    'docker',
    'kubernetes',
    'aws',
    'gcp',
    'azure',
    'android',
    'ios',
    'web',
    'api',
    'rest',
    'graphql',
    'bloc',
    'provider',
    'getx',
    'hive',
    'dio',
    'clean-architecture',
  ];

  static List<Project> mapGitHubReposToProjects(List<GitHubRepo> repos) {
    return repos.map(_mapSingleRepo).toList();
  }

  static Project _mapSingleRepo(GitHubRepo repo) {
    final isFeatured = repo.topics.contains('featured');
    final category = _determineCategory(repo.language, repo.topics);
    final color = _getLanguageColor(repo.language);
    final technologies = _extractTechnologies(repo.language, repo.topics);

    return Project(
      title: _formatTitle(repo.name),
      description: repo.description,
      category: category,
      githubUrl: repo.htmlUrl,
      demoUrl: repo.homepageUrl,
      imageUrl: repo.imageUrl,
      technologies: technologies,
      isFeatured: isFeatured,
      color: color,
    );
  }

  static ProjectCategory _determineCategory(
    String? language,
    List<String> topics,
  ) {
    if (topics.any(
      (t) => ['flutter', 'mobile', 'android', 'ios'].contains(t.toLowerCase()),
    )) {
      return ProjectCategory.mobile;
    }
    if (topics.any(
      (t) => ['web', 'frontend', 'html', 'css'].contains(t.toLowerCase()),
    )) {
      return ProjectCategory.web;
    }
    switch (language?.toLowerCase()) {
      case 'dart':
        return ProjectCategory.mobile;
      case 'javascript':
      case 'typescript':
      case 'html':
      case 'css':
      case 'vue':
      case 'react':
        return ProjectCategory.web;
      default:
        return ProjectCategory.all;
    }
  }

  static List<String> _extractTechnologies(
    String? language,
    List<String> topics,
  ) {
    final techs = <String>{};
    if (language != null) techs.add(_formatTechName(language));
    techs.addAll(
      topics
          .where((t) => _knownTechnologies.contains(t.toLowerCase()))
          .map(_formatTechName),
    );
    return techs.take(6).toList();
  }

  static String _formatTechName(String tech) {
    switch (tech.toLowerCase()) {
      case 'nodejs':
        return 'Node.js';
      case 'bloc':
        return 'BLoC';
      case 'clean-architecture':
        return 'Clean Architecture';
      default:
        return tech[0].toUpperCase() + tech.substring(1);
    }
  }

  static String _getLanguageColor(String? language) {
    switch (language?.toLowerCase()) {
      case 'dart':
        return '#0175C2';
      case 'javascript':
        return '#F7DF1E';
      case 'python':
        return '#3776AB';
      case 'html':
        return '#E34F26';
      default:
        return '#6366F1';
    }
  }

  static String _formatTitle(String repoName) {
    return repoName
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (w) => w.isEmpty
              ? ''
              : w[0].toUpperCase() + w.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}
