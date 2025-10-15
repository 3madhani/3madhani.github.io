import 'package:flutter/material.dart';
import 'package:test_app/core/widgets/animated_text.dart';
import 'package:test_app/core/widgets/magnetic_button.dart';
import 'package:test_app/feature/portfolio/presentation/widgets/navigation/theme_switcher.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final void Function(int) onSectionTapped;
  final List<String> sectionTitles;
  final String titleText; // from fetched data
  final VoidCallback? onPalettePressed;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.currentIndex,
    required this.onSectionTapped,
    required this.sectionTitles,
    required this.titleText,
    this.onPalettePressed,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.85),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          leading ?? SizedBox.shrink(),
          // Logo & Title
          MagneticButton(
            radius: 28,
            onTap: () {},
            child: Icon(
              Icons.flutter_dash,
              color: theme.colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          AnimatedText(
            text: titleText,
            type: AnimationTextType.glitch,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          // Section links
          for (var i = 0; i < sectionTitles.length; i++) ...[
            TextButton(
              onPressed: () => onSectionTapped(i),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(0, 48),
              ),
              child: Text(
                sectionTitles[i],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: i == currentIndex
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: i == currentIndex
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          ],

          const SizedBox(width: 16),
          const ThemeSwitcher(),
          const SizedBox(width: 16),
          MagneticButton(
            radius: 20,
            onTap: onPalettePressed,
            child: Icon(Icons.palette, color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
