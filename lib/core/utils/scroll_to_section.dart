import 'package:flutter/material.dart';

class SectionScroller {
  final ScrollController controller;
  final double sectionHeight;

  SectionScroller({required this.controller, required this.sectionHeight});

  Future<void> goTo(int index) async {
    await controller.animateTo(
      index * sectionHeight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
