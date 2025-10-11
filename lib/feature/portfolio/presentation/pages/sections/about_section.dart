import 'package:flutter/material.dart';
import 'package:test_app/core/widgets/tilt_3d.dart';

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
                              flex: 3,
                              child: _textBlock(context, isMobile),
                            ),
                            const SizedBox(width: 48),
                            Expanded(
                              flex: 2,
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
                            Tilt3D(
                              maxTilt: 20,
                              perspective: 0.001,
                              child: const CodeWindow(),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  RevealAnimation(
                    delay: const Duration(milliseconds: 700),
                    child: const _StatisticsRow(),
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: isMobile
                        ? Alignment.center
                        : Alignment.centerRight,
                    child: CustomButton(
                      text: 'Download Resume',
                      icon: Icons.download,
                      onPressed: () {},
                      type: CustomButtonType.outline,
                      fullWidth: isMobile,
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

  Widget _textBlock(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    return RevealAnimation(
      delay: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            "I'm a dedicated Flutter developer with a passion for creating exceptional mobile and web experiences. My journey has led me to specialize in cross-platform development with magical animations and effects.",
            style: theme.textTheme.bodyLarge,
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
          const SizedBox(height: 24),
          Text(
            "I follow Clean Architecture and SOLID principles for scalable, testable code, enhanced with animated counters and interactive visuals.",
            style: theme.textTheme.bodyLarge,
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ],
      ),
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
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final cardWidth = isMobile
        ? MediaQuery.sizeOf(context).width - 32
        : isTablet
        ? MediaQuery.sizeOf(context).width / 3
        : MediaQuery.sizeOf(context).width / 4;
    return SizedBox(
      width: cardWidth,
      child: Card(
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _StatCard(
              value: s['value'] as int,
              label: s['label'] as String,
              icon: s['icon'] as IconData,
            ),
          );
        }).toList(),
      );
    }

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
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
    );
  }
}
