import '../../domain/entities/skill.dart';

class SkillModel extends Skill {
  const SkillModel({
    required super.name,
    required super.level,
    required super.category,
    required super.icon,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'] as String,
      level: json['level'] as int,
      category: SkillCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => SkillCategory.frontend,
      ),
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
      'category': category.name,
      'icon': icon,
    };
  }
}
