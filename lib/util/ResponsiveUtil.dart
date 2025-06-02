import 'package:flutter/material.dart';

extension ResponsiveUtil on BuildContext {
  // Mobile: width < 768
  bool get isMobile => MediaQuery.of(this).size.width < 768;

  // Tablet: width >= 768 && width < 1024
  bool get isTablet {
    final width = MediaQuery.of(this).size.width;
    return width >= 768 && width < 1024;
  }

  // Desktop: width >= 1024
  bool get isDesktop => MediaQuery.of(this).size.width >= 1024;
}
