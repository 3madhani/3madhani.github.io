import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/widgets/performance_monitor.dart';
import 'package:test_app/feature/portfolio/data/personal_data.dart';

// Core utilities & widgets
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/loading_screen.dart';
import '../../../../core/widgets/magic_cursor.dart';
import '../../../../core/widgets/scroll_to_top.dart';
import '../../../../core/widgets/theme_panel.dart';
import '../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../bloc/portfolio_bloc/portfolio_event.dart';
import '../bloc/portfolio_bloc/portfolio_state.dart';
// Navigation widgets
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/navigation/navigation_rail.dart';
import 'sections/about_section.dart';
import 'sections/contact_section.dart';
// Main sections
import 'sections/hero_section.dart';
import 'sections/projects_section.dart';
import 'sections/skills_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _AppBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int currentIndex;
  final void Function(int) onSectionTapped;
  final List<String> sectionTitles;
  final String titleText;
  final VoidCallback? onPalettePressed;
  final Widget? leading;

  const _AppBarHeaderDelegate({
    this.leading,
    required this.currentIndex,
    required this.onSectionTapped,
    required this.sectionTitles,
    required this.titleText,
    this.onPalettePressed,
  });

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return CustomAppBar(
      leading: leading,
      currentIndex: currentIndex,
      sectionTitles: sectionTitles,
      onSectionTapped: onSectionTapped,
      titleText: titleText,
      onPalettePressed: onPalettePressed,
    );
  }

  @override
  bool shouldRebuild(covariant _AppBarHeaderDelegate oldDelegate) {
    return oldDelegate.currentIndex != currentIndex ||
        oldDelegate.sectionTitles != sectionTitles ||
        oldDelegate.titleText != titleText;
  }
}

class _HomePageState extends State<HomePage> {
  static const List<String> _sectionTitles = [
    'Home',
    'About',
    'Skills',
    'Projects',
    'Contact',
  ];
  bool _themePanelVisible = false;
  bool _showLoading = true;
  int _currentIndex = 0;
  late final ScrollController _scrollController;

  late final List<GlobalKey> _sectionKeys;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    if (_showLoading) {
      return LoadingScreen(
        onComplete: () {
          if (mounted) {
            setState(() => _showLoading = false);
          }
        },
      );
    }

    return MagicCursorOverlay(
      enabled: isDesktop,
      child: Scaffold(
        drawerScrimColor: Colors.transparent,
        drawer: !isDesktop ? _buildDrawer() : null,
        body: SafeArea(
          child: Stack(
            children: [
              _buildMainContent(isDesktop),
              const PerformanceMonitor(),
              if (isDesktop)
                ScrollToTopButton(scrollController: _scrollController),
              ThemePanel(
                isVisible: _themePanelVisible,
                onClose: () {
                  if (mounted) {
                    setState(() => _themePanelVisible = false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _sectionKeys = List.generate(5, (_) => GlobalKey());

    context.read<PortfolioBloc>().add(const LoadPortfolioData());

    // Add listener after frame is built to avoid layout issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollController.addListener(_onScroll);
      }
    });
  }

  Widget _buildDrawer() {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      backgroundColor: Colors.transparent,
      child: CustomNavigationRail(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          Navigator.pop(context);
          _scrollTo(i);
        },
        sectionTitles: _sectionTitles,
      ),
    );
  }

  Widget _buildError(String message) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Error: $message',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  context.read<PortfolioBloc>().add(const LoadPortfolioData()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 400,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildMainContent(bool isDesktop) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _AppBarHeaderDelegate(
            leading: !isDesktop ? _buildMenuButton() : null,
            currentIndex: _currentIndex,
            sectionTitles: isDesktop ? _sectionTitles : const [],
            onSectionTapped: _scrollTo,
            titleText: contactName,
            onPalettePressed: _toggleThemePanel,
          ),
        ),
        SliverToBoxAdapter(
          child: BlocBuilder<PortfolioBloc, PortfolioState>(
            builder: (context, state) {
              if (state is PortfolioLoading) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildLoadingState()],
                );
              }
              if (state is PortfolioError) {
                return _buildError(state.message);
              }
              if (state is PortfolioLoaded) {
                return _buildSections(state);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton() {
    return Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }

  Widget _buildSections(PortfolioLoaded state) {
    return Column(
      children: [
        SizedBox(
          key: _sectionKeys[0],
          child: HeroSection(
            scrollController: _scrollController,
            onViewProjects: () => _scrollTo(3),
            onContactMe: () => _scrollTo(4),
          ),
        ),
        SizedBox(
          key: _sectionKeys[1],
          child: AboutSection(
            experiences: state.experiences,
            projects: state.projects,
          ),
        ),
        SizedBox(
          key: _sectionKeys[2],
          child: SkillsSection(skills: state.skills),
        ),
        SizedBox(
          key: _sectionKeys[3],
          child: ProjectsSection(
            projects: state.filteredProjects,
            selectedCategory: state.selectedCategory,
          ),
        ),
        SizedBox(key: _sectionKeys[4], child: const ContactSection()),
      ],
    );
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;

    try {
      final offset = _scrollController.offset;
      final height = MediaQuery.of(context).size.height;

      for (var i = 0; i < _sectionKeys.length; i++) {
        final ctx = _sectionKeys[i].currentContext;
        if (ctx == null || !ctx.mounted) continue;

        final renderBox = ctx.findRenderObject();
        if (renderBox is! RenderBox ||
            !renderBox.hasSize ||
            !renderBox.attached) {
          continue;
        }

        try {
          final pos = renderBox.localToGlobal(Offset.zero).dy + offset;
          final sectionHeight = renderBox.size.height;

          if (offset >= pos - height / 2 &&
              offset < pos + sectionHeight - height / 2) {
            if (_currentIndex != i && mounted) {
              setState(() => _currentIndex = i);
            }
            break;
          }
        } catch (_) {
          // Ignore errors during coordinate transformation
          continue;
        }
      }
    } catch (_) {
      // Ignore any unexpected errors
    }
  }

  void _scrollTo(int index) {
    if (index < 0 || index >= _sectionKeys.length) return;

    final ctx = _sectionKeys[index].currentContext;
    if (ctx != null && ctx.mounted) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );

      if (mounted) {
        setState(() => _currentIndex = index);
      }
    }
  }

  void _toggleThemePanel() {
    if (mounted) {
      setState(() => _themePanelVisible = !_themePanelVisible);
    }
  }
}
