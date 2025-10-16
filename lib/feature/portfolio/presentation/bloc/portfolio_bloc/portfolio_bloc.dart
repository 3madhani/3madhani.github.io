import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/enhanced_portfolio_service.dart';
import '../../../../../core/services/github_service.dart';
import '../../../domain/entities/project.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final EnhancedPortfolioService _portfolioService;

  PortfolioBloc({EnhancedPortfolioService? portfolioService})
    : _portfolioService =
          portfolioService ?? EnhancedPortfolioService(GitHubService()),
      super(PortfolioInitial()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
    on<FilterProjects>(_onFilterProjects);
  }

  void _onFilterProjects(FilterProjects event, Emitter<PortfolioState> emit) {
    if (state is PortfolioLoaded) {
      final currentState = state as PortfolioLoaded;
      List<Project> filtered;

      switch (event.category) {
        case ProjectCategory.all:
          filtered = currentState.projects;
          break;
        case ProjectCategory.featured:
          filtered = currentState.projects.where((p) => p.isFeatured).toList();
          break;
        default:
          filtered = currentState.projects
              .where((p) => p.category == event.category)
              .toList();
      }

      emit(
        currentState.copyWith(
          filteredProjects: filtered,
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
      final projects = await _portfolioService.getAllProjects();
      final skills = _portfolioService.getAllSkills();
      final experiences = _portfolioService.getAllExperiences();

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
