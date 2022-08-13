import 'package:flutter/material.dart';

import 'common/showcase_scaffold.dart';
import 'home_page.dart';

/// Showcase of custom [Hero]
class ShowcaseHero extends StatelessWidget {
  const ShowcaseHero({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ShowcaseScaffold(
      onRun: null,
      child: Center(
        child: Hero(
          tag: DurationSetter,
          transitionOnUserGestures: true,
          child: DurationSetter(),
        ),
      ),
    );
  }
}
