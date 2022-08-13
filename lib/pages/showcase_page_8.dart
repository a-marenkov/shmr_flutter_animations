import 'package:flutter/material.dart';

import 'common/showcase_config.dart';
import 'common/showcase_scaffold.dart';

/// Showcase of custom [AnimatedPulse]
class ShowcaseAnimatedPulse extends StatelessWidget {
  const ShowcaseAnimatedPulse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = ShowcaseConfig.of(context);

    return ShowcaseScaffold(
      onRun: null,
      child: AnimatedPulse(
        duration: config.duration,
        child: const Icon(
          Icons.favorite,
          size: 48.0,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}

class AnimatedPulse extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AnimatedPulse({
    required this.child,
    required this.duration,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimatedPulseState();
}

class _AnimatedPulseState extends State<AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(vsync: this);

  late final outerFade = Tween(begin: 1.0, end: 0.0).animate(controller);
  late final outerScale = Tween(begin: 1.0, end: 3.0).animate(controller);

  late final innerUpscale = CurvedAnimation(
    parent: controller,
    curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
  ).drive(Tween(begin: 1.0, end: 1.5));

  late final innerDownscale = CurvedAnimation(
    parent: controller,
    curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
  ).drive(Tween(begin: 1.0, end: 1.0 / 1.5));

  @override
  void initState() {
    super.initState();
    setDuration(widget.duration);
  }

  @override
  void didUpdateWidget(covariant AnimatedPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    setDuration(widget.duration);
  }

  void setDuration(Duration duration) {
    if (controller.duration != duration) {
      controller.duration = duration;
      if (duration > Duration.zero) {
        controller.repeat();
      } else {
        controller.reset();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'I',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Stack(
          children: [
            FadeTransition(
              opacity: outerFade,
              child: ScaleTransition(
                scale: outerScale,
                child: widget.child,
              ),
            ),
            ScaleTransition(
              scale: innerUpscale,
              child: ScaleTransition(
                scale: innerDownscale,
                child: widget.child,
              ),
            )
          ],
        ),
        Text(
          'FLUTTER',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ],
    );
  }
}

class MultiplyAnimation extends CompoundAnimation<double> {
  MultiplyAnimation(
    Animation<double> first,
    Animation<double> next,
  ) : super(first: first, next: next);

  @override
  double get value => first.value * next.value;
}
