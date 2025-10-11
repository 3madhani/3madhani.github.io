// lib/core/utils/responsive_grid_delegate.dart

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverGridDelegateWithResponsiveColumns extends SliverGridDelegate {
  final BuildContext context;
  final double minItemWidth;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  const SliverGridDelegateWithResponsiveColumns({
    required this.context,
    required this.minItemWidth,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.childAspectRatio = 1.0,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final availableWidth = constraints.crossAxisExtent;

    // Calculate number of columns based on minimum item width
    final crossAxisCount = (availableWidth / minItemWidth).floor().clamp(2, 8);

    // Calculate actual item width
    final itemWidth =
        (availableWidth - (crossAxisSpacing * (crossAxisCount - 1))) /
        crossAxisCount;

    // Calculate item height based on aspect ratio
    final itemHeight = itemWidth / childAspectRatio;

    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: itemHeight + mainAxisSpacing,
      crossAxisStride: itemWidth + crossAxisSpacing,
      childMainAxisExtent: itemHeight,
      childCrossAxisExtent: itemWidth,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(covariant SliverGridDelegate oldDelegate) {
    if (oldDelegate is! SliverGridDelegateWithResponsiveColumns) return true;

    return oldDelegate.minItemWidth != minItemWidth ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.childAspectRatio != childAspectRatio;
  }
}

// Helper extension for easier usage
extension ResponsiveGridView on GridView {
  static GridView responsiveBuilder({
    Key? key,
    required BuildContext context,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    double minItemWidth = 250,
    double crossAxisSpacing = 0,
    double mainAxisSpacing = 0,
    double childAspectRatio = 1.0,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
    EdgeInsets? padding,
  }) {
    return GridView.builder(
      key: key,
      gridDelegate: SliverGridDelegateWithResponsiveColumns(
        context: context,
        minItemWidth: minItemWidth,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
    );
  }
}
