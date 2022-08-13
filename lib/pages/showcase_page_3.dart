import 'package:flutter/material.dart';

import 'common/showcase_config.dart';
import 'common/showcase_scaffold.dart';

/// Showcase of [AnimatedCrossFade] usage
class ShowcaseAnimatedCrossFade extends StatefulWidget {
  const ShowcaseAnimatedCrossFade({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseAnimatedCrossFadeState createState() =>
      _ShowcaseAnimatedCrossFadeState();
}

class _ShowcaseAnimatedCrossFadeState extends State<ShowcaseAnimatedCrossFade> {
  bool value = true;

  void toggle() {
    setState(() {
      value = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      onRun: toggle,
      child: AnimatedCrossFade(
        duration: ShowcaseConfig.of(context).duration,
        crossFadeState:
            value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: const SizedBox(
          width: 128.0,
          height: 128.0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        secondChild: const Icon(
          Icons.flutter_dash,
          size: 128.0,
        ),
      ),
    );
  }
}
