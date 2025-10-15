import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/enhanced_portfolio_service.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/usecases/get_experience.dart';
import '../../../domain/usecases/get_projects.dart';
import '../../../domain/usecases/get_skills.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final GetProjects getProjects;
  final GetSkills getSkills;
  final GetExperience getExperience;

  PortfolioBloc({
    required this.getProjects,
    required this.getSkills,
    required this.getExperience,
  }) : super(PortfolioInitial()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
    on<FilterProjects>(_onFilterProjects);
  }

  void _onFilterProjects(FilterProjects event, Emitter<PortfolioState> emit) {
    if (state is PortfolioLoaded) {
      final currentState = state as PortfolioLoaded;

      List<Project> filteredProjects;

      switch (event.category) {
        case ProjectCategory.all:
          filteredProjects = currentState.projects;
          break;
        case ProjectCategory.featured:
          filteredProjects = currentState.projects
              .where((project) => project.isFeatured)
              .toList();
          break;
        default:
          filteredProjects = currentState.projects
              .where((project) => project.category == event.category)
              .toList();
      }

      emit(
        currentState.copyWith(
          filteredProjects: filteredProjects,
          selectedCategory: event.category,
        ),
      );
    }
  }

  Future<void> _onLoadPortfolioData(
    LoadPortfolioData event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(PortfolioLoading());

    try {
      final enhancedService = EnhancedPortfolioService();

      final projects = await enhancedService.getAllProjects();
      final skills = enhancedService.getAllSkills();
      final experiences = enhancedService.getAllExperiences();

      emit(
        PortfolioLoaded(
          projects: projects,
          filteredProjects: projects,
          experiences: experiences,
          skills: skills,
          selectedCategory: ProjectCategory.all,
        ),
      );
    } catch (e) {
      emit(PortfolioError('Failed to load portfolio data: $e'));
    }
  }
}
