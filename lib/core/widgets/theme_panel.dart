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
              Expanded(
                child: Container(
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
  late final AnimationController _controller;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  final List<_ThemePreset> _presets = [
    _ThemePreset(
      name: 'Golden Elegance',
      colors: [Color(0xFFD4AF37), Color(0xFFB8860B), Color(0xFFFFF8DC)],
    ),
    _ThemePreset(
      name: 'Sunset Glow',
      colors: [Color(0xFFFF6F61), Color(0xFFFFB88C), Color(0xFFFBB13C)],
    ),
    _ThemePreset(
      name: 'Aurora Night',
      colors: [Color(0xFF00BFA6), Color(0xFF00E5FF), Color(0xFFFF4081)],
    ),
    _ThemePreset(
      name: 'Mint Fresh',
      colors: [Color(0xFF00C9A7), Color(0xFFB2F7EF), Color(0xFF3EECAC)],
    ),
    _ThemePreset(
      name: 'Ocean Breeze',
      colors: [Color(0xFF0277BD), Color(0xFF29B6F6), Color(0xFF81D4FA)],
    ),
    _ThemePreset(
      name: 'Noir Minimal',
      colors: [Color(0xFF121212), Color(0xFF1E1E1E), Color(0xFF2C2C2C)],
    ),
    _ThemePreset(
      name: 'Royal Violet',
      colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFBA68C8)],
    ),
    _ThemePreset(
      name: 'Coral Dream',
      colors: [Color(0xFFFF9A8B), Color(0xFFFF6A88), Color(0xFFFF99AC)],
    ),
    _ThemePreset(
      name: 'Cyber Wave',
      colors: [Color(0xFF00C6FF), Color(0xFF0072FF), Color(0xFF00E5FF)],
    ),
    _ThemePreset(
      name: 'Emerald Mist',
      colors: [Color(0xFF11998E), Color(0xFF38EF7D), Color(0xFFA8E063)],
    ),
    _ThemePreset(
      name: 'Forest Harmony',
      colors: [Color(0xFF2E7D32), Color(0xFF4CAF50), Color(0xFF81C784)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!widget.isVisible && !_controller.isAnimating) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Positioned(
        top: 80,
        right: 16,
        child: Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Material(
              elevation: 10,
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose Your Magic ✨',
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

                    // Presets
                    Text(
                      'Theme Presets',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _presets.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.5,
                          ),
                      itemBuilder: (_, index) {
                        final preset = _presets[index];
                        return _ThemeOption(
                          name: preset.name,
                          colors: preset.colors,
                          onTap: () => _selectTheme(preset.colors.first),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Custom Color
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
                            builder: (_, state) => Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: state.seedColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ),
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
      ),
    );
  }

  @override
  void didUpdateWidget(ThemePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      widget.isVisible ? _controller.forward() : _controller.reverse();
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a Color'),
        content: ColorPicker(
          pickerColor: context.read<ThemeCubit>().state.seedColor,
          onColorChanged: (color) =>
              context.read<ThemeCubit>().updateSeedColor(color),
          paletteType: PaletteType.hsv,
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class _ThemePreset {
  final String name;
  final List<Color> colors;

  const _ThemePreset({required this.name, required this.colors});
}
