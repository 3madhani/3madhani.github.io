import 'package:flutter/material.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;
  final double showOffset;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
    this.showOffset = 500,
  });

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!_isVisible && !_controller.isAnimating) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 80,
          right: 20,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 4,
                child: const Icon(Icons.keyboard_arrow_up),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
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

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _slideAnimation = Tween<double>(
      begin: 20.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final isVisible = widget.scrollController.offset > widget.showOffset;

    if (isVisible != _isVisible) {
      setState(() {
        _isVisible = isVisible;
      });

      if (isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
