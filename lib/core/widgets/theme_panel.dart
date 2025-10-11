import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../feature/portfolio/presentation/bloc/theme_cubit/theme_cubit.dart';
import '../../feature/portfolio/presentation/bloc/theme_cubit/theme_state.dart';

class ThemePanel extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const ThemePanel({super.key, required this.isVisible, required this.onClose});

  @override
  State<ThemePanel> createState() => _ThemePanelState();
}

class _ThemeOption extends StatefulWidget {
  final String name;
  final List<Color> colors;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.name,
    required this.colors,
    required this.onTap,
  });

  @override
  State<_ThemeOption> createState() => _ThemeOptionState();
}

class _ThemeOptionState extends State<_ThemeOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -2.0))
              : Matrix4.identity(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color Preview
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.name,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemePanelState extends State<ThemePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!widget.isVisible && !_controller.isAnimating) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: 80,
          right: 16,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Choose Your Magic',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: widget.onClose,
                            icon: const Icon(Icons.close),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Predefined Themes
                      Text(
                        'Theme Presets',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.5,
                        children: [
                          _ThemeOption(
                            name: 'Ocean',
                            colors: [
                              const Color(0xFF0077BE),
                              const Color(0xFF20B2AA),
                            ],
                            onTap: () => _selectTheme(const Color(0xFF0077BE)),
                          ),
                          _ThemeOption(
                            name: 'Sunset',
                            colors: [
                              const Color(0xFFFF6B35),
                              const Color(0xFFFF1744),
                            ],
                            onTap: () => _selectTheme(const Color(0xFFFF6B35)),
                          ),
                          _ThemeOption(
                            name: 'Forest',
                            colors: [
                              const Color(0xFF2E7D32),
                              const Color(0xFF795548),
                            ],
                            onTap: () => _selectTheme(const Color(0xFF2E7D32)),
                          ),
                          _ThemeOption(
                            name: 'Neon',
                            colors: [
                              const Color.fromARGB(255, 231, 3, 79),
                              const Color.fromARGB(255, 2, 210, 233),
                            ],
                            onTap: () => _selectTheme(const Color(0xFFE91E63)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Custom Color Picker
                      Text(
                        'Custom Seed Color',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<ThemeCubit, ThemeState>(
                              builder: (context, state) {
                                return Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: state.seedColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: _showColorPicker,
                            child: const Text('Pick'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(ThemePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 20,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _selectTheme(Color seedColor) {
    context.read<ThemeCubit>().updateSeedColor(seedColor);
    widget.onClose();
  }

  void _showColorPicker() {
    // Implement color picker dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a Color'),
        content: ColorPicker(
          pickerColor: context.read<ThemeCubit>().state.seedColor,
          onColorChanged: (color) {
            context.read<ThemeCubit>().updateSeedColor(color);
          },
          paletteType: PaletteType.hsv,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // Apply selected color
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
