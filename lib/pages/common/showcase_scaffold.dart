import 'package:flutter/material.dart';

import '../../strings.dart';
import 'showcase_title.dart';

/// Generic page wrapper for animation showcase
class ShowcaseScaffold extends StatelessWidget {
  final Widget child;
  final VoidCallback? onRun;
  final List<Widget>? actions;

  const ShowcaseScaffold({
    Key? key,
    required this.child,
    required this.onRun,
    this.actions,
  }) : super(key: key);

  static final _btnStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ShowcaseTitle.of(context),
        ),
        actions: actions,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: child,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 64,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: _btnStyle,
                        child: const Text(Strings.back),
                      ),
                    ),
                    if (onRun != null) ...[
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onRun,
                          style: _btnStyle,
                          child: const Text(Strings.run),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
