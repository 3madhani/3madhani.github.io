import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  late final Animation<double> _iconRotationAnim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    final imageHeight = _getImageHeight(width);
    final iconSize = _getIconSize(width);
    final cardPadding = isMobile ? 12.0 : 16.0;
    final borderRadius = isMobile ? 12.0 : 16.0;
    final spacing = isMobile ? 8.0 : 12.0;
    final color = _parseColor(widget.project.color);

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
            shadowColor: color.withOpacity(0.5),
            elevation: _elevationAnim.value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(theme, color, imageHeight, iconSize, isMobile),
                Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleRow(theme, isMobile, isTablet),
                      SizedBox(height: spacing),
                      Text(
                        widget.project.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: isMobile ? 12 : 14,
                          height: 1.5,
                        ),
                        maxLines: isMobile ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing * 1.5),
                      _buildTechChips(theme, isMobile),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: _buildActionButtons(theme, isMobile),
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
      end: 1.03,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
    _iconRotationAnim = Tween<double>(
      begin: 0,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  Widget _buildActionButtons(ThemeData theme, bool isMobile) {
    final hasDemo = widget.project.demoUrl != null;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _openUrl(widget.project.githubUrl),
            icon: const Icon(FontAwesomeIcons.github, size: 14),
            label: Text(isMobile ? 'Code' : 'Source'),
          ),
        ),
        if (hasDemo) ...[
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton.icon(
              onPressed: () => _openUrl(widget.project.demoUrl!),
              icon: const Icon(
                FontAwesomeIcons.arrowUpRightFromSquare,
                size: 14,
              ),
              label: const Text('Demo'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryBadge(ThemeData theme, bool isMobile) {
    final icon = _getCategoryIcon(widget.project.category);
    final color = _getCategoryColor(widget.project.category, theme);

    return Container(
      padding: EdgeInsets.all(isMobile ? 6 : 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Icon(icon, size: isMobile ? 14 : 16, color: color),
    );
  }

  Widget _buildFallbackIcon(Color color, double iconSize) {
    return Center(
      child: AnimatedBuilder(
        animation: _iconRotationAnim,
        builder: (context, child) {
          return Transform.rotate(angle: _iconRotationAnim.value, child: child);
        },
        child: Icon(
          _getProjectIcon(widget.project.category),
          size: iconSize,
          color: color,
        ),
      ),
    );
  }

  Widget _buildFeaturedBadge(ThemeData theme, bool isMobile) {
    return Positioned(
      top: isMobile ? 6 : 8,
      right: isMobile ? 6 : 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FontAwesomeIcons.star, size: 10, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              'Featured',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 10 : 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    Color color,
    double imageHeight,
    double iconSize,
    bool isMobile,
  ) {
    final hasImage =
        widget.project.imageUrl != null && widget.project.imageUrl!.isNotEmpty;

    return Container(
      height: imageHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            CachedNetworkImage(
              imageUrl: widget.project.imageUrl!,
              fit: BoxFit.fitHeight,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(color.withOpacity(0.6)),
                ),
              ),
              errorWidget: (context, url, error) =>
                  _buildFallbackIcon(color, iconSize),
            )
          else
            _buildFallbackIcon(color, iconSize),
          if (widget.project.isFeatured) _buildFeaturedBadge(theme, isMobile),
        ],
      ),
    );
  }

  Widget _buildTechChips(ThemeData theme, bool isMobile) {
    final techs = isMobile
        ? widget.project.technologies.take(4).toList()
        : widget.project.technologies;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: techs
          .map(
            (tech) => Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 6 : 8,
                vertical: isMobile ? 3 : 4,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getTechnologyIcon(tech),
                    size: isMobile ? 10 : 12,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tech,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTitleRow(ThemeData theme, bool isMobile, bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.project.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isMobile
                  ? 16
                  : isTablet
                  ? 18
                  : 20,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        _buildCategoryBadge(theme, isMobile),
      ],
    );
  }

  Color _getCategoryColor(ProjectCategory category, ThemeData theme) {
    switch (category) {
      case ProjectCategory.mobile:
        return Colors.blue;
      case ProjectCategory.web:
        return Colors.purple;
      case ProjectCategory.featured:
        return theme.colorScheme.primary;
      case ProjectCategory.all:
        return theme.colorScheme.secondary;
    }
  }

  IconData _getCategoryIcon(ProjectCategory category) {
    switch (category) {
      case ProjectCategory.mobile:
        return FontAwesomeIcons.mobile;
      case ProjectCategory.web:
        return FontAwesomeIcons.display;
      case ProjectCategory.featured:
        return FontAwesomeIcons.star;
      case ProjectCategory.all:
        return FontAwesomeIcons.layerGroup;
    }
  }

  double _getIconSize(double width) {
    if (width < 400) return 40;
    if (width < 600) return 48;
    if (width < 900) return 56;
    return 64;
  }

  double _getImageHeight(double width) {
    if (width < 400) return 100;
    if (width < 600) return 120;
    if (width < 900) return 150;
    return 180;
  }

  IconData _getProjectIcon(ProjectCategory category) {
    switch (category) {
      case ProjectCategory.mobile:
        return FontAwesomeIcons.mobileScreen;
      case ProjectCategory.web:
        return FontAwesomeIcons.globe;
      case ProjectCategory.featured:
        return FontAwesomeIcons.star;
      case ProjectCategory.all:
        return FontAwesomeIcons.shapes;
    }
  }

  IconData _getTechnologyIcon(String tech) {
    final t = tech.toLowerCase();
    if (t.contains('flutter')) return FontAwesomeIcons.bolt;
    if (t.contains('dart')) return FontAwesomeIcons.code;
    if (t.contains('firebase')) return FontAwesomeIcons.fire;
    if (t.contains('node')) return FontAwesomeIcons.server;
    if (t.contains('python')) return FontAwesomeIcons.python;
    if (t.contains('java')) return FontAwesomeIcons.java;
    if (t.contains('git')) return FontAwesomeIcons.gitAlt;
    if (t.contains('figma')) return FontAwesomeIcons.figma;
    return FontAwesomeIcons.code;
  }

  void _onHover(bool hover) {
    if (mounted) {
      if (hover) {
        _hoverController.forward();
      } else {
        _hoverController.reverse();
      }
    }
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to open link: $e')));
      }
    }
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }
}
