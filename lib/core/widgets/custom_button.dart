// lib/core/widgets/custom_button.dart

import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

enum CustomButtonType { primary, secondary, outline, ghost, magical }

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _glowAnim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) =>
          Transform.scale(scale: _scaleAnim.value, child: child),
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: _buildButton(theme, padding),
      ),
    );
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
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _glowAnim = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  Widget _buildButton(ThemeData theme, EdgeInsets padding) {
    final icon = widget.icon;
    final isLoading = widget.isLoading;

    switch (widget.type) {
      case CustomButtonType.primary:
        return FilledButton.icon(
          onPressed: isLoading ? null : widget.onPressed,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(icon, color: theme.colorScheme.onPrimary),
          label: Text(widget.text),
          style: FilledButton.styleFrom(
            padding: padding,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
        );
      case CustomButtonType.secondary:
        return FilledButton.tonalIcon(
          onPressed: isLoading ? null : widget.onPressed,
          icon: Icon(icon, color: theme.colorScheme.onSecondaryContainer),
          label: Text(widget.text),
          style: FilledButton.styleFrom(
            padding: padding,
            foregroundColor: theme.colorScheme.onSecondaryContainer,
          ),
        );
      case CustomButtonType.outline:
        return OutlinedButton.icon(
          onPressed: isLoading ? null : widget.onPressed,
          icon: Icon(icon),
          label: Text(widget.text),
          style: OutlinedButton.styleFrom(padding: padding),
        );
      case CustomButtonType.ghost:
        return TextButton.icon(
          onPressed: isLoading ? null : widget.onPressed,
          icon: Icon(icon),
          label: Text(widget.text),
          style: TextButton.styleFrom(padding: padding),
        );
      case CustomButtonType.magical:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(
                  _glowAnim.value * 0.3,
                ),
                blurRadius: 20 * _glowAnim.value,
                spreadRadius: 2 * _glowAnim.value,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: padding,
                child: Row(
                  mainAxisSize: widget.fullWidth
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    else if (icon != null) ...[
                      Icon(icon, color: Colors.white),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }

  void _onHover(bool hover) {
    if (hover)
      _controller.forward();
    else
      _controller.reverse();
  }
}
