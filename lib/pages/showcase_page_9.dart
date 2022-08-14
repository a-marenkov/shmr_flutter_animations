import 'dart:math';

import 'package:flutter/material.dart';

import '../strings.dart';
import 'common/showcase_config.dart';
import 'common/showcase_scaffold.dart';

/// Model that describes activity progress
class ActivityRingsData {
  final double move;
  final double exercise;
  final double stand;

  static const zero = ActivityRingsData(
    move: 0.0,
    exercise: 0.0,
    stand: 0.0,
  );

  const ActivityRingsData({
    required this.move,
    required this.exercise,
    required this.stand,
  });

  double get sum => move + exercise + stand;

  double get moveWeight {
    if (sum == 0.0) {
      return 0.333;
    }
    return move / sum;
  }

  double get exerciseWeight {
    if (sum == 0.0) {
      return 0.333;
    }
    return exercise / sum;
  }

  double get standWeight {
    if (sum == 0.0) {
      return 0.333;
    }
    return stand / sum;
  }

  double get moveEnd {
    final weight = moveWeight;
    if (weight > 0.33) {
      return 1.0;
    }
    return weight * 2.5;
  }

  double get exerciseEnd {
    final weight = exerciseWeight;
    if (weight > 0.33) {
      return 1.0;
    }
    return weight * 2.5;
  }

  double get standEnd {
    final weight = standWeight;
    if (weight > 0.33) {
      return 1.0;
    }
    return weight * 2.5;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityRingsData &&
          runtimeType == other.runtimeType &&
          move == other.move &&
          exercise == other.exercise &&
          stand == other.stand;

  @override
  int get hashCode => move.hashCode ^ exercise.hashCode ^ stand.hashCode;
}

abstract class ActivityRingsColors {
  ActivityRingsColors._();

  static const move = Color(0xFFe63652);
  static const exercise = Color(0xFFbdff3c);
  static const stand = Color(0xFF7ad7ff);

  static Color evalMove(double progress) =>
      Color.lerp(move, const Color(0xFFd83b82), progress.clamp(0.0, 1.0))!;

  static Color evalExercise(double progress) =>
      Color.lerp(exercise, const Color(0xFFe4ff3c), progress.clamp(0.0, 1.0))!;

  static Color evalStand(double progress) =>
      Color.lerp(stand, const Color(0xFF90ffab), progress.clamp(0.0, 1.0))!;
}

class ShowcaseAnimatedActivity extends StatefulWidget {
  const ShowcaseAnimatedActivity({
    Key? key,
  }) : super(key: key);

  @override
  State<ShowcaseAnimatedActivity> createState() =>
      _ShowcaseAnimatedActivityState();
}

class _ShowcaseAnimatedActivityState extends State<ShowcaseAnimatedActivity> {
  ActivityRingsData activity = ActivityRingsData.zero;
  int move = 0;
  int exercise = 0;
  int stand = 0;

