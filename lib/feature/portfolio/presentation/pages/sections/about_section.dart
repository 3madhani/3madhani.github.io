// lib/features/portfolio/presentation/pages/sections/about_section.dart

import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/floating_shapes.dart';
import '../../../../../core/widgets/section_wrapper.dart';
import '../../../domain/entities/experience.dart';
import '../../widgets/animations/animated_container.dart';
import '../../widgets/animations/reveal_animation.dart';
import '../../widgets/cards/code_window.dart';

class AboutSection extends StatelessWidget {
  final List<Experience> experiences;

  const AboutSection({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Stack(
      children: [
        const Positioned.fill(child: FloatingShapes(shapeCount: 3)),

        SectionWrapper(
          title: 'About Me',
          subtitle: 'Get to know the magic behind the code',
          child: Column(
            children: [
              ResponsiveHelper.buildResponsiveRow(
                context,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isMobile ? 1 : 2,
                    child: RevealAnimation(
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: isMobile
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            "I'm a dedicated Flutter developer with a passion "
                            "for creating exceptional mobile and web experiences. "
                            "My journey has led me to specialize in cross-platform "
                            "development with magical animations and effects.",
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: isMobile
                                ? TextAlign.center
                                : TextAlign.left,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "I follow Clean Architecture and SOLID principles "
                            "for scalable, testable code, enhanced with animated "
                            "counters and interactive visuals.",
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: isMobile
                                ? TextAlign.center
                                : TextAlign.left,
                          ),
                          const SizedBox(height: 40),
                          RevealAnimation(
                            duration: const Duration(milliseconds: 400),
                            child: const _StatisticsRow(),
                          ),
                          const SizedBox(height: 32),
                          CustomButton(
                            text: 'Download Resume',
                            icon: Icons.download,
                            onPressed: () {},
                            type: CustomButtonType.outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 48),
                    Expanded(
                      child: RevealAnimation(
                        duration: const Duration(milliseconds: 600),
                        child: const CodeWindow(),
                      ),
                    ),
                  ],
                ],
              ),
              if (isMobile) ...[
                const SizedBox(height: 40),
                RevealAnimation(
                  duration: const Duration(milliseconds: 600),
                  child: const CodeWindow(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            AnimatedCounter(
              value: value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsRow extends StatelessWidget {
  const _StatisticsRow();

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final stats = [
      {'value': 50, 'label': 'Projects\nCompleted', 'icon': Icons.work},
      {'value': 3, 'label': 'Years\nExperience', 'icon': Icons.schedule},
      {'value': 100, 'label': 'Happy\nClients', 'icon': Icons.favorite},
    ];

    if (isMobile) {
      return Column(
        children: stats.map((s) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _StatCard(
              value: s['value'] as int,
              label: s['label'] as String,
              icon: s['icon'] as IconData,
            ),
          );
        }).toList(),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats.map((s) {
        return Expanded(
          child: _StatCard(
            value: s['value'] as int,
            label: s['label'] as String,
            icon: s['icon'] as IconData,
          ),
        );
      }).toList(),
    );
  }
}
