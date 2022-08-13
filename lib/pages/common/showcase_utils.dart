import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

/// Helper for creating physics driven animations
abstract class PhysicsHelper {
  const PhysicsHelper._();

  static const flingTolerance = Tolerance(
    velocity: double.infinity,
    distance: 0.00001,
  );

  static const dampingRatio = _DampingRatio();

  static const stiffness = _Stiffness();
}

class _DampingRatio {
  const _DampingRatio();

  final highBouncy = 0.15;
  final mediumBouncy = 0.4;
  final lowBouncy = 0.75;
  final noBouncy = 1.0;
}

class _Stiffness {
  const _Stiffness();

  final veryHigh = 10000.0;
  final high = 5000.0;
  final medium = 1500.0;
  final low = 200.0;
  final veryLow = 50.0;
}