  void onRun() {
    setState(() {
      activity = ActivityRingsData(
        move: move / 100,
        exercise: exercise / 100,
        stand: stand / 100,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      onRun: onRun,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AnimatedActivityRings(
              activity: activity,
              duration: ShowcaseConfig.of(context).duration,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Strings.moveOf(move.toStringAsFixed(0))),
                  Slider(
                    min: 0.0,
                    max: 200.0,
                    value: move.toDouble(),
                    activeColor: ActivityRingsColors.move,
                    onChanged: (double value) {
                      setState(() {
                        move = value.round();
                      });
                    },
                  ),
                  Text(Strings.exerciseOf(exercise.toStringAsFixed(0))),
                  Slider(
                    min: 0.0,
                    max: 200.0,
                    value: exercise.toDouble(),
                    activeColor: ActivityRingsColors.exercise,
                    onChanged: (double value) {
                      setState(() {
                        exercise = value.round();
                      });
                    },
                  ),
                  Text(Strings.standOf(stand.toStringAsFixed(0))),
                  Slider(
                    min: 0.0,
                    max: 200.0,
                    value: stand.toDouble(),
                    activeColor: ActivityRingsColors.stand,
                    onChanged: (double value) {
                      setState(() {
                        stand = value.round();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedActivityRings extends StatefulWidget {
  final ActivityRingsData activity;
  final Duration duration;
  final Curve curve;

  const AnimatedActivityRings({
    Key? key,
    required this.activity,
    required this.duration,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _AnimatedActivityRingsState createState() => _AnimatedActivityRingsState();
}

class _AnimatedActivityRingsState extends State<AnimatedActivityRings>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  );

  ActivityRingsData get activity => widget.activity;

  late final moveTween = Tween(begin: 0.0, end: activity.move);

  late final moveInterval = CurveTween(
    curve: Interval(0.0, activity.moveEnd, curve: widget.curve),
  );

  late final move = moveTween.chain(moveInterval);

  late final exerciseTween = Tween(begin: 0.0, end: activity.exercise);

  late final exerciseInterval = CurveTween(
    curve: Interval(0.0, activity.exerciseEnd, curve: widget.curve),
  );

  late final exercise = exerciseTween.chain(exerciseInterval);

  late final standTween = Tween(begin: 0.0, end: activity.stand);

  late final standInterval = CurveTween(
    curve: Interval(0.0, activity.standEnd, curve: widget.curve),
  );

  late final stand = standTween.chain(standInterval);

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedActivityRings oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.duration = widget.duration;
    if (oldWidget.activity != activity) {
      moveTween.end = activity.move;
      moveInterval.curve = Interval(
        0.0,
        activity.moveEnd,
        curve: widget.curve,
      );
      exerciseTween.end = activity.exercise;
      exerciseInterval.curve = Interval(
        0.0,
        activity.exerciseEnd,
        curve: widget.curve,
      );
      standTween.end = activity.stand;
      standInterval.curve = Interval(
        0.0,
        activity.standEnd,
        curve: widget.curve,
      );
      controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ActivityRingsBackgroundPainter(),
      foregroundPainter: _ActivityRingsForegroundPainter(
        move: move.evaluate(controller),
        exercise: exercise.evaluate(controller),
        stand: stand.evaluate(controller),
      ),
    );
  }
}

double degreesToRadians(num degrees) => degrees * pi / 180.0;

class _ActivityRingsPainterHelper {
  final Size size;
  late final center = size.center(Offset.zero);
  late final maxRadius = size.shortestSide / 2;
  late final fraction = maxRadius / 24;
  late final strokeWidth = fraction * 5;
  late final moveRadius = maxRadius - fraction * 3;
  late final exerciseRadius = maxRadius - fraction * 9;
  late final standRadius = maxRadius - fraction * 15;
  final bgOpacity = 0.2;
  final moveShadowAngle = 1.0;
  final exerciseShadowAngle = 1.5;
  final standShadowAngle = 2.0;
  final extraAngle = 0.01;

  _ActivityRingsPainterHelper(this.size);
}

class _ActivityRingsBackgroundPainter extends CustomPainter {
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      runtimeType != oldDelegate.runtimeType;

  @override
  void paint(Canvas canvas, Size size) {
    final helper = _ActivityRingsPainterHelper(size);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = helper.strokeWidth;

    paint.color = ActivityRingsColors.move.withOpacity(helper.bgOpacity);
    canvas.drawCircle(
      helper.center,
      helper.moveRadius,
      paint,
    );

    paint.color = ActivityRingsColors.exercise.withOpacity(helper.bgOpacity);
    canvas.drawCircle(
      helper.center,
      helper.exerciseRadius,
      paint,
    );

    paint.color = ActivityRingsColors.stand.withOpacity(helper.bgOpacity);
    canvas.drawCircle(
      helper.center,
      helper.standRadius,
      paint,
    );
  }
}

class _ActivityRingsForegroundPainter extends CustomPainter {
  final double move;
  final double exercise;
  final double stand;

  _ActivityRingsForegroundPainter({
    required this.move,
    required this.exercise,
    required this.stand,
  });

  @override
  bool shouldRepaint(covariant _ActivityRingsForegroundPainter oldDelegate) =>
      move != oldDelegate.move ||
      exercise != oldDelegate.exercise ||
      stand != oldDelegate.stand;

  @override
  void paint(Canvas canvas, Size size) {
    final helper = _ActivityRingsPainterHelper(size);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = helper.strokeWidth;

    drawArc(
      canvas: canvas,
      paint: paint,
      value: move,
      evalColor: ActivityRingsColors.evalMove,
      radius: helper.moveRadius,
      center: helper.center,
      shadowAngle: helper.moveShadowAngle,
      extraAngle: helper.extraAngle,
    );

    drawArc(
      canvas: canvas,
      paint: paint,
      value: exercise,
      evalColor: ActivityRingsColors.evalExercise,
      radius: helper.exerciseRadius,
      center: helper.center,
      shadowAngle: helper.exerciseShadowAngle,
      extraAngle: helper.extraAngle,
    );

    drawArc(
      canvas: canvas,
      paint: paint,
      value: stand,
      evalColor: ActivityRingsColors.evalStand,
      radius: helper.standRadius,
      center: helper.center,
      shadowAngle: helper.standShadowAngle,
      extraAngle: helper.extraAngle,
    );
  }

  void drawArc({
    required Canvas canvas,
    required Paint paint,
    required double value,
    required Color Function(double) evalColor,
    required double radius,
    required Offset center,
    required double shadowAngle,
    required double extraAngle,
  }) {
    if (value == 0) {
      return;
    }

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final circles = value ~/ 1.0;
    final remainder = value % 1.0;
    final angle = remainder * pi * 2;

    final fromColor = evalColor((circles - 1) / value);
    final middleColor = evalColor(circles / value);
    final toColor = evalColor(value * 2);

    final circleShader = SweepGradient(
      colors: [fromColor, middleColor],
      transform: GradientRotation(
        degreesToRadians(-90),
      ),
    ).createShader(rect);

    final remainderShader = SweepGradient(
      colors: [middleColor, toColor],
      tileMode: TileMode.clamp,
      stops: [0.0, remainder],
      transform: GradientRotation(
        degreesToRadians(-90),
      ),
    ).createShader(rect);

    final shadowShader = SweepGradient(
      colors: const [Colors.black26, Colors.transparent],
      stops: const [0.0, 0.1],
      transform: GradientRotation(
        degreesToRadians(-90) + angle,
      ),
    ).createShader(rect);

    if (circles > 0) {
      paint.shader = circleShader;
      paint.strokeCap = StrokeCap.butt;
      canvas.drawArc(
        rect,
        degreesToRadians(-90),
        degreesToRadians(360),
        false,
        paint,
      );
    } else {
      canvas.saveLayer(Rect.largest, paint);

      paint.shader = null;
      paint.color = middleColor;
      paint.strokeCap = StrokeCap.round;
      canvas.drawArc(
        rect,
        degreesToRadians(-90),
        degreesToRadians(45),
        false,
        paint,
      );

      paint.blendMode = BlendMode.clear;
      paint.strokeCap = StrokeCap.butt;
      canvas.drawArc(
        rect,
        degreesToRadians(-90) + extraAngle,
        degreesToRadians(90),
        false,
        paint,
      );
      paint.blendMode = BlendMode.srcOver;

      canvas.restore();
    }

    if (remainder == 0.0) {
      canvas.saveLayer(Rect.largest, paint);

      paint.shader = shadowShader;
      paint.strokeCap = StrokeCap.round;
      canvas.drawArc(
        rect,
        degreesToRadians(-90) + angle,
        degreesToRadians(shadowAngle),
        false,
        paint,
      );

      paint.shader = null;
      paint.color = toColor;
      paint.strokeCap = StrokeCap.round;
      canvas.drawArc(
        rect,
        degreesToRadians(-135),
        degreesToRadians(45),
        false,
        paint,
      );

      paint.strokeCap = StrokeCap.butt;
      paint.blendMode = BlendMode.clear;
      canvas.drawArc(
        rect,
        degreesToRadians(-180),
        degreesToRadians(90),
        false,
        paint,
      );
      paint.blendMode = BlendMode.srcOver;

      canvas.restore();
    } else {
      paint.shader = remainderShader;
      paint.strokeCap = StrokeCap.butt;
      canvas.drawArc(
        rect,
        degreesToRadians(-90),
        angle + extraAngle,
        false,
        paint,
      );

      canvas.saveLayer(Rect.largest, paint);

      paint.shader = shadowShader;
      paint.strokeCap = StrokeCap.round;
      canvas.drawArc(
        rect,
        degreesToRadians(-90) + angle,
        degreesToRadians(shadowAngle),
        false,
        paint,
      );

      paint.shader = null;
      paint.color = toColor;
      paint.strokeCap = StrokeCap.round;
      canvas.drawArc(
        rect,
        degreesToRadians(-135) + angle,
        degreesToRadians(45),
        false,
        paint,
      );

      paint.strokeCap = StrokeCap.butt;
      paint.blendMode = BlendMode.clear;
      canvas.drawArc(
        rect,
        degreesToRadians(-180) + angle,
        degreesToRadians(90),
        false,
        paint,
      );
      paint.blendMode = BlendMode.srcOver;

      canvas.restore();
    }
  }
}

class ActivityRingsTween extends Animatable<ActivityRingsData> {
  ActivityRingsData _activity;
  Curve _curve;

  ActivityRingsTween(
    this._activity, {
    Curve? curve,
  }) : _curve = curve ?? Curves.fastOutSlowIn;

  ActivityRingsData get activity => _activity;

  Curve get curve => _curve;

  late final moveTween = Tween(begin: 0.0, end: activity.move);

  late final moveInterval = CurveTween(
    curve: Interval(0.0, activity.moveEnd, curve: curve),
  );

  late final move = moveTween.chain(moveInterval);

  late final exerciseTween = Tween(begin: 0.0, end: activity.exercise);

  late final exerciseInterval = CurveTween(
    curve: Interval(0.0, activity.exerciseEnd, curve: curve),
  );

  late final exercise = exerciseTween.chain(exerciseInterval);

  late final standTween = Tween(begin: 0.0, end: activity.stand);

  late final standInterval = CurveTween(
    curve: Interval(0.0, activity.standEnd, curve: curve),
  );

  late final stand = standTween.chain(standInterval);

  set activity(ActivityRingsData activity) {
    if (activity == this.activity) {
      return;
    }
    _activity = activity;
    _update();
  }

  set curve(Curve curve) {
    if (curve == this.curve) {
      return;
    }
    _curve = curve;
    _update();
  }

  void _update() {
    moveTween.end = activity.move;
    moveInterval.curve = Interval(
      0.0,
      activity.moveEnd,
      curve: curve,
    );
    exerciseTween.end = activity.exercise;
    exerciseInterval.curve = Interval(
      0.0,
      activity.exerciseEnd,
      curve: curve,
    );
    standTween.end = activity.stand;
    standInterval.curve = Interval(
      0.0,
      activity.standEnd,
      curve: curve,
    );
  }

  @override
  ActivityRingsData transform(double t) {
    return ActivityRingsData(
      move: move.transform(t),
      exercise: exercise.transform(t),
      stand: stand.transform(t),
    );
  }
}
