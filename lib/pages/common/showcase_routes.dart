import 'package:flutter/material.dart';

class DropPageTransition implements PageTransitionsBuilder {
  const DropPageTransition();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (animation.status == AnimationStatus.forward) {
      child = ScaleTransition(
        scale: animation.drive(Tween(begin: 1.25, end: 1.0)),
        child: child,
      );
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class MyCustomPageRoute<T> extends PageRouteBuilder<T> {
  MyCustomPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) : super(
          pageBuilder: (context, _, __) => builder(context),
          settings: settings,
          fullscreenDialog: fullscreenDialog,
          transitionsBuilder: _transitionsBuilder,
        );

  static Widget _transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (animation.status == AnimationStatus.forward) {
      child = ScaleTransition(
        scale: animation.drive(Tween(begin: 1.25, end: 1.0)),
        child: child,
      );
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
