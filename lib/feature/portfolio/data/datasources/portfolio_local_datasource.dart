import '../../domain/entities/project.dart';
import '../../domain/entities/skill.dart';
import '../models/project_model.dart';
import '../models/skill_model.dart';
import '../../domain/entities/experience.dart';

class PortfolioLocalDatasource {
  Future<List<ProjectModel>> getProjects() async {
    // Simulate loading from local JSON or assets
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const ProjectModel(
        id: '1',
        title: 'E-commerce Flutter App',
        description:
            'A complete e-commerce solution built with Flutter, featuring user authentication, product catalog, shopping cart, and payment integration.',
        technologies: ['Flutter', 'Dart', 'Firebase', 'Stripe'],
        githubUrl: 'https://github.com/example/ecommerce-app',
        demoUrl: 'https://demo.example.com',
        isFeatured: true,
        category: ProjectCategory.mobile,
        color: '#FF6B35',
      ),
      const ProjectModel(
        id: '2',
        title: 'Task Management Web App',
        description:
            'A responsive web application for task management with real-time collaboration features and advanced filtering options.',
        technologies: ['Flutter Web', 'Dart', 'WebSockets', 'REST API'],
        githubUrl: 'https://github.com/example/task-manager',
        demoUrl: 'https://tasks.example.com',
        isFeatured: true,
        category: ProjectCategory.web,
        color: '#4ECDC4',
      ),
      const ProjectModel(
        id: '3',
        title: 'Fitness Tracker Mobile App',
        description:
            'A comprehensive fitness tracking application with workout plans, progress tracking, and social features.',
        technologies: ['Flutter', 'Dart', 'SQLite', 'Health APIs'],
        githubUrl: 'https://github.com/example/fitness-tracker',
        isFeatured: false,
        category: ProjectCategory.mobile,
        color: '#45B7D1',
      ),
      const ProjectModel(
        id: '4',
        title: 'Portfolio Website',
        description:
            'A responsive portfolio website built with Flutter Web showcasing projects and skills with magical animations.',
        technologies: [
          'Flutter Web',
          'Dart',
          'Animations',
          'Responsive Design',
        ],
        githubUrl: 'https://github.com/example/portfolio',
        demoUrl: 'https://portfolio.example.com',
        isFeatured: true,
        category: ProjectCategory.web,
        color: '#96CEB4',
      ),
    ];
  }

  Future<List<SkillModel>> getSkills() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      const SkillModel(
        name: 'Flutter',
        level: 98,
        category: SkillCategory.frontend,
        icon: 'fab fa-flutter',
      ),
      const SkillModel(
        name: 'Dart',
        level: 95,
        category: SkillCategory.frontend,
        icon: 'fas fa-code',
      ),
      const SkillModel(
        name: 'Firebase',
        level: 90,
        category: SkillCategory.backend,
        icon: 'fas fa-fire',
      ),
      const SkillModel(
        name: 'UI/UX Design',
        level: 85,
        category: SkillCategory.design,
        icon: 'fas fa-palette',
      ),
      const SkillModel(
        name: 'REST APIs',
        level: 88,
        category: SkillCategory.backend,
        icon: 'fas fa-database',
      ),
      const SkillModel(
        name: 'Git',
        level: 92,
        category: SkillCategory.tools,
        icon: 'fab fa-git-alt',
      ),
      const SkillModel(
        name: 'Android',
        level: 87,
        category: SkillCategory.mobile,
        icon: 'fas fa-mobile-alt',
      ),
      const SkillModel(
        name: 'iOS',
        level: 83,
        category: SkillCategory.mobile,
        icon: 'fas fa-mobile-alt',
      ),
    ];
  }

  Future<List<Experience>> getExperience() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return [
      const Experience(
        company: 'Tech Innovators Inc.',
        position: 'Senior Flutter Developer',
        duration: '2022 - Present',
        description:
            'Leading Flutter development team and architecting mobile solutions.',
        achievements: [
          'Built 5+ production Flutter apps',
          'Improved app performance by 40%',
          'Mentored junior developers',
        ],
      ),
      const Experience(
        company: 'Digital Solutions Ltd.',
        position: 'Mobile Developer',
        duration: '2020 - 2022',
        description:
            'Developed cross-platform mobile applications using Flutter.',
        achievements: [
          'Delivered 10+ mobile projects',
          'Implemented complex animations',
          'Integrated various third-party services',
        ],
      ),
    ];
  }
}
