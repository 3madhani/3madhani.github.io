import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.description,
    required super.technologies,
    required super.githubUrl,
    super.demoUrl,
    super.imageUrl,
    required super.isFeatured,
    required super.category,
    required super.color,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      githubUrl: json['githubUrl'] as String,
      demoUrl: json['demoUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isFeatured: json['isFeatured'] as bool,
      category: ProjectCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ProjectCategory.all,
      ),
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'technologies': technologies,
      'githubUrl': githubUrl,
      'demoUrl': demoUrl,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
      'category': category.name,
      'color': color,
    };
  }
}
