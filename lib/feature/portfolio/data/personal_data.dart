// lib/features/portfolio/data/personal_data.dart
import '../domain/entities/experience.dart';
import '../domain/entities/project.dart';
import '../domain/entities/skill.dart';

const String contactEmail = 'emad-hany@outlook.com';
const String contactLocation = 'Cairo, Egypt';
// Contact Information
const String contactName = 'Emad Hany';
const String contactPhone = '+201005491396';
const String contactTitle = 'Flutter Developer - FreeLancer';
const String githubUrl = 'https://github.com/3madhani';
const String linkedInUrl = 'https://linkedin.com/in/3mad-hany';
const String cvLink =
    'https://drive.google.com/drive/folders/1hXJGxBiayPQbMB9spkmiYCj_OPRqIf1W?usp=drive_link';

// Professional Summary
const String professionalSummary = '''
Computer Science graduate with a solid foundation in programming, algorithms, and software engineering. 
Specialized in Flutter development, with hands-on experience building responsive and scalable mobile apps. 
Proficient in applying design patterns like BLoC, MVVM, and Clean Architecture to create clean, maintainable 
code and deliver smooth user experiences.
''';

// Featured Projects from CV
final List<Project> cvFeaturedProjects = [
  Project(
    title: 'Fruit HUB & Dashboard',
    description:
        'A fully functional e-commerce app for browsing, favoriting, and purchasing fruit and grocery products. Features user authentication, PayPal integration, and real-time Firebase sync.',
    category: ProjectCategory.featured,
    githubUrl: 'https://github.com/3madhani/fruit_hub',
    demoUrl: null,
    technologies: [
      'Flutter',
      'BLoC',
      'Firebase',
      'PayPal',
      'Clean Architecture',
    ],
    isFeatured: true,
    color: '#4CAF50',
  ),

  Project(
    title: 'Bookly',
    description:
        'A beautifully designed Flutter application for exploring and previewing books. Built with clean architecture, BLoC state management, and modern UI techniques.',
    category: ProjectCategory.mobile,
    githubUrl: 'https://github.com/3madhani/bookly',
    demoUrl: null,
    technologies: ['Flutter', 'BLoC', 'Dio', 'Go Router', 'Google Fonts'],
    isFeatured: true,
    color: '#2196F3',
  ),

  Project(
    title: 'TalkVerse',
    description:
        'A modern real-time messaging app built with Flutter. Features clean UI, customizable themes, QR-based profile sharing, and Firebase integration.',
    category: ProjectCategory.featured,
    githubUrl: 'https://github.com/3madhani/talkverse',
    demoUrl: null,
    technologies: [
      'Flutter',
      'Firebase Auth',
      'Firestore',
      'Provider',
      'QR Flutter',
    ],
    isFeatured: true,
    color: '#9C27B0',
  ),

  Project(
    title: 'FlavoDish',
    description:
        'A sleek recipe app for exploring and saving dishes. Built with Flutter, BLoC, Firebase, and Hive for both online and offline functionality.',
    category: ProjectCategory.mobile,
    githubUrl: 'https://github.com/3madhani/flavodish',
    demoUrl: null,
    technologies: ['Flutter', 'BLoC', 'Firebase', 'Hive', 'Go Router'],
    isFeatured: true,
    color: '#FF9800',
  ),

  Project(
    title: 'SocialPosts',
    description:
        'A post management app demonstrating clean and scalable Flutter development with BLoC and modular architecture. Features full CRUD operations.',
    category: ProjectCategory.mobile,
    githubUrl: 'https://github.com/3madhani/social_posts',
    demoUrl: null,
    technologies: ['Flutter', 'BLoC', 'HTTP', 'Clean Architecture', 'Dartz'],
    isFeatured: false,
    color: '#FF5722',
  ),
];

// Education
final List<Experience> educationHistory = [
  Experience(
    company: 'Faculty of Computers and Information - Minya University',
    position: 'Bachelor of Computer Science',
    duration: '09/2020 – 06/2024',
    description: 'GPA: 3.41 • Grade: B+ (very good with honors)',
    achievements: [],
  ),
];

// Experience from CV
final List<Experience> personalExperiences = [
  Experience(
    company: 'FreeLancer',
    position: 'Flutter Developer',
    duration: '2023 - Present',
    description:
        'Developing cross-platform mobile applications using Flutter with clean architecture, BLoC state management, and Firebase integration.',
    achievements: [],
  ),
  Experience(
    company: 'Information Technology Institute (ITI)',
    position: 'Summer Training - Flutter',
    duration: 'Jul 2023',
    description:
        'Completed intensive Flutter development training program, focusing on mobile app development best practices and modern design patterns.',
    achievements: [],
  ),
  Experience(
    company: 'Yat Learning Center',
    position: 'Flutter Development Course',
    duration: 'Aug 2023',
    description:
        'Mastering Flutter Application Development - Advanced course covering state management, architecture patterns, and production-ready app development.',
    achievements: [],
  ),
];

// Skills from CV matching your models
final List<Skill> personalSkills = [
  // Mobile Development
  Skill(
    name: 'Flutter',
    level: 95,
    icon: 'fab fa-flutter',
    category: SkillCategory.mobile,
  ),
  Skill(
    name: 'Dart',
    level: 95,
    icon: 'fas fa-code',
    category: SkillCategory.mobile,
  ),

  // State Management
  Skill(
    name: 'BLoC',
    level: 90,
    icon: 'fas fa-cube',
    category: SkillCategory.frontend,
  ),
  Skill(
    name: 'Provider',
    level: 85,
    icon: 'fas fa-share-alt',
    category: SkillCategory.frontend,
  ),
  Skill(
    name: 'GetX',
    level: 80,
    icon: 'fas fa-layer-group',
    category: SkillCategory.frontend,
  ),

  // Architecture & Patterns
  Skill(
    name: 'Clean Architecture',
    level: 90,
    icon: 'fas fa-project-diagram',
    category: SkillCategory.design,
  ),
  Skill(
    name: 'MVVM',
    level: 85,
    icon: 'fas fa-sitemap',
    category: SkillCategory.design,
  ),
  Skill(
    name: 'SOLID Principles',
    level: 85,
    icon: 'fas fa-building',
    category: SkillCategory.design,
  ),

  // Backend & APIs
  Skill(
    name: 'Firebase',
    level: 90,
    icon: 'fab fa-google',
    category: SkillCategory.backend,
  ),
  Skill(
    name: 'REST APIs',
    level: 85,
    icon: 'fas fa-cloud',
    category: SkillCategory.backend,
  ),
  Skill(
    name: 'Supabase',
    level: 70,
    icon: 'fas fa-database',
    category: SkillCategory.backend,
  ),

  // Tools & Utilities
  Skill(
    name: 'GetIt',
    level: 85,
    icon: 'fas fa-plug',
    category: SkillCategory.tools,
  ),
  Skill(
    name: 'Hive',
    level: 80,
    icon: 'fas fa-archive',
    category: SkillCategory.tools,
  ),
  Skill(
    name: 'Git',
    level: 85,
    icon: 'fab fa-git-alt',
    category: SkillCategory.tools,
  ),

  // Additional Skills
  Skill(
    name: 'Python',
    level: 75,
    icon: 'fab fa-python',
    category: SkillCategory.backend,
  ),
];
