import 'package:flutter/material.dart';

import 'pages/common/showcase_config.dart';
import 'pages/home_page.dart';
import 'strings.dart';

/// App entry point
void main() => runApp(const App());

/// App's root widget
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowcaseScope(
      child: MaterialApp(
        title: Strings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // pageTransitionsTheme: const PageTransitionsTheme(
          //   builders: {
          //     TargetPlatform.android: DropPageTransition(),
          //     TargetPlatform.fuchsia: DropPageTransition(),
          //     TargetPlatform.iOS: DropPageTransition(),
          //     TargetPlatform.macOS: DropPageTransition(),
          //     TargetPlatform.windows: DropPageTransition(),
          //     TargetPlatform.linux: DropPageTransition(),
          //   },
          // ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
