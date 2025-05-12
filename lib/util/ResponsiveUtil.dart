import 'package:flutter/material.dart';

extension Responsiveutil on BuildContext {
  static bool isMobile(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return mediaQueryData.size.width < 600;
  }

  static bool isTable(BuildContext context) {
    return MediaQuery.of(context).size.width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 1024;
  }
}
