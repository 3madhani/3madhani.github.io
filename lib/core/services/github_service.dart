// lib/core/services/github_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

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
  final String? imageUrl;

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
    this.imageUrl,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      name: json['name'] ?? '',
      description: json['description'] ?? 'No description available',
      language: json['language'],
      htmlUrl: json['html_url'] ?? '',
      homepageUrl: (json['homepage'] as String?)?.isEmpty == true
          ? null
          : json['homepage'],
      topics: List<String>.from(json['topics'] ?? []),
      updatedAt: DateTime.parse(json['updated_at']),
      stargazersCount: json['stargazers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
    );
  }

  GitHubRepo copyWith({String? homepageUrl, String? imageUrl}) {
    return GitHubRepo(
      name: name,
      description: description,
      language: language,
      htmlUrl: htmlUrl,
      homepageUrl: homepageUrl ?? this.homepageUrl,
      topics: topics,
      updatedAt: updatedAt,
      stargazersCount: stargazersCount,
      forksCount: forksCount,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class GitHubService {
  static const String baseUrl = 'https://api.github.com';
  static const String username = "3madhani";
  final String? token;

  GitHubService({this.token});

  Map<String, String> get _headers {
    final headers = {'Accept': 'application/vnd.github.mercy-preview+json'};
    if (token != null && token!.isNotEmpty) {
      headers['Authorization'] = 'token $token';
    }
    return headers;
  }

  Future<List<GitHubRepo>> fetchAllRepos() async {
    final List<GitHubRepo> allRepos = [];
    int page = 1;
    while (true) {
      final uri = Uri.parse(
        '$baseUrl/users/$username/repos?per_page=50&page=$page&sort=updated',
      );
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode == 403) {
        throw Exception('Rate limit exceeded – authenticate with a token');
      }
      if (res.statusCode != 200) break;

      final data = json.decode(res.body) as List<dynamic>;
      if (data.isEmpty) break;
      for (final jsonRepo in data) {
        if (jsonRepo['private'] == false &&
            jsonRepo['name'] != '$username.github.io') {
          var repo = GitHubRepo.fromJson(jsonRepo);
          repo = await _enrichRepoWithMetadata(repo);
          allRepos.add(repo);
        }
      }
      page++;
    }
    return allRepos;
  }

  Future<GitHubRepo> _enrichRepoWithMetadata(GitHubRepo repo) async {
    final demoUrl = await _extractDemoUrlFromReadme(repo.name);
    final imageUrl = _generateImageUrl(repo.name);
    return repo.copyWith(
      homepageUrl: demoUrl ?? repo.homepageUrl,
      imageUrl: imageUrl,
    );
  }

  Future<String?> _extractDemoUrlFromReadme(String repoName) async {
    final uri = Uri.parse('$baseUrl/repos/$username/$repoName/readme');
    final res = await http.get(
      uri,
      headers: {'Accept': 'application/vnd.github.v3.raw'},
    );
    if (res.statusCode != 200) return null;
    final readme = res.body;
    final demoRegex = RegExp(
      r'\[(?:Live\s*Demo|Demo|Preview|Live|App)\]\(([^)]+)\)',
      caseSensitive: false,
    );
    final match = demoRegex.firstMatch(readme);
    if (match != null) {
      final url = match.group(1)!;
      if (url.startsWith('http')) return url;
    }
    final urlRegex = RegExp(r'https?://[^\s\)]+');
    for (final m in urlRegex.allMatches(readme)) {
      final url = m.group(0)!;
      if (url.contains('demo') ||
          url.contains('vercel') ||
          url.contains('netlify') ||
          url.contains('web.app') ||
          url.contains('github.io') ||
          url.contains('linkedin.com')) {
        return url;
      }
    }
    return null;
  }

  String _generateImageUrl(String repoName) {
    const imagePaths = [
      'images/cover.png',
      'images/cover.jpg',
      'cover.png',
      'cover.jpg',
      'screenshot.png',
      'demo.gif',
      'images/demo.gif',
    ];
    return 'https://raw.githubusercontent.com/$username/$repoName/main/${imagePaths.first}';
  }
}
