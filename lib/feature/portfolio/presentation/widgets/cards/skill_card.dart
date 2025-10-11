import 'package:flutter/material.dart';

import '../../../../../core/widgets/glass_container.dart';
import '../../../domain/entities/skill.dart';

class SkillCard extends StatefulWidget {
  final Skill skill;

  const SkillCard({super.key, required this.skill});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _elevationAnim;
  late final Animation<double> _progressAnim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + (_elevationAnim.value - 2) * 0.01,
            child: child,
          );
        },
        child: GlassContainer(
          blur: 12,
          opacity: 0.08,
          borderRadius: BorderRadius.circular(16),
          padding: const EdgeInsets.all(0),
          child: Card(
            elevation: _elevationAnim.value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _iconFor(widget.skill.icon),
                      size: 32,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    widget.skill.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Progress
                  AnimatedBuilder(
                    animation: _hoverController,
                    builder: (context, _) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Proficiency',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                '${widget.skill.level}%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _progressAnim.value,
                              minHeight: 8,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Category badge
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
                      _categoryName(widget.skill.category),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _elevationAnim = Tween<double>(
      begin: 2,
      end: 10,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
    _progressAnim = Tween<double>(
      begin: 0.0,
      end: widget.skill.level / 100,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    // Animate progress on hover
  }

  String _categoryName(SkillCategory c) {
    return c.name[0].toUpperCase() + c.name.substring(1);
  }

  IconData _iconFor(String icon) {
    switch (icon) {
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

  void _onHover(bool hover) {
    if (hover) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }
}
