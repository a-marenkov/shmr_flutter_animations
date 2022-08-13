import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Provides showcase string title through [InheritedWidget]
class ShowcaseTitle extends InheritedWidget {
  final String title;

  const ShowcaseTitle({
    required Widget child,
    required this.title,
    Key? key,
  }) : super(child: child, key: key);

  static String of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShowcaseTitle>()?.title ?? '';

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    if (oldWidget is ShowcaseTitle) {
      return oldWidget.title != title;
    }
    return true;
  }
}
