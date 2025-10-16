import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:test_app/core/widgets/floating_shapes.dart';
import 'package:test_app/core/widgets/magnetic_button.dart';
import 'package:test_app/core/widgets/section_wrapper.dart';
import 'package:test_app/core/widgets/tilt_3d.dart';

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
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    final categories = [
      ProjectCategory.all,
      ...ProjectCategory.values.where((c) => c != ProjectCategory.all),
    ];

    int crossAxisCount = 1;
    if (width >= 1200) {
      crossAxisCount = 4;
    } else if (width >= 900) {
      crossAxisCount = 3;
    } else if (width >= 600) {
      crossAxisCount = 2;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(child: FloatingShapes(shapeCount: 4)),
        SectionWrapper(
          enableRevealAnimation: true,
          title: 'Magical Creations',
          subtitle: "Some enchanting things I've built",
          backgroundColor: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primaryContainer.withOpacity(0.1),
              theme.colorScheme.surface.withOpacity(0.1),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filter Chips
              RevealAnimation(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(seconds: 1),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: categories.map((category) {
                    final isSelected = category == selectedCategory;
                    return MagneticButton(
                      radius: 80,
                      onTap: () => context.read<PortfolioBloc>().add(
                        FilterProjects(category),
                      ),
                      child: FilterChip(
                        label: Text(_getCategoryName(category)),
                        selected: isSelected,
                        onSelected: (_) => context.read<PortfolioBloc>().add(
                          FilterProjects(category),
                        ),
                        selectedColor: theme.colorScheme.primaryContainer,
                        checkmarkColor: theme.colorScheme.onPrimaryContainer,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 48),

              // Grid
              RevealAnimation(
                duration: const Duration(milliseconds: 400),
                child: projects.isEmpty
                    ? _buildEmptyState(context)
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return MasonryGridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            itemCount: projects.length,
                            itemBuilder: (context, index) {
                              final project = projects[index];
                              final delay = (index * 0.08).clamp(0.0, 0.8);

                              return TweenAnimationBuilder<double>(
                                duration: Duration(
                                  milliseconds: 300 + (index * 100),
                                ),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  final t = (value - delay).clamp(0.0, 1.0);
                                  final eased = Curves.easeOutBack.transform(t);
                                  return Transform.translate(
                                    offset: Offset(0, (1 - eased) * 180),
                                    child: isMobile || isTablet
                                        ? ProjectCard(
                                            project: project,
                                            onTap: () => _showProjectModal(
                                              context,
                                              project,
                                            ),
                                          )
                                        : Tilt3D(
                                            child: ProjectCard(
                                              project: project,
                                              onTap: () => _showProjectModal(
                                                context,
                                                project,
                                              ),
                                            ),
                                          ),
                                  );
                                },
                              );
                            },
                          );
                        },
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
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 120,
            color: theme.colorScheme.primary.withOpacity(0.3),
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
      builder: (_) => ProjectModal(project: project),
    );
  }
}
