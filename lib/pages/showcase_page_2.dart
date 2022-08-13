import 'dart:math';

import 'package:flutter/material.dart';

import 'common/showcase_config.dart';
import 'common/showcase_scaffold.dart';

/// Showcase of [TweenAnimationBuilder] usage
class ShowcaseTweenAnimationBuilder extends StatefulWidget {
  const ShowcaseTweenAnimationBuilder({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseTweenAnimationBuilderState createState() =>
      _ShowcaseTweenAnimationBuilderState();
}

class _ShowcaseTweenAnimationBuilderState
    extends State<ShowcaseTweenAnimationBuilder> {
  final initial = Tween(begin: 0.0, end: 0.0);
  final forward = Tween(begin: 0.0, end: pi);
  final reverse = Tween(begin: pi, end: 0.0);

  late var tween = initial;

  void toggle() {
    setState(() {
      if (tween == initial || tween == reverse) {
        tween = forward;
      } else if (tween == forward) {
        tween = reverse;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      onRun: toggle,
      child: TweenAnimationBuilder(
        duration: ShowcaseConfig.of(context).duration,
        curve: Curves.easeIn,
        tween: tween,
        builder: (BuildContext context, double value, Widget? child) {
          return Transform.rotate(
            angle: value,
            child: child ?? const SizedBox.shrink(),
          );
        },
        child: const Icon(
          Icons.arrow_upward_rounded,
          size: 56.0,
        ),
      ),
    );
  }
}
