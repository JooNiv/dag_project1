import 'package:flutter/material.dart';

class Breakpoints {
  static const xs = 350;
  static const sm = 640;
  static const md = 768;
  static const lg = 1024;
  static const xl = 1280;
  static const xl2 = 1536;
}

class ResponsiveWidget extends StatelessWidget {
  final Widget xsMobile;
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveWidget({
    super.key,
    Widget? xsMobile,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : xsMobile = xsMobile ?? mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < Breakpoints.xs) {
          return xsMobile;
        } else if (constraints.maxWidth < Breakpoints.sm) {
          return mobile;
        } else if (constraints.maxWidth < Breakpoints.lg) {
          return tablet;
        } else {
          return desktop;
        }
      },
    );
  }
}
