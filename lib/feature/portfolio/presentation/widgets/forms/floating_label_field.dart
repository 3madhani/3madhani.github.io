import 'package:flutter/material.dart';

class FloatingLabelField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const FloatingLabelField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<FloatingLabelField> createState() => _FloatingLabelFieldState();
}

class _FloatingLabelFieldState extends State<FloatingLabelField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _focusAnimation;

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    _focusAnimation = ColorTween(
      begin: theme.colorScheme.outline,
      end: theme.colorScheme.primary,
    ).animate(_animationController);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          validator: widget.validator,
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _focusAnimation.value!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _focusAnimation.value!, width: 2),
            ),
            filled: true,
            fillColor: _isFocused
                ? theme.colorScheme.primaryContainer.withOpacity(0.1)
                : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });

      if (_isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
}
