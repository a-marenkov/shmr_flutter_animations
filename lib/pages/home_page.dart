import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../strings.dart';
import 'common/showcase_config.dart';
import 'common/showcase_title.dart';
import 'showcase_page_1.dart';
import 'showcase_page_10.dart';
import 'showcase_page_11.dart';
import 'showcase_page_12.dart';
import 'showcase_page_2.dart';
import 'showcase_page_3.dart';
import 'showcase_page_4.dart';
import 'showcase_page_5.dart';
import 'showcase_page_6.dart';
import 'showcase_page_7.dart';
import 'showcase_page_8.dart';
import 'showcase_page_9.dart';

/// Main page with list of showcases
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  /// all showcases
  static const showcases = <String, Widget>{
    'AnimatedContainer': ShowcaseAnimatedContainer(),
    'TweenAnimationBuilder': ShowcaseTweenAnimationBuilder(),
    'AnimatedCrossFade': ShowcaseAnimatedCrossFade(),
    'AnimatedSwitcher': ShowcaseAnimatedSwitcher(),
    'AnimationController': ShowcaseAnimatedController(),
    'AnimatedVisibility': ShowcaseAnimatedVisibility(),
    'CustomAnimatedSwitcher': ShowcaseCustomAnimatedSwitcher(),
    'AnimatedPulse': ShowcaseAnimatedPulse(),
    'ActivityRings': ShowcaseAnimatedActivity(),
    'BouncyPane': ShowcaseBouncyPane(),
    'Hero': ShowcaseHero(),
    'MaterialTransitions': ShowcaseMaterialTransitions(),
  };

  /// all showcases subtitles
  static const subtitles = <String, String>{
    'MaterialTransitions': 'pub.dev/packages/animations',
  };

  /// all showcases entries
  static final _entries = showcases.entries.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final showcase = _entries[index];
                  final isLast = index == _entries.length - 1;

                  return _HomeListItem(
                    index: index,
                    addDivider: !isLast,
                    title: showcase.key,
                    subtitle: subtitles[showcase.key],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ShowcaseTitle(
                            title: showcase.key,
                            child: showcase.value,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Hero(
              tag: DurationSetter,
              transitionOnUserGestures: true,
              child: DurationSetter(),
            ),
          ],
        ),
      ),
    );
  }
}

/// [HomePage] list item
class _HomeListItem extends StatelessWidget {
  final int index;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool addDivider;

  const _HomeListItem({
    Key? key,
    required this.index,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.addDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          leading: Chip(
            label: Text(
              (index + 1).toString(),
              style: theme.primaryTextTheme.button,
            ),
            backgroundColor: theme.primaryColor,
          ),
          trailing: const Icon(Icons.navigate_next),
          title: Text(
            title,
            style: theme.textTheme.subtitle1,
          ),
          subtitle: subtitle == null
              ? null
              : Text(
                  subtitle!,
                  style: theme.textTheme.caption,
                ),
          onTap: onTap,
        ),
        if (addDivider)
          const Divider(
            indent: 64.0,
            height: 1.5,
            thickness: 1.5,
          ),
      ],
    );
  }
}

class DurationSetter extends StatelessWidget {
  const DurationSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = ShowcaseConfig.of(context);

    return Card(
      color: Colors.white,
      elevation: 16.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Strings.durationMs(config.duration.inMilliseconds),
              style: Theme.of(context).textTheme.button,
            ),
            Slider(
              min: ShowcaseConfigData.minMillis.toDouble(),
              max: ShowcaseConfigData.maxMillis.toDouble(),
              value: config.duration.inMilliseconds.toDouble(),
              onChanged: (double value) {
                config.duration = Duration(milliseconds: value.toInt());
              },
            ),
            const SlowAnimationsToggle(),
          ],
        ),
      ),
    );
  }
}

class SlowAnimationsToggle extends StatefulWidget {
  const SlowAnimationsToggle({Key? key}) : super(key: key);

  @override
  State<SlowAnimationsToggle> createState() => _SlowAnimationsToggleState();
}

class _SlowAnimationsToggleState extends State<SlowAnimationsToggle> {
  bool isSlowed = false;

  @override
  void initState() {
    super.initState();
    isSlowed = timeDilation > 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: isSlowed,
      onChanged: (bool value) async {
        setState(() {
          isSlowed = value;
        });
        if (value) {
          await Future<void>.delayed(const Duration(milliseconds: 300));
        }
        if (value == isSlowed) {
          timeDilation = value ? 10.0 : 1.0;
        }
      },
      title: Text(
        Strings.slowAllAnimations,
        style: Theme.of(context).textTheme.button,
      ),
    );
  }
}
