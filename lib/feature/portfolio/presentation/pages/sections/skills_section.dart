import 'package:flutter/material.dart';
import 'package:test_app/core/widgets/floating_shapes.dart';

import '../../../../../core/utils/responsive_grid_delegate.dart';
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
  SkillCategory? _selectedCategory = SkillCategory.frontend;

  List<Skill> get _filtered {
    if (_selectedCategory == null) return widget.skills;
    return widget.skills.where((s) => s.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: FloatingShapes(shapeCount: 5)),
        SectionWrapper(
          backgroundColor: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
            ],
          ),
          title: 'Technical Magic',
          subtitle: 'Technologies I enchant with',
          child: Column(
            children: [
              // Category filters
              RevealAnimation(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(seconds: 1),
                offset: const Offset(0, 30),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ...SkillCategory.values.map((cat) {
                      final sel = cat == _selectedCategory;
                      return MagneticButton(
                        radius: 80,
                        onTap: () {
                          setState(() => _selectedCategory = cat);
                          _animController
                            ..reset()
                            ..forward();
                        },
                        child: FilterChip(
                          label: Text(_catName(cat)),
                          selected: sel,
                          onSelected: (_) {},
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                        ),
                      );
                    }),
                    // "All" filter
                    MagneticButton(
                      radius: 80,
                      onTap: () {
                        setState(() => _selectedCategory = null);
                        _animController
                          ..reset()
                          ..forward();
                      },
                      child: FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (_) {},
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Skills grid
              RevealAnimation(
                duration: const Duration(milliseconds: 400),
                offset: const Offset(0, 50),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithResponsiveColumns(
                    context: context,
                    minItemWidth: 280,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, i) {
                    final skill = _filtered[i];
                    final delay = i * 0.1;
                    return AnimatedBuilder(
                      animation: _animController,
                      builder: (ctx, child) {
                        final v = Curves.easeOutBack
                            .transform(
                              (_animController.value - delay).clamp(0.0, 1.0),
                            )
                            .clamp(0.0, 1.0);

                        return Transform.translate(
                          offset: Offset(0, (1 - v) * 50),
                          child: Opacity(opacity: v, child: child),
                        );
                      },
                      child: SkillCard(skill: skill),
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

  String _catName(SkillCategory c) {
    return c.name[0].toUpperCase() + c.name.substring(1);
  }
}
