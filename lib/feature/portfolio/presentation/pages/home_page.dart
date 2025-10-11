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

  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  bool _showLoading = true;
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
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    if (_showLoading) {
      return LoadingScreen(
        onComplete: () => setState(() => _showLoading = false),
      );
    }

    return MagicCursorOverlay(
      enabled: isDesktop,
      child: Scaffold(
        appBar: isMobile
            ? null
            : CustomAppBar(
                onPressed: () => _toggleThemePanel(),
                currentIndex: _currentIndex,
                onSectionTapped: _navigateToSection,
                sectionTitles: _sectionTitles,
              ),
        body: Stack(
          children: [
            BlocBuilder<PortfolioBloc, PortfolioState>(
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                              ),
                          textAlign: TextAlign.center,
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
                  return Stack(
                    children: [
                      _buildMainContent(state, isMobile, isTablet),
                      if (isDesktop)
                        ScrollToTopButton(scrollController: _scrollController),
                      if (isDesktop) const PerformanceMonitor(),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Theme panel overlay
            ThemePanel(
              isVisible: _themePanelVisible,
              onClose: () => _toggleThemePanel(),
            ),
          ],
        ),
        bottomNavigationBar: isMobile
            ? NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: _navigateToSection,
                destinations: _sectionTitles
                    .asMap()
                    .entries
                    .map(
                      (e) => NavigationDestination(
                        icon: _getSectionIcon(e.key),
                        label: e.value,
                      ),
                    )
                    .toList(),
              )
            : null,
        floatingActionButton: isMobile
            ? Column(
                children: [
                  const ThemeSwitcher(),
                  IconButton(
                    icon: Icon(Icons.palette),
                    onPressed: () => setState(() => _themePanelVisible = true),
                  ),
                ],
              )
            : SizedBox.shrink(),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<PortfolioBloc>().add(const LoadPortfolioData());
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showLoading = false);
      }
    });
  }

  Widget _buildMainContent(
    PortfolioLoaded state,
    bool isMobile,
    bool isTablet,
  ) {
    final sections = [
      const HeroSection(),
      AboutSection(experiences: state.experiences),
      SkillsSection(skills: state.skills),
      ProjectsSection(
        projects: state.filteredProjects,
        selectedCategory: state.selectedCategory,
      ),
      const ContactSection(),
    ];

    if (isMobile) {
      return PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _currentIndex = i),
        children: sections,
      );
    } else if (isTablet) {
      return Row(
        children: [
          CustomNavigationRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: _navigateToSection,
            sectionTitles: _sectionTitles,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(children: sections),
            ),
          ),
        ],
      );
    } else {
      return SingleChildScrollView(
        controller: _scrollController,
        child: Column(children: sections),
      );
    }
  }

  Widget _getSectionIcon(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.home_rounded);
      case 1:
        return const Icon(Icons.person_rounded);
      case 2:
        return const Icon(Icons.code_rounded);
      case 3:
        return const Icon(Icons.work_rounded);
      case 4:
        return const Icon(Icons.contact_mail_rounded);
      default:
        return const Icon(Icons.circle);
    }
  }

  void _navigateToSection(int index) {
    setState(() => _currentIndex = index);
    if (ResponsiveHelper.isMobile(context)) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      final height = MediaQuery.of(context).size.height;
      _scrollController.animateTo(
        index * height,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleThemePanel() {
    setState(() => _themePanelVisible = !_themePanelVisible);
  }
}
