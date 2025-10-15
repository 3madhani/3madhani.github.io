import 'package:flutter/material.dart';
import 'package:test_app/core/widgets/tilt_3d.dart';
import 'package:test_app/feature/portfolio/domain/entities/project.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/floating_shapes.dart';
import '../../../../../core/widgets/section_wrapper.dart';
import '../../../data/personal_data.dart';
import '../../../domain/entities/experience.dart';
import '../../widgets/animations/animated_container.dart';
import '../../widgets/animations/reveal_animation.dart';
import '../../widgets/cards/code_window.dart';

class AboutSection extends StatelessWidget {
  final List<Experience> experiences;
  final List<Project> projects;
  const AboutSection({
    super.key,
    required this.experiences,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Stack(
      children: [
        const Positioned.fill(child: FloatingShapes(shapeCount: 3)),
        SectionWrapper(
          title: 'About Me',
          subtitle: 'Get to know the developer behind the code',
          child: SingleChildScrollView(
            child: Padding(
              padding: ResponsiveHelper.getScreenPadding(context),
              child: Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (c, box) {
                      final wide = box.maxWidth > 700;
                      if (wide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 8,
                              child: _textBlock(context, isMobile),
                            ),
                            const SizedBox(width: 48),
                            Expanded(
                              flex: 5,
                              child: Tilt3D(
                                maxTilt: 20,
                                perspective: 0.001,
                                child: const CodeWindow(),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            _textBlock(context, isMobile),
                            const SizedBox(height: 40),
                            const CodeWindow(),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40),

                  // Experience Timeline
                  if (experiences.isNotEmpty) ...[
                    RevealAnimation(
                      delay: const Duration(milliseconds: 600),
                      child: ExperienceTimeline(experiences: experiences),
                    ),
                    const SizedBox(height: 40),
                  ],

                  // Statistics
                  RevealAnimation(
                    delay: const Duration(milliseconds: 700),
                    child: _StatisticsRow(projects: projects),
                  ),
                  const SizedBox(height: 32),

                  // Action buttons
                  RevealAnimation(
                    delay: const Duration(milliseconds: 800),
                    child: Center(
                      child: Wrap(
                        alignment: isMobile
                            ? WrapAlignment.center
                            : WrapAlignment.end,
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          CustomButton(
                            text: 'Download CV',
                            icon: Icons.download_outlined,
                            onPressed: _downloadCV,
                            type: CustomButtonType.primary,
                          ),
                          CustomButton(
                            text: 'View GitHub',
                            icon: Icons.code,
                            onPressed: () => _launchURL(githubUrl),
                            type: CustomButtonType.outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _downloadCV() {
    // You can implement direct CV download or redirect to GitHub
    _launchURL(cvLink);
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _textBlock(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    return RevealAnimation(
      delay: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          // Professional summary from CV
          Text(
            professionalSummary,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
          const SizedBox(height: 24),

          // Additional info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Education',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Bachelor of Computer Science\nMinya University (2020-2024)\nGPA: 3.41 - Grade: B+ (Very Good with Honors)',
                  style: theme.textTheme.bodyMedium,
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceTimeline extends StatelessWidget {
  final List<Experience> experiences;

  const ExperienceTimeline({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final exp = entry.value;
        final isLast = index == experiences.length - 1;
        return _TimelineRow(experience: exp, isLast: isLast);
      }).toList(),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final Experience experience;

  const _ExperienceCard({required this.experience});

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surface;
    final outlineColor = theme.colorScheme.outline.withOpacity(0.2);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _hovering
            ? (Matrix4.translationValues(0, -6, 0)..scale(1.02))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: outlineColor),
          boxShadow: _hovering
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Position & Duration
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.experience.position,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.experience.duration,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Company
            Text(
              widget.experience.company,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              widget.experience.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final int value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _elevationAnimation;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: isMobile ? double.infinity : 250,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovering
                      ? theme.colorScheme.primary.withOpacity(0.3)
                      : theme.colorScheme.outline.withOpacity(0.2),
                  width: _isHovering ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovering
                        ? theme.colorScheme.primary.withOpacity(0.15)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Animated icon container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isHovering
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        widget.icon,
                        key: ValueKey(_isHovering),
                        size: _isHovering ? 28 : 24,
                        color: _isHovering
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Animated counter
                  AnimatedCounter(
                    value: widget.value,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isHovering
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Label with animation
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style:
                        theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: _isHovering
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: _isHovering
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withOpacity(0.8),
                        ) ??
                        const TextStyle(),
                    child: Text(widget.label, textAlign: TextAlign.center),
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
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 12.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  void _onHover(bool hovering) {
    setState(() => _isHovering = hovering);
    if (hovering) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }
}

class _StatisticsRow extends StatelessWidget {
  final List<Project> projects;
  const _StatisticsRow({required this.projects});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final theme = Theme.of(context);

    // Updated stats based on your experience level
    final stats = [
      {
        'value': projects.length, // Realistic for a new graduate
        'label': 'Projects\nCompleted',
        'icon': Icons.code,
      },
      {
        'value': 2, // Based on your 2023-present experience
        'label': 'Years\nExperience',
        'icon': Icons.schedule,
      },
      {
        'value': 5, // Realistic client count
        'label': 'Happy\nClients',
        'icon': Icons.favorite,
      },
    ];

    return Column(
      children: [
        Text(
          'My Journey So Far',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),

        if (isMobile)
          Column(
            children: stats.map((s) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _StatCard(
                  value: s['value'] as int,
                  label: s['label'] as String,
                  icon: s['icon'] as IconData,
                ),
              );
            }).toList(),
          )
        else
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 24,
              children: stats.map((s) {
                return _StatCard(
                  value: s['value'] as int,
                  label: s['label'] as String,
                  icon: s['icon'] as IconData,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final Experience experience;
  final bool isLast;

  const _TimelineRow({required this.experience, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          // Timeline column

          // Dot
          Positioned(
            left: -5,
            top: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Line (only if not last)
          if (!isLast)
            Positioned(
              bottom: isLast ? null : -24,
              top: !isLast ? 0 : null,
              child: Container(
                width: 2,
                height: 140, // adjust to match card height
                color: theme.colorScheme.outline.withOpacity(0.3),
              ),
            ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 24),

              // Experience card
              Expanded(child: _ExperienceCard(experience: experience)),
            ],
          ),
        ],
      ),
    );
  }
}
