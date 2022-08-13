import 'package:flutter/material.dart';

import 'common/showcase_config.dart';
import 'common/showcase_scaffold.dart';

/// Showcase of [AnimatedVisibility]
class ShowcaseAnimatedVisibility extends StatefulWidget {
  const ShowcaseAnimatedVisibility({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseAnimatedVisibilityState createState() =>
      _ShowcaseAnimatedVisibilityState();
}

class _ShowcaseAnimatedVisibilityState
    extends State<ShowcaseAnimatedVisibility> {
  bool value = true;

  void onRun() {
    setState(() {
      value = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      onRun: onRun,
      child: AnimatedVisibility(
        duration: ShowcaseConfig.of(context).duration,
        curve: Curves.easeIn,
        isVisible: value,
        child: FloatingActionButton(
          child: const Icon(Icons.flutter_dash),
          onPressed: () {},
        ),
      ),
    );
  }
}

/// Animates visibility of the [child] by applying scale and fade transition
class AnimatedVisibility extends StatefulWidget {
  final Duration duration;
  final bool isVisible;
  final Widget child;
  final Curve curve;

  const AnimatedVisibility({
    Key? key,
    required this.child,
    required this.isVisible,
    required this.duration,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _AnimatedVisibilityState createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: widget.duration,
    value: widget.isVisible ? 1.0 : 0.0,
    vsync: this,
  );

  late final animation = CurvedAnimation(
    parent: controller,
    curve: widget.curve,
  );

  @override
  void didUpdateWidget(covariant AnimatedVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      controller.duration = widget.duration;
    }
    if (widget.curve != oldWidget.curve) {
      animation.curve = widget.curve;
    }
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        controller.forward();
      } else {
        controller.reverse();
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
    return IgnorePointer(
      ignoring: !widget.isVisible,
      child: ScaleTransition(
        scale: animation,
        child: FadeTransition(
          opacity: animation,
          child: widget.child,
        ),
      ),
    );

    // return IgnorePointer(
    //   ignoring: !widget.isVisible,
    //   child: AnimatedBuilder(
    //     animation: animation,
    //     builder: (BuildContext context, Widget? child) {
    //       return ClipPath(
    //         clipper: _CircleClipper(animation.value),
    //         child: widget.child,
    //       );
    //     },
    //   ),
    // );

    // return IgnorePointer(
    //   ignoring: !widget.isVisible,
    //   child: CircleClipTransition(
    //     clip: animation,
    //     child: widget.child,
    //   ),
    // );
  }
}

/// Clips circular path with radius of shortest side multiplied by [factor]
class _CircleClipper extends CustomClipper<Path> {
  final double factor;

  _CircleClipper(this.factor);

  @override
  Path getClip(Size size) {
    final path = Path();

    final center = size.center(Offset.zero);
    final r = size.shortestSide * factor;

    path.addRRect(
      RRect.fromLTRBR(
        center.dx - r,
        center.dy - r,
        center.dx + r,
        center.dy + r,
        Radius.circular(r),
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (oldClipper.runtimeType != _CircleClipper) {
      return true;
    }
    final typedOldClipper = oldClipper as _CircleClipper;
    return typedOldClipper.factor != factor;
  }
}

/// Circle clip transition
class CircleClipTransition extends AnimatedWidget {
  final Widget child;

  const CircleClipTransition({
    required this.child,
    required Animation<double> clip,
    Key? key,
  }) : super(
          listenable: clip,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final factor = listenable as Animation<double>;

    return ClipPath(
      clipper: _CircleClipper(factor.value),
      child: child,
    );
  }
}
