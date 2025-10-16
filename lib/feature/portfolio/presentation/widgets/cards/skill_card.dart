import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../domain/entities/skill.dart';

IconData _iconFor(String icon) {
  switch (icon) {
    case 'fab fa-flutter':
      return LucideIcons.zap;
    case 'fas fa-code':
      return LucideIcons.code2;
    case 'fas fa-fire':
      return LucideIcons.flame;
    case 'fas fa-mobile-alt':
      return LucideIcons.smartphone;
    case 'fas fa-palette':
      return LucideIcons.paintBucket;
    case 'fas fa-database':
      return LucideIcons.database;
    case 'fab fa-git-alt':
      return LucideIcons.gitBranch;
    case 'fas fa-tools':
      return LucideIcons.wrench;
    default:
      return LucideIcons.star;
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
        final isMobile = constraints.maxWidth < 450;
        final isTablet = constraints.maxWidth < 900 && !isMobile;
        final iconSize = isMobile
            ? 40
            : isTablet
            ? 48
            : 56;
        final containerSize = iconSize + 16;
        final padding = isMobile
            ? 12
            : isTablet
            ? 16
            : 20;
        final fontSize = isMobile
            ? 14
            : isTablet
            ? 15
            : 16;
        final progressHeight = isMobile ? 6 : 8;

        return MouseRegion(
          onEnter: (_) => _hoverController.forward(),
          onExit: (_) => _hoverController.reverse(),
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
                padding: EdgeInsets.all(padding.toDouble()),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: containerSize.toDouble(),
                      height: containerSize.toDouble(),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _iconFor(widget.skill.icon),
                        size: iconSize.toDouble(),
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    SizedBox(height: isMobile ? 10 : 16),
                    Text(
                      widget.skill.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize + 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobile ? 8 : 12),
                    Column(
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
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progressAnim.value,
                            minHeight: progressHeight.toDouble(),
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isMobile ? 10 : 16),
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
                        widget.skill.category.name.capitalize(),
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
}
