// lib/features/portfolio/presentation/pages/sections/about_section.dart

import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/floating_shapes.dart';
import '../../../domain/entities/experience.dart';
import '../../widgets/animations/animated_container.dart';
import '../../widgets/animations/reveal_animation.dart';
import '../../widgets/cards/code_window.dart';

class AboutSection extends StatelessWidget {
  final List<Experience> experiences;

  const AboutSection({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Stack(
      children: [
        // Floating shape accents behind content
        const Positioned.fill(child: FloatingShapes(shapeCount: 3)),
        Padding(
          padding: ResponsiveHelper.getScreenPadding(
            context,
          ).copyWith(top: isMobile ? 40 : 80, bottom: isMobile ? 40 : 80),
          child: Column(
            children: [
              // Section header with reveal animation
              RevealAnimation(
                child: Column(
                  children: [
                    Text(
                      'About Me',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontSize: ResponsiveHelper.getSectionTitleSize(context),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Get to know the magic behind the code',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Main content row/column
              ResponsiveHelper.buildResponsiveRow(
                context,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isMobile ? 1 : 2,
                    child: RevealAnimation(
                      duration: const Duration(milliseconds: 200),
                      offset: const Offset(0, 30),
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
                            style: theme.textTheme.bodyLarge,
                            textAlign: isMobile
                                ? TextAlign.center
                                : TextAlign.left,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "I follow Clean Architecture and SOLID principles "
                            "for scalable, testable code, enhanced with animated "
                            "counters and interactive visuals.",
                            style: theme.textTheme.bodyLarge,
                            textAlign: isMobile
                                ? TextAlign.center
                                : TextAlign.left,
                          ),
                          const SizedBox(height: 40),
                          // Statistics cards
                          RevealAnimation(
                            duration: const Duration(milliseconds: 400),
                            offset: const Offset(0, 50),
                            child: _StatisticsRow(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (!isMobile) ...[
                    const SizedBox(width: 48),
                    // Code window 3D card reveal
                    Expanded(
                      child: RevealAnimation(
                        duration: const Duration(milliseconds: 600),
                        offset: const Offset(0, 50),
                        child: CodeWindow(),
                      ),
                    ),
                  ],
                ],
              ),

              // On mobile, place code window below text
              if (isMobile) ...[
                const SizedBox(height: 40),
                const RevealAnimation(
                  duration: Duration(milliseconds: 600),
                  offset: Offset(0, 50),
                  child: CodeWindow(),
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
