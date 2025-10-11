import 'package:flutter/material.dart';

import '../../../domain/entities/skill.dart';

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

    return LayoutBuilder(
      builder: (context, constraints) {
        // 🔹 Breakpoints
        final isMobile = constraints.maxWidth < 450;
        final isTablet =
            constraints.maxWidth < 900 && constraints.maxWidth >= 450;

        // 🔹 Responsive values
        final double iconSize = isMobile
            ? 40
            : isTablet
            ? 48
            : 56;
        final double containerSize = iconSize + 16;
        final double padding = isMobile
            ? 12
            : isTablet
            ? 16
            : 20;
        final double fontSize = isMobile
            ? 14
            : isTablet
            ? 15
            : 16;
        final double progressHeight = isMobile ? 6 : 8;

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
            child: Card(
              elevation: _elevationAnim.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🟣 Icon
                    Container(
                      width: containerSize,
                      height: containerSize,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _iconFor(widget.skill.icon),
                        size: iconSize,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    SizedBox(height: isMobile ? 10 : 16),

                    // 🟣 Skill Name
                    Text(
                      widget.skill.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize + 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobile ? 8 : 12),

                    // 🟣 Progress Bar
                    AnimatedBuilder(
                      animation: _hoverController,
                      builder: (context, _) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Proficiency',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: fontSize - 1,
                                  ),
                                ),
                                Text(
                                  '${widget.skill.level}%',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize - 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _progressAnim.value,
                                minHeight: progressHeight,
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
                    SizedBox(height: isMobile ? 10 : 16),

                    // 🟣 Category badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 10 : 12,
                        vertical: isMobile ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _categoryName(widget.skill.category),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize - 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
  }

  String _categoryName(SkillCategory c) =>
      c.name[0].toUpperCase() + c.name.substring(1);

  void _onHover(bool hover) {
    if (hover) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }
}
