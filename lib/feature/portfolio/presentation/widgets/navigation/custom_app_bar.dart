import 'package:flutter/material.dart';
import 'package:test_app/core/widgets/animated_text.dart';
import 'package:test_app/core/widgets/magnetic_button.dart';
import 'package:test_app/feature/portfolio/presentation/widgets/navigation/theme_switcher.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final Function(int) onSectionTapped;
  final List<String> sectionTitles;
  final void Function()? onPressed;

  const CustomAppBar({
    this.onPressed,
    super.key,
    required this.currentIndex,
    required this.onSectionTapped,
    required this.sectionTitles,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
      elevation: 2,
      title: Row(
        children: [
          Icon(Icons.flutter_dash, color: theme.colorScheme.primary, size: 32),
          const SizedBox(width: 12),
          AnimatedText(text: 'Portfolio', type: AnimationTextType.glitch),
        ],
      ),
      actions: [
        ...sectionTitles.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isActive = index == currentIndex;

          return TextButton(
            onPressed: () => onSectionTapped(index),
            child: Text(
              title,
              style: TextStyle(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }),

        ThemeSwitcher(),

        MagneticButton(
          radius: 20,
          onTap: onPressed ?? () {},
          child: Icon(Icons.palette, color: theme.colorScheme.onSurface),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
