import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/widgets/animated_text.dart';
import 'package:test_app/core/widgets/custom_button.dart';

import '../../bloc/theme_cubit/theme_cubit.dart';
import '../../bloc/theme_cubit/theme_state.dart';

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

        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return IconButton(
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              icon: Icon(_getThemeIcon(state.themeMode)),
            );
          },
        ),

        CustomButton(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          text: "Color Theme",
          onPressed: onPressed,
          type: CustomButtonType.ghost,
          icon: Icons.color_lens_rounded,
        ),
        SizedBox(width: 10),
      ],
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
