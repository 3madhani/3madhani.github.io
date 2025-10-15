import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:test_app/core/widgets/floating_shapes.dart';

import '../../../../../core/widgets/magnetic_button.dart';
import '../../../../../core/widgets/section_wrapper.dart';
import '../../../domain/entities/skill.dart';
import '../../widgets/animations/reveal_animation.dart';
import '../../widgets/cards/skill_card.dart';

class SkillsSection extends StatefulWidget {
  final List<Skill> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  SkillCategory? _selectedCategory; // Start with null (All selected)

  List<Skill> get _filteredSkills {
    if (_selectedCategory == null) return widget.skills;
    return widget.skills
        .where((skill) => skill.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        const Positioned.fill(child: FloatingShapes(shapeCount: 8)),
        SectionWrapper(
          backgroundColor: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface.withOpacity(0.1),
              theme.colorScheme.primaryContainer.withOpacity(0.098),
            ],
          ),
          title: 'Technical Skills',
          subtitle: 'Technologies and tools I work with',
          child: Column(
            children: [
              // Category filters with "All" first
              RevealAnimation(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(seconds: 1),
                offset: const Offset(0, 30),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      // "All" filter first
                      MagneticButton(
                        radius: 80,
                        onTap: () => _onCategorySelected(null),
                        child: FilterChip(
                          label: const Text('All Skills'),
                          selected: _selectedCategory == null,
                          onSelected: (_) => _onCategorySelected(null),
                          selectedColor: theme.colorScheme.primaryContainer,
                          checkmarkColor: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),

                      // Other categories
                      ...SkillCategory.values.map((category) {
                        final isSelected = category == _selectedCategory;
                        return MagneticButton(
                          radius: 80,
                          onTap: () => _onCategorySelected(category),
                          child: FilterChip(
                            label: Text(_getCategoryName(category)),
                            selected: isSelected,
                            onSelected: (_) => _onCategorySelected(category),
                            selectedColor: theme.colorScheme.primaryContainer,
                            checkmarkColor:
                                theme.colorScheme.onPrimaryContainer,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Skills count indicator
              if (_filteredSkills.isNotEmpty) ...[
                RevealAnimation(
                  delay: const Duration(milliseconds: 400),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _selectedCategory == null
                          ? '${_filteredSkills.length} Total Skills'
                          : '${_filteredSkills.length} ${_getCategoryName(_selectedCategory!)} Skills',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Skills grid
              RevealAnimation(
                duration: const Duration(milliseconds: 400),
                offset: const Offset(0, 50),
                child: _filteredSkills.isEmpty
                    ? _buildEmptyState()
                    : Container(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = 1;
                            final width = constraints.maxWidth;
                            if (width >= 1200) {
                              crossAxisCount = 4;
                            } else if (width >= 900) {
                              crossAxisCount = 3;
                            } else if (width >= 600) {
                              crossAxisCount = 2;
                            }

                            return MasonryGridView.count(
                              clipBehavior: Clip.none,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),

                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 24,
                              crossAxisSpacing: 24,
                              itemCount: _filteredSkills.length,
                              itemBuilder: (context, index) {
                                final skill = _filteredSkills[index];
                                final delay = (index * 0.1).clamp(0.0, 1.0);

                                return AnimatedBuilder(
                                  animation: _animController,
                                  builder: (ctx, child) {
                                    final t = (_animController.value - delay)
                                        .clamp(0.0, 1.0);
                                    final e = Curves.easeOutBack.transform(t);
                                    return Transform.translate(
                                      offset: Offset(0, (1 - e) * 50),
                                      child: Opacity(opacity: t, child: child),
                                    );
                                  },
                                  child: SkillCard(skill: skill),
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

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  Widget _buildEmptyState() {
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
          Text('No skills found', style: theme.textTheme.headlineSmall),
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

  String _getCategoryName(SkillCategory category) {
    switch (category) {
      case SkillCategory.mobile:
        return 'Mobile';
      case SkillCategory.frontend:
        return 'Frontend';
      case SkillCategory.backend:
        return 'Backend';
      case SkillCategory.design:
        return 'Design';
      case SkillCategory.tools:
        return 'Tools';
    }
  }

  void _onCategorySelected(SkillCategory? category) {
    if (_selectedCategory != category) {
      setState(() => _selectedCategory = category);
      _animController
        ..reset()
        ..forward();
    }
  }
}
