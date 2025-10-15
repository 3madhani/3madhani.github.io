import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubService {
  static const String baseUrl = 'https://api.github.com';
  final String username = '3madhani';

  Future<List<GitHubRepo>> fetchAllRepos() async {
    try {
      final List<GitHubRepo> allRepos = [];
      int page = 1;

      while (true) {
        final response = await http.get(
          Uri.parse(
            '$baseUrl/users/$username/repos?sort=updated&per_page=100&page=$page',
          ),
          headers: {'Accept': 'application/vnd.github.v3+json'},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          if (data.isEmpty) break;

          final repos = data
              .where(
                (repo) =>
                    !repo['private'] && repo['name'] != '3madhani.github.io',
              )
              .map((repo) => GitHubRepo.fromJson(repo))
              .toList();

          allRepos.addAll(repos);
          page++;
        } else {
          throw Exception(
            'Failed to load repositories: ${response.statusCode}',
          );
        }
      }

      return allRepos;
    } catch (e) {
      throw Exception('Error fetching GitHub repos: $e');
    }
  }
}

class GitHubRepo {
  final String name;
  final String description;
  final String? language;
  final String htmlUrl;
  final String? homepageUrl;
  final List<String> topics;
  final DateTime updatedAt;
  final int stargazersCount;
  final int forksCount;

  GitHubRepo({
    required this.name,
    required this.description,
    this.language,
    required this.htmlUrl,
    this.homepageUrl,
    required this.topics,
    required this.updatedAt,
    required this.stargazersCount,
    required this.forksCount,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      name: json['name'] ?? '',
      description: json['description'] ?? 'No description available',
      language: json['language'],
      htmlUrl: json['html_url'] ?? '',
      homepageUrl: json['homepage']?.isEmpty == true ? null : json['homepage'],
      topics: List<String>.from(json['topics'] ?? []),
      updatedAt: DateTime.parse(json['updated_at']),
      stargazersCount: json['stargazers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
    );
  }
}
