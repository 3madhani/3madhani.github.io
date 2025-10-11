import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/widgets/floating_shapes.dart';
import 'package:test_app/core/widgets/tilt_3d.dart';

import '../../../../../core/utils/responsive_grid_delegate.dart';
import '../../../../../core/widgets/magnetic_button.dart';
import '../../../../../core/widgets/section_wrapper.dart';
import '../../../domain/entities/project.dart';
import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_event.dart';
import '../../widgets/animations/reveal_animation.dart';
import '../../widgets/cards/project_card.dart';
import '../../widgets/modals/project_modal.dart';

class ProjectsSection extends StatelessWidget {
  final List<Project> projects;
  final ProjectCategory selectedCategory;

  const ProjectsSection({
    super.key,
    required this.projects,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: FloatingShapes(shapeCount: 4)),

        SectionWrapper(
          title: 'Magical Creations',
          subtitle: "Some enchanting things I've built",
          backgroundColor: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
              Theme.of(context).colorScheme.surface.withOpacity(0.1),
            ],
          ),
          child: Column(
            children: [
              // Filter Buttons
              RevealAnimation(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(seconds: 1),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: ProjectCategory.values.map((category) {
                      final isSelected = category == selectedCategory;
                      return MagneticButton(
                        radius: 80,
                        onTap: () {
                          context.read<PortfolioBloc>().add(
                            FilterProjects(category),
                          );
                        },
                        child: FilterChip(
                          label: Text(_getCategoryName(category)),
                          selected: isSelected,
                          onSelected: (_) {},
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Projects Grid
              RevealAnimation(
                duration: const Duration(milliseconds: 400),
                child: projects.isEmpty
                    ? _buildEmptyState(context)
                    : Container(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithResponsiveColumns(
                            childAspectRatio: 1.0,
                            context: context,
                            minItemWidth: 280,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                          ),
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                milliseconds: 300 + (index * 100),
                              ),
                              tween: Tween(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(0, (1 - value) * 50),
                                  child: Opacity(
                                    opacity: value,
                                    child: Tilt3D(
                                      child: ProjectCard(
                                        project: project,
                                        onTap: () =>
                                            _showProjectModal(context, project),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text('No projects found', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different category',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(ProjectCategory category) {
    switch (category) {
      case ProjectCategory.all:
        return 'All Projects';
      case ProjectCategory.featured:
        return 'Featured';
      case ProjectCategory.mobile:
        return 'Mobile';
      case ProjectCategory.web:
        return 'Web';
    }
  }

  void _showProjectModal(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (context) => ProjectModal(project: project),
    );
  }
}
