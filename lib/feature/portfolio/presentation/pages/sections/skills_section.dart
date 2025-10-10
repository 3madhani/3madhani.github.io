import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../domain/entities/skill.dart';
import '../../widgets/cards/skill_card.dart';

class SkillsSection extends StatefulWidget {
  final List<Skill> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  SkillCategory _selectedCategory = SkillCategory.frontend;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Skill> get _filteredSkills {
    return widget.skills
        .where((skill) => skill.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getScreenPadding(
        context,
      ).copyWith(top: isMobile ? 40 : 80, bottom: isMobile ? 40 : 80),
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: Column(
        children: [
          // Section Header
          Text(
            'Technical Magic',
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: ResponsiveHelper.getSectionTitleSize(context),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Technologies I enchant with',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Category Filter
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: SkillCategory.values.map((category) {
                final isSelected = category == _selectedCategory;
                return FilterChip(
                  label: Text(_getCategoryName(category)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _animationController.reset();
                      _animationController.forward();
                    }
                  },
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  selectedColor: theme.colorScheme.primaryContainer,
                  checkmarkColor: theme.colorScheme.onPrimaryContainer,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 48),

          // Skills Grid
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithResponsiveColumns(
                    context: context,
                    minItemWidth: 280,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: _filteredSkills.length,
                  itemBuilder: (context, index) {
                    final skill = _filteredSkills[index];
                    final delay = index * 0.1;

                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final animationValue = Curves.easeOutBack.transform(
                          (_animationController.value - delay).clamp(0.0, 1.0),
                        );

                        return Transform.translate(
                          offset: Offset(0, (1 - animationValue) * 50),
                          child: Opacity(
                            opacity: animationValue,
                            child: SkillCard(skill: skill),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getCategoryName(SkillCategory category) {
    switch (category) {
      case SkillCategory.frontend:
        return 'Frontend';
      case SkillCategory.backend:
        return 'Backend';
      case SkillCategory.mobile:
        return 'Mobile';
      case SkillCategory.tools:
        return 'Tools';
      case SkillCategory.design:
        return 'Design';
    }
  }
}

class SliverGridDelegateWithResponsiveColumns extends SliverGridDelegate {
  final BuildContext context;
  final double minItemWidth;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const SliverGridDelegateWithResponsiveColumns({
    required this.context,
    required this.minItemWidth,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final availableWidth = constraints.crossAxisExtent;
    final crossAxisCount = (availableWidth / minItemWidth).floor().clamp(1, 4);
    final itemWidth =
        (availableWidth - (crossAxisSpacing * (crossAxisCount - 1))) /
        crossAxisCount;

    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: 200 + mainAxisSpacing,
      crossAxisStride: itemWidth + crossAxisSpacing,
      childMainAxisExtent: 200,
      childCrossAxisExtent: itemWidth,
      reverseCrossAxis: false,
    );
  }

  @override
  bool shouldRelayout(covariant SliverGridDelegate oldDelegate) => false;
}
