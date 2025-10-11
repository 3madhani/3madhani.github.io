// lib/features/portfolio/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core utilities & widgets
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/loading_screen.dart';
import '../../../../core/widgets/magic_cursor.dart';
import '../../../../core/widgets/performance_monitor.dart';
import '../../../../core/widgets/scroll_to_top.dart';
// Portfolio BLoC
import '../../../../core/widgets/theme_panel.dart';
import '../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../bloc/portfolio_bloc/portfolio_event.dart';
import '../bloc/portfolio_bloc/portfolio_state.dart';
// Navigation widgets
import '../widgets/navigation/custom_app_bar.dart';
import '../widgets/navigation/navigation_rail.dart';
import '../widgets/navigation/theme_switcher.dart';
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

class _HomePageState extends State<HomePage> {
  bool _themePanelVisible = false;
  bool _showLoading = true;
  int _currentIndex = 0;

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());
  final List<String> _sectionTitles = [
    'Home',
    'About',
    'Skills',
    'Projects',
    'Contact',
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    if (_showLoading) {
      return LoadingScreen(
        onComplete: () => setState(() => _showLoading = false),
      );
    }

    return MagicCursorOverlay(
      enabled: isDesktop,
      child: Scaffold(
        drawer: isMobile
            ? Drawer(
                child: CustomNavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (i) {
                    Navigator.pop(context);
                    _scrollTo(i);
                  },
                  sectionTitles: _sectionTitles,
                ),
              )
            : null,
        appBar: isMobile
            ? AppBar(
                title: const Text('Emad Hany'),
                leading: Builder(
                  builder: (ctx) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    );
                  },
                ),
                actions: [
                  const ThemeSwitcher(),
                  IconButton(
                    icon: const Icon(Icons.palette),
                    onPressed: () => setState(() => _themePanelVisible = true),
                  ),
                ],
              )
            : CustomAppBar(
                onPressed: () =>
                    setState(() => _themePanelVisible = !_themePanelVisible),
                currentIndex: _currentIndex,
                onSectionTapped: _scrollTo,
                sectionTitles: _sectionTitles,
              ),
        body: BlocBuilder<PortfolioBloc, PortfolioState>(
          builder: (context, state) {
            if (state is PortfolioLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PortfolioError) {
              return Center(
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
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.read<PortfolioBloc>().add(
                        const LoadPortfolioData(),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state is PortfolioLoaded) {
              final sections = [
                Container(key: _sectionKeys[0], child: const HeroSection()),
                Container(
                  key: _sectionKeys[1],
                  child: AboutSection(experiences: state.experiences),
                ),
                Container(
                  key: _sectionKeys[2],
                  child: SkillsSection(skills: state.skills),
                ),
                Container(
                  key: _sectionKeys[3],
                  child: ProjectsSection(
                    projects: state.filteredProjects,
                    selectedCategory: state.selectedCategory,
                  ),
                ),
                Container(key: _sectionKeys[4], child: const ContactSection()),
              ];

              final content = SingleChildScrollView(
                controller: _scrollController,
                child: Column(children: sections),
              );

              return Stack(
                children: [
                  content,
                  if (isDesktop) ...[
                    ScrollToTopButton(scrollController: _scrollController),
                    const PerformanceMonitor(),
                  ],
                  ThemePanel(
                    isVisible: _themePanelVisible,
                    onClose: () => setState(() => _themePanelVisible = false),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: !isDesktop
            ? ScrollToTopButton(scrollController: _scrollController)
            : null,
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
    context.read<PortfolioBloc>().add(const LoadPortfolioData());
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showLoading = false);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final height = MediaQuery.of(context).size.height;
    for (var i = 0; i < _sectionKeys.length; i++) {
      final key = _sectionKeys[i];
      final ctx = key.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final pos = box.localToGlobal(Offset.zero).dy + offset;
        if (offset >= pos - height / 2 &&
            offset < pos + box.size.height - height / 2) {
          if (_currentIndex != i) setState(() => _currentIndex = i);
          break;
        }
      }
    }
  }

  void _scrollTo(int index) {
    final key = _sectionKeys[index];
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
    setState(() => _currentIndex = index);
  }
}
