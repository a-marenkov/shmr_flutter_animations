import 'package:flutter/material.dart';

import '../strings.dart';
import 'common/showcase_config.dart';
import 'common/showcase_scaffold.dart';

/// Showcase of [AnimatedSwitcher] usage
class ShowcaseAnimatedSwitcher extends StatefulWidget {
  const ShowcaseAnimatedSwitcher({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseAnimatedSwitcherState createState() =>
      _ShowcaseAnimatedSwitcherState();
}

class _ShowcaseAnimatedSwitcherState extends State<ShowcaseAnimatedSwitcher> {
  final words = Strings.helloFlutterCountDown;
  var index = 0;

  void onNext() {
    setState(() {
      index = ++index % words.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      onRun: onNext,
      child: AnimatedSwitcher(
        duration: ShowcaseConfig.of(context).duration,
        child: Text(
          words[index],
          key: ValueKey(words[index]),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }
}
