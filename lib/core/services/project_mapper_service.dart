import '../../feature/portfolio/domain/entities/project.dart';
import '../services/github_service.dart';

class ProjectMapperService {
  static final List<String> _knownTechnologies = [
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
    return repos.map((repo) => _mapSingleRepo(repo)).toList();
  }

  static ProjectCategory _determineCategory(
    String? language,
    List<String> topics,
  ) {
    if (topics.contains('flutter') ||
        topics.contains('mobile') ||
        topics.contains('android') ||
        topics.contains('ios')) {
      return ProjectCategory.mobile;
    }
    if (topics.contains('web') ||
        topics.contains('frontend') ||
        topics.contains('html') ||
        topics.contains('css')) {
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
    final Set<String> techs = {};

    if (language != null) {
      techs.add(_formatTechName(language));
    }

    final techTopics = topics.where(
      (topic) => _knownTechnologies.contains(topic.toLowerCase()),
    );

    techs.addAll(techTopics.map((t) => _formatTechName(t)));

    return techs.take(6).toList();
  }

  static String _formatTechName(String tech) {
    switch (tech.toLowerCase()) {
      case 'nodejs':
        return 'Node.js';
      case 'flutter':
        return 'Flutter';
      case 'react':
        return 'React';
      case 'MVVM':
        return 'MVVM';
      case 'bloc':
        return 'BLoC';
      case 'postgresql':
        return 'PostgreSQL';
      case 'mongodb':
        return 'MongoDB';
      case 'clean-architecture':
        return 'Clean Architecture';
      default:
        return tech.substring(0, 1).toUpperCase() + tech.substring(1);
    }
  }

  static String _formatTitle(String repoName) {
    return repoName
        .split('_')
        .map((word) => word.split('-'))
        .expand((words) => words)
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  static String _getLanguageColor(String? language) {
    switch (language?.toLowerCase()) {
      case 'dart':
        return '#0175C2';
      case 'javascript':
        return '#F7DF1E';
      case 'typescript':
        return '#3178C6';
      case 'python':
        return '#3776AB';
      case 'java':
        return '#ED8B00';
      case 'kotlin':
        return '#7F52FF';
      case 'swift':
        return '#FA7343';
      case 'html':
        return '#E34F26';
      case 'css':
        return '#1572B6';
      case 'vue':
        return '#4FC08D';
      case 'react':
        return '#61DAFB';
      default:
        return '#6366F1';
    }
  }

  static bool _isFeaturedProject(GitHubRepo repo) {
    if (repo.stargazersCount > 0) return true;
    if (repo.homepageUrl != null) return true;
    if (repo.topics.contains('flutter')) return true;
    if (repo.topics.contains('featured')) return true;

    final featuredNames = [
      'fruit_hub',
      'bookly',
      'talkverse',
      'flavodish',
      'social_posts',
      'portfolio',
    ];

    return featuredNames.any(
      (name) => repo.name.toLowerCase().contains(name.toLowerCase()),
    );
  }

  static Project _mapSingleRepo(GitHubRepo repo) {
    final category = _determineCategory(repo.language, repo.topics);
    final isFeatured = _isFeaturedProject(repo);
    final color = _getLanguageColor(repo.language);
    final technologies = _extractTechnologies(repo.language, repo.topics);

    return Project(
      title: _formatTitle(repo.name),
      description: repo.description,
      category: category,
      githubUrl: repo.htmlUrl,
      demoUrl: repo.homepageUrl,
      technologies: technologies,
      isFeatured: isFeatured,
      color: color,
    );
  }
}
