import 'package:equatable/equatable.dart';

import '../../../domain/entities/experience.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/skill.dart';

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final List<Project> projects;
  final List<Project> filteredProjects;
  final List<Skill> skills;
  final List<Experience> experiences;
  final ProjectCategory selectedCategory;

  const PortfolioLoaded({
    required this.projects,
    required this.filteredProjects,
    required this.skills,
    required this.experiences,
    this.selectedCategory = ProjectCategory.all,
  });

  @override
  List<Object?> get props => [
    projects,
    filteredProjects,
    skills,
    experiences,
    selectedCategory,
  ];

  PortfolioLoaded copyWith({
    List<Project>? projects,
    List<Project>? filteredProjects,
    List<Skill>? skills,
    List<Experience>? experiences,
    ProjectCategory? selectedCategory,
  }) {
    return PortfolioLoaded(
      projects: projects ?? this.projects,
      filteredProjects: filteredProjects ?? this.filteredProjects,
      skills: skills ?? this.skills,
      experiences: experiences ?? this.experiences,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class PortfolioLoading extends PortfolioState {}

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}
