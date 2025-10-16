// lib/features/portfolio/presentation/widgets/cards/project_card.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
    final size = MediaQuery.of(context).size;
    final width = size.width;

    // Responsive breakpoints
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    // Adaptive sizing
    final imageHeight = _getImageHeight(width);
    final iconSize = _getIconSize(width);
    final cardPadding = _getCardPadding(isMobile);
    final borderRadius = _getBorderRadius(isMobile);
    final techChipPadding = _getTechChipPadding(isMobile);
    final buttonHeight = _getButtonHeight(isMobile);
    final spacing = _getSpacing(isMobile);

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
                // Header Image/Icon Section
                _buildHeader(
                  context,
                  theme,
                  color,
                  imageHeight,
                  iconSize,
                  isMobile,
                ),

                // Content Section
                Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title with category badge
                      _buildTitleRow(theme, isMobile, isTablet),
                      SizedBox(height: spacing),

                      // Description
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

                      // Technologies
                      _buildTechChips(theme, techChipPadding, isMobile),
                    ],
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    cardPadding,
                    0,
                    cardPadding,
                    cardPadding,
                  ),
                  child: _buildActionButtons(theme, buttonHeight, isMobile),
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

  Widget _buildActionButtons(
    ThemeData theme,
    double buttonHeight,
    bool isMobile,
  ) {
    final hasDemo = widget.project.demoUrl != null;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: OutlinedButton.icon(
              onPressed: () => _openUrl(widget.project.githubUrl),
              icon: Icon(LucideIcons.github, size: isMobile ? 14 : 16),
              label: Text(
                isMobile ? 'Code' : 'Source',
                style: TextStyle(fontSize: isMobile ? 12 : 14),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
              ),
            ),
          ),
        ),
        if (hasDemo) ...[
          SizedBox(width: isMobile ? 6 : 8),
          Expanded(
            child: SizedBox(
              height: buttonHeight,
              child: FilledButton.icon(
                onPressed: () => _openUrl(widget.project.demoUrl!),
                icon: Icon(LucideIcons.externalLink, size: isMobile ? 14 : 16),
                label: Text(
                  'Demo',
                  style: TextStyle(fontSize: isMobile ? 12 : 14),
                ),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryBadge(ThemeData theme, bool isMobile) {
    final categoryIcon = _getCategoryIcon(widget.project.category);
    final categoryColor = _getCategoryColor(widget.project.category, theme);

    return Container(
      padding: EdgeInsets.all(isMobile ? 6 : 8),
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
        border: Border.all(color: categoryColor.withOpacity(0.3), width: 1),
      ),
      child: Icon(categoryIcon, size: isMobile ? 14 : 16, color: categoryColor),
    );
  }

  Widget _buildFeaturedBadge(ThemeData theme, bool isMobile) {
    return Positioned(
      top: isMobile ? 6 : 8,
      right: isMobile ? 6 : 8,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6 : 8,
          vertical: isMobile ? 3 : 4,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.star,
              size: isMobile ? 10 : 12,
              color: theme.colorScheme.onPrimary,
            ),
            const SizedBox(width: 4),
            Text(
              'Featured',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 10 : 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    Color color,
    double imageHeight,
    double iconSize,
    bool isMobile,
  ) {
    return Container(
      height: imageHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.05),
              ),
            ),
          ),

          // Main Icon with rotation animation
          Center(
            child: AnimatedBuilder(
              animation: _iconRotationAnim,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _iconRotationAnim.value,
                  child: child,
                );
              },
              child: Icon(
                _getProjectIcon(widget.project.category),
                size: iconSize,
                color: color,
              ),
            ),
          ),

          // Featured Badge
          if (widget.project.isFeatured) _buildFeaturedBadge(theme, isMobile),
        ],
      ),
    );
  }

  Widget _buildTechChips(ThemeData theme, EdgeInsets padding, bool isMobile) {
    // Limit technologies shown on mobile
    final techToShow = isMobile
        ? widget.project.technologies.take(4).toList()
        : widget.project.technologies;
    final hasMore = isMobile && widget.project.technologies.length > 4;

    return Wrap(
      spacing: isMobile ? 4 : 6,
      runSpacing: isMobile ? 4 : 6,
      children: [
        ...techToShow.map((tech) {
          final techIcon = _getTechnologyIcon(tech);
          return Container(
            padding: padding,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  techIcon,
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
          );
        }),
        if (hasMore)
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.plus,
                  size: isMobile ? 10 : 12,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 2),
                Text(
                  '${widget.project.technologies.length - 4}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: isMobile ? 10 : 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
      ],
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

  double _getBorderRadius(bool isMobile) => isMobile ? 12 : 16;

  double _getButtonHeight(bool isMobile) => isMobile ? 36 : 40;

  double _getCardPadding(bool isMobile) => isMobile ? 12 : 16;

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
        return LucideIcons.smartphone;
      case ProjectCategory.web:
        return LucideIcons.monitor;
      case ProjectCategory.featured:
        return LucideIcons.sparkles;
      case ProjectCategory.all:
        return LucideIcons.layoutGrid;
    }
  }

  double _getIconSize(double width) {
    if (width < 400) return 40;
    if (width < 600) return 48;
    if (width < 900) return 56;
    return 64;
  }

  // Responsive sizing methods
  double _getImageHeight(double width) {
    if (width < 400) return 100;
    if (width < 600) return 120;
    if (width < 900) return 150;
    if (width < 1200) return 170;
    return 180;
  }

  // Icon mapping methods
  IconData _getProjectIcon(ProjectCategory category) {
    switch (category) {
      case ProjectCategory.mobile:
        return LucideIcons.smartphone;
      case ProjectCategory.web:
        return LucideIcons.globe;
      case ProjectCategory.featured:
        return LucideIcons.star;
      case ProjectCategory.all:
        return LucideIcons.layoutGrid;
    }
  }

  double _getSpacing(bool isMobile) => isMobile ? 8 : 12;

  EdgeInsets _getTechChipPadding(bool isMobile) {
    return EdgeInsets.symmetric(
      horizontal: isMobile ? 6 : 8,
      vertical: isMobile ? 3 : 4,
    );
  }

  IconData _getTechnologyIcon(String tech) {
    final techLower = tech.toLowerCase();

    // Mobile & Cross-platform
    if (techLower.contains('flutter')) return LucideIcons.zap;
    if (techLower.contains('dart')) return LucideIcons.code2;
    if (techLower.contains('android')) return LucideIcons.smartphone;
    if (techLower.contains('ios')) return LucideIcons.smartphone;
    if (techLower.contains('react native')) return LucideIcons.atom;

    // Frontend
    if (techLower.contains('react')) return LucideIcons.atom;
    if (techLower.contains('vue')) return LucideIcons.triangle;
    if (techLower.contains('angular')) return LucideIcons.shield;
    if (techLower.contains('svelte')) return LucideIcons.flame;
    if (techLower.contains('html')) return LucideIcons.fileCode;
    if (techLower.contains('css')) return LucideIcons.paintbrush;
    if (techLower.contains('javascript') || techLower.contains('js')) {
      return LucideIcons.fileType;
    }
    if (techLower.contains('typescript') || techLower.contains('ts')) {
      return LucideIcons.fileType;
    }

    // Backend
    if (techLower.contains('node')) return LucideIcons.server;
    if (techLower.contains('python')) return LucideIcons.terminal;
    if (techLower.contains('java')) return LucideIcons.coffee;
    if (techLower.contains('php')) return LucideIcons.fileCode2;
    if (techLower.contains('ruby')) return LucideIcons.gem;
    if (techLower.contains('go') || techLower.contains('golang')) {
      return LucideIcons.terminal;
    }

    // Databases
    if (techLower.contains('sql') ||
        techLower.contains('postgres') ||
        techLower.contains('mysql')) {
      return LucideIcons.database;
    }
    if (techLower.contains('mongo')) return LucideIcons.leaf;
    if (techLower.contains('redis')) return LucideIcons.layers;

    // Cloud & Services
    if (techLower.contains('firebase')) return LucideIcons.flame;
    if (techLower.contains('aws')) return LucideIcons.cloud;
    if (techLower.contains('azure')) return LucideIcons.cloudCog;
    if (techLower.contains('gcp') || techLower.contains('google cloud')) {
      return LucideIcons.cloudCog;
    }
    if (techLower.contains('docker')) return LucideIcons.box;
    if (techLower.contains('kubernetes')) return LucideIcons.boxes;

    // Tools & Others
    if (techLower.contains('git')) return LucideIcons.gitBranch;
    if (techLower.contains('figma')) return LucideIcons.figma;
    if (techLower.contains('photoshop')) return LucideIcons.image;
    if (techLower.contains('graphql')) return LucideIcons.network;
    if (techLower.contains('rest') || techLower.contains('api')) {
      return LucideIcons.plug;
    }

    // Default
    return LucideIcons.code;
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(LucideIcons.alertCircle, size: 20),
                const SizedBox(width: 8),
                Text('Failed to open link: $e'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      debugPrint('Error opening URL: $e');
    }
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.blue; // Fallback color
    }
  }
}
