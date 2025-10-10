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
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return MouseRegion(
          onEnter: (_) => _onHover(true),
          onExit: (_) => _onHover(false),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.fullWidth ? double.infinity : null,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: widget.type == CustomButtonType.magical
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(
                            0.3 * _glowAnimation.value,
                          ),
                          blurRadius: 20 * _glowAnimation.value,
                          spreadRadius: 2 * _glowAnimation.value,
                        ),
                      ]
                    : null,
              ),
              child: _buildButton(context, theme),
            ),
          ),
        );
      },
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
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  Widget _buildButton(BuildContext context, ThemeData theme) {
    final buttonPadding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    switch (widget.type) {
      case CustomButtonType.primary:
        return FilledButton.icon(
          onPressed: widget.isLoading ? null : widget.onPressed,
          icon: _buildIcon(theme.colorScheme.onPrimary),
          label: _buildLabel(theme.colorScheme.onPrimary),
          style: FilledButton.styleFrom(padding: buttonPadding),
        );

      case CustomButtonType.secondary:
        return FilledButton.tonalIcon(
          onPressed: widget.isLoading ? null : widget.onPressed,
          icon: _buildIcon(theme.colorScheme.onSecondaryContainer),
          label: _buildLabel(theme.colorScheme.onSecondaryContainer),
          style: FilledButton.styleFrom(padding: buttonPadding),
        );

      case CustomButtonType.outline:
        return OutlinedButton.icon(
          onPressed: widget.isLoading ? null : widget.onPressed,
          icon: _buildIcon(theme.colorScheme.primary),
          label: _buildLabel(theme.colorScheme.primary),
          style: OutlinedButton.styleFrom(padding: buttonPadding),
        );

      case CustomButtonType.ghost:
        return TextButton.icon(
          onPressed: widget.isLoading ? null : widget.onPressed,
          icon: _buildIcon(theme.colorScheme.primary),
          label: _buildLabel(theme.colorScheme.primary),
          style: TextButton.styleFrom(padding: buttonPadding),
        );

      case CustomButtonType.magical:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: buttonPadding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      _buildIcon(Colors.white),
                      const SizedBox(width: 8),
                    ],
                    _buildLabel(Colors.white),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }

  Widget _buildIcon(Color color) {
    if (widget.isLoading) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (widget.icon != null) {
      return Icon(widget.icon, color: color, size: 18);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLabel(Color color) {
    return Text(
      widget.text,
      style: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }

  void _onHover(bool hovered) {
    setState(() {
      _isHovered = hovered;
    });

    if (hovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }
}
