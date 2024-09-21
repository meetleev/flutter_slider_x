import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final Axis direction;
  final int totalSteps;
  final double? size;

  /// Default value: 0
  final int currentStep;
  final Widget Function(int step)? stepBuidler;

  const StepProgressIndicator(
      {super.key,
      required this.totalSteps,
      required this.currentStep,
      this.stepBuidler,
      this.direction = Axis.horizontal,
      this.size});
  @override
  Widget build(BuildContext context) {
    List<Widget> steps = [];
    for (var i = 0; i < totalSteps; i++) {
      if (null != stepBuidler) {
        steps.add(SizedBox(
          width: Axis.horizontal == direction ? size : null,
          height: Axis.vertical == direction ? size : null,
          child: stepBuidler!(i),
        ));
      } else {
        if (currentStep < i) {
        } else {}
      }
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: steps);
  }
}