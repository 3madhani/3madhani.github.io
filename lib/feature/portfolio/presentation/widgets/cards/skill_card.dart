import 'package:flutter/material.dart';

import '../../../domain/entities/skill.dart';

class SkillCard extends StatefulWidget {
  final Skill skill;

  const SkillCard({super.key, required this.skill});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _progressAnimation;

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Card(
            elevation: _elevationAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Skill Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getIconData(widget.skill.icon),
                      size: 32,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Skill Name
                  Text(
                    widget.skill.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Proficiency', style: theme.textTheme.bodySmall),
                          Text(
                            '${widget.skill.level}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getCategoryName(widget.skill.category),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.skill.level / 100,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    // Animate progress on hover
    _hoverController.forward();
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

  IconData _getIconData(String iconString) {
    // Map icon strings to IconData
    switch (iconString) {
      case 'fab fa-flutter':
        return Icons.flutter_dash;
      case 'fas fa-code':
        return Icons.code;
      case 'fas fa-fire':
        return Icons.local_fire_department;
      case 'fas fa-mobile-alt':
        return Icons.phone_android;
      case 'fas fa-palette':
        return Icons.palette;
      case 'fas fa-database':
        return Icons.storage;
      case 'fab fa-git-alt':
        return Icons.source;
      case 'fas fa-tools':
        return Icons.build;
      default:
        return Icons.star;
    }
  }

  void _onHover(bool hovered) {
    setState(() {
      _isHovered = hovered;
    });

    if (hovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }
}
