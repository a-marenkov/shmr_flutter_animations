import 'package:flutter/material.dart';

import '../strings.dart';
import 'common/showcase_config.dart';
import 'common/showcase_scaffold.dart';

/// Showcase of [AnimatedSwitcher] usage
class ShowcaseCustomAnimatedSwitcher extends StatefulWidget {
  const ShowcaseCustomAnimatedSwitcher({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseCustomAnimatedSwitcherState createState() =>
      _ShowcaseCustomAnimatedSwitcherState();
}

class _ShowcaseCustomAnimatedSwitcherState
    extends State<ShowcaseCustomAnimatedSwitcher> {
  final scaleTween = Tween(begin: 0.0, end: 1.0);
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
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation.drive(scaleTween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
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
