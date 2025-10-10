class Skill {
  final String name;
  final int level;
  final SkillCategory category;
  final String icon;

  const Skill({
    required this.name,
    required this.level,
    required this.category,
    required this.icon,
  });
}

enum SkillCategory { frontend, backend, mobile, tools, design }
