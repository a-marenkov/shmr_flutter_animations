import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'common/showcase_config.dart';
import 'common/showcase_scaffold.dart';

/// Showcase of [AnimatedController]
class ShowcaseAnimatedController extends StatefulWidget {
  const ShowcaseAnimatedController({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseAnimatedControllerState createState() =>
      _ShowcaseAnimatedControllerState();
}

class _ShowcaseAnimatedControllerState extends State<ShowcaseAnimatedController>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(vsync: this);
  late var value = controller.value.toString();
  late var status = describeEnum(controller.status);

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        value = controller.value.toString();
      });
    });
    controller.addStatusListener((newStatus) {
      setState(() {
        status = describeEnum(newStatus);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.duration = ShowcaseConfig.of(context).duration;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onRun() {
    controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      onRun: onRun,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
          // Expanded(
          //   child: Center(
          //     child: ScaleTransition(
          //       scale: curve,
          //       child: const Icon(
          //         Icons.flutter_dash,
          //         size: 128.0,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
