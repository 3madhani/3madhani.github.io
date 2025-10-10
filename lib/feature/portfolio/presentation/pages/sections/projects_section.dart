import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../../domain/entities/project.dart';
import '../../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../../bloc/portfolio_bloc/portfolio_event.dart';
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getScreenPadding(
        context,
      ).copyWith(top: isMobile ? 40 : 80, bottom: isMobile ? 40 : 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ],
        ),
      ),
      child: Column(
        children: [
          // Section Header
          Text(
            'Magical Creations',
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: ResponsiveHelper.getSectionTitleSize(context),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Some enchanting things I've built",
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Filter Buttons
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: ProjectCategory.values.map((category) {
                final isSelected = category == selectedCategory;
                return FilterChip(
                  label: Text(_getCategoryName(category)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<PortfolioBloc>().add(
                        FilterProjects(category),
                      );
                    }
                  },
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  selectedColor: theme.colorScheme.primaryContainer,
                  checkmarkColor: theme.colorScheme.onPrimaryContainer,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 48),

          // Projects Grid
          if (projects.isEmpty)
            _buildEmptyState(context)
          else
            Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.getGridColumns(context),
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: isMobile ? 0.8 : 0.75,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, (1 - value) * 50),
                        child: Opacity(
                          opacity: value,
                          child: ProjectCard(
                            project: project,
                            onTap: () => _showProjectModal(context, project),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
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
