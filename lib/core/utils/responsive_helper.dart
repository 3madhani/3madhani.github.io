import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;

  // Device types
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  // Responsive values
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return desktop;
  }

  // Grid columns
  static int getGridColumns(BuildContext context) {
    return responsiveValue(context, mobile: 1, tablet: 2, desktop: 3);
  }

  // Padding
  static EdgeInsets getScreenPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsiveValue(
        context,
        mobile: 16.0,
        tablet: 32.0,
        desktop: 64.0,
      ),
    );
  }

  // Font sizes
  static double getHeroFontSize(BuildContext context) {
    return responsiveValue(context, mobile: 32.0, tablet: 48.0, desktop: 64.0);
  }

  static double getSectionTitleSize(BuildContext context) {
    return responsiveValue(context, mobile: 24.0, tablet: 32.0, desktop: 40.0);
  }

  // Layout helpers
  static Widget buildResponsiveRow(
    BuildContext context, {
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    if (isMobile(context)) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }

  // Navigation type
  static NavigationType getNavigationType(BuildContext context) {
    if (isMobile(context)) return NavigationType.bottom;
    if (isTablet(context)) return NavigationType.rail;
    return NavigationType.rail;
  }
}

enum NavigationType { bottom, rail, drawer }
