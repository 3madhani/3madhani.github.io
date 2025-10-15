// lib/features/portfolio/presentation/widgets/cards/project_card.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/project.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _elevationAnim;
  late final Animation<double> _scaleAnim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(
      int.parse(widget.project.color.replaceAll('#', '0xFF')),
    );
    // Adjust image height for responsiveness
    final width = MediaQuery.of(context).size.width;
    final imageHeight = width < 600
        ? 120.0
        : width < 900
        ? 140.0
        : 160.0;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnim.value, child: child);
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: Card(
            shadowColor: color,
            elevation: _elevationAnim.value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Image/icon area
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: imageHeight,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.3),
                            color.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.flutter_dash,
                              size: imageHeight * 0.4,
                              color: color,
                            ),
                          ),
                          if (widget.project.isFeatured)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '✨ Featured',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.project.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.project.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: widget.project.technologies.map((tech) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tech,
                                  style: theme.textTheme.bodySmall,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _openUrl(widget.project.githubUrl),
                          icon: const Icon(Icons.code, size: 16),
                          label: const Text('Source'),
                        ),
                      ),
                      if (widget.project.demoUrl != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _openUrl(widget.project.demoUrl!),
                            icon: const Icon(Icons.launch, size: 16),
                            label: const Text('Demo'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _elevationAnim = Tween<double>(
      begin: 2,
      end: 12,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  void _onHover(bool hover) {
    if (hover) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
