class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String githubUrl;
  final String? demoUrl;
  final String? imageUrl;
  final bool isFeatured;
  final ProjectCategory category;
  final String color;

  const Project({
    required this.title,
    required this.description,
    required this.technologies,
    required this.githubUrl,
    this.demoUrl,
    this.imageUrl,
    required this.isFeatured,
    required this.category,
    required this.color,
  });
}

enum ProjectCategory { mobile, web, all, featured }
