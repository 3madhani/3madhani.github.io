import 'package:flutter/material.dart';

import '../../feature/portfolio/presentation/widgets/animations/reveal_animation.dart';
import '../utils/responsive_helper.dart';

class SectionWrapper extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final bool enableRevealAnimation;
  final Duration? animationDelay;

  const SectionWrapper({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.enableRevealAnimation = true,
    this.animationDelay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    final sectionContent = Container(
      width: double.infinity,
      color: backgroundColor,
      padding:
          padding ??
          ResponsiveHelper.getScreenPadding(
            context,
          ).copyWith(top: isMobile ? 60 : 100, bottom: isMobile ? 60 : 100),
      child: Column(
        children: [
          if (title != null || subtitle != null) ...[
            // Section Header
            Column(
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: ResponsiveHelper.getSectionTitleSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                if (subtitle != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    subtitle!,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 48),
          ],

          // Section Content
          child,
        ],
      ),
    );

    if (enableRevealAnimation) {
      return RevealAnimation(
        duration: const Duration(milliseconds: 800),
        offset: const Offset(0, 50),
        child: sectionContent,
      );
    }

    return sectionContent;
  }
}
