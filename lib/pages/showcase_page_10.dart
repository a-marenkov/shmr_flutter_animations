import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'common/showcase_scaffold.dart';
import 'common/showcase_title.dart';
import 'common/showcase_utils.dart';

/// Showcase of [BouncyPane] usage
class ShowcaseBouncyPane extends StatefulWidget {
  const ShowcaseBouncyPane({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowcaseBouncyPane> createState() => _ShowcaseBouncyPaneState();
}

class _ShowcaseBouncyPaneState extends State<ShowcaseBouncyPane> {
  double stiffness = PhysicsHelper.stiffness.medium;
  double dumpingRatio = PhysicsHelper.dampingRatio.mediumBouncy;

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      actions: actions,
      onRun: null,
      child: Stack(
        children: [
          BouncyPane(
            dumpingRatio: dumpingRatio,
            stiffness: stiffness,
            decoration: BoxDecoration(
              color: const Color(0xFF3eb489),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: const Offset(0.0, -4.0),
                  blurRadius: 8.0,
                  spreadRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    ShowcaseTitle.of(context),
                    style: Theme.of(context).primaryTextTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.flutter_dash,
                      size: 128.0,
                      color: Theme.of(context)
                          .primaryTextTheme
                          .displaySmall
                          ?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get actions => [
        PopupMenuButton<double>(
          icon: const Icon(Icons.format_align_justify),
          initialValue: stiffness,
          onSelected: (stiffness) {
            setState(() {
              this.stiffness = stiffness;
            });
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: null,
                enabled: false,
                child: Text('stiffness'),
              ),
              PopupMenuItem(
                value: PhysicsHelper.stiffness.veryHigh,
                child: const Text('very high'),
              ),
              PopupMenuItem(
                value: PhysicsHelper.stiffness.high,
                child: const Text('high'),
              ),
              PopupMenuItem(
                value: PhysicsHelper.stiffness.medium,
                child: const Text('medium'),
              ),
              PopupMenuItem(
                value: PhysicsHelper.stiffness.low,
                child: const Text('low'),
              ),
              PopupMenuItem(
                value: PhysicsHelper.stiffness.veryLow,
                child: const Text('very low'),
              ),
            ];
          },
        ),
        PopupMenuButton<double>(
          icon: const Icon(Icons.sports_basketball),
          initialValue: dumpingRatio,
          onSelected: (dumpingRatio) {
            setState(() {
              this.dumpingRatio = dumpingRatio;
            });
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: null,
              enabled: false,
              child: Text('damping ratio'),
            ),
            PopupMenuItem(
              value: PhysicsHelper.dampingRatio.highBouncy,
              child: const Text('high bouncy'),
            ),
            PopupMenuItem(
              value: PhysicsHelper.dampingRatio.mediumBouncy,
              child: const Text('medium bouncy'),
            ),
            PopupMenuItem(
              value: PhysicsHelper.dampingRatio.lowBouncy,
              child: const Text('low bouncy'),
            ),
            PopupMenuItem(
              value: PhysicsHelper.dampingRatio.noBouncy,
              child: const Text('no bouncy'),
            ),
          ],
        ),
      ];
}

class BouncyPane extends StatefulWidget {
  final BoxDecoration decoration;
  final double peekHeight;
  final double bodyHeight;
  final double stiffness;
  final double dumpingRatio;
  final Widget child;

  const BouncyPane({
    Key? key,
    required this.child,
    required this.stiffness,
    required this.dumpingRatio,
    this.peekHeight = 72.0,
    this.bodyHeight = 364.0,
    this.decoration = const BoxDecoration(),
  }) : super(key: key);

  @override
  State<BouncyPane> createState() => _BouncyPaneState();
}

class _BouncyPaneState extends State<BouncyPane>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController.unbounded(
    vsync: this,
    value: peekHeight,
  );

  late var peekHeight = widget.peekHeight;
  late var bodyHeight = widget.bodyHeight;

  double get fullHeight => peekHeight + bodyHeight;

  @override
  void didUpdateWidget(covariant BouncyPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    peekHeight = widget.peekHeight;
    bodyHeight = widget.bodyHeight;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              var factor = controller.value / constraints.maxHeight;
              if (factor < 0.0) {
                factor = 0.0;
              }

              return FractionallySizedBox(
                heightFactor: factor,
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onPanStart: (_) {
                    controller.stop();
                  },
                  onPanUpdate: (details) {
                    final value = controller.value - details.delta.dy;
                    controller.value = value;
                  },
                  onPanEnd: (details) {
                    final velocity = details.velocity.pixelsPerSecond.dy;
                    if (velocity.abs() > fullHeight * 2) {
                      final shouldExpand = velocity.isNegative;
                      bounce(shouldExpand, velocity);
                    } else {
                      final value = controller.value;
                      final shouldExpand =
                          (value - peekHeight) > (fullHeight - value);
                      bounce(shouldExpand, velocity);
                    }
                  },
                  child: child,
                ),
              );
            },
            child: Container(
              decoration: widget.decoration,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  height: fullHeight,
                  child: widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void bounce(bool shouldExpand, double velocity) {
    final from = controller.value;
    final to = shouldExpand ? fullHeight : peekHeight;
    final sign = shouldExpand ? 1.0 : -1.0;
    controller.animateWith(
      SpringSimulation(
        SpringDescription.withDampingRatio(
          mass: 1.0,
          stiffness: widget.stiffness,
          ratio: widget.dumpingRatio,
        ),
        from,
        to,
        velocity.abs() * sign,
        tolerance: PhysicsHelper.flingTolerance,
      ),
    );
  }
}
