import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'step_progress_indicator.dart';

class StepProgressSlider extends StatefulWidget {
  final Axis direction;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final int totalSteps;
  final int initialStep;
  final EdgeInsets? margin;
  final EdgeInsets? innerPadding;
  final Widget Function(int step, bool selected)? stepBuidler;
  final PreferredSizeWidget Function(int step)? cursorBuidler;
  final Size? stepIndicatorSize;
  final ValueChanged<int>? onStepStart;
  final ValueChanged<int>? onStepUpdate;
  final ValueChanged<int>? onStepEnded;
  const StepProgressSlider(
      {super.key,
      this.direction = Axis.horizontal,
      this.width,
      this.height,
      this.decoration,
      required this.totalSteps,
      this.initialStep = 0,
      this.margin,
      this.innerPadding,
      this.stepBuidler,
      this.onStepStart,
      this.onStepUpdate,
      this.onStepEnded,
      this.cursorBuidler,
      this.stepIndicatorSize})
      : assert(!(null != cursorBuidler && null == stepIndicatorSize),
            'required stepIndicatorSize');

  @override
  State createState() => _StepProgressSliderDartState();
}

class _StepProgressSliderDartState extends State<StepProgressSlider> {
  late ValueNotifier<int> _currentStepValue;
  double _stepProgressSize = 0;
  @override
  void initState() {
    _currentStepValue = ValueNotifier(widget.initialStep);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = widget.width ?? constraints.maxWidth;
        final height = widget.height ?? constraints.maxHeight;
        _stepProgressSize = width;
        if (null != widget.innerPadding) {
          _stepProgressSize -=
              widget.innerPadding!.left + widget.innerPadding!.right;
        }
        return Container(
          width: width,
          height: height,
          margin: widget.margin,
          decoration: widget.decoration ??
              BoxDecoration(
                  color: const Color(0xff2D2E2C),
                  borderRadius: BorderRadius.circular(35)),
          child: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    var stepIndicatorWidth = widget.stepIndicatorSize?.width ?? 0;
    double stepSpace =
        (_stepProgressSize - widget.totalSteps * stepIndicatorWidth) /
            (widget.totalSteps - 1);
    return ValueListenableBuilder(
      valueListenable: _currentStepValue,
      builder: (BuildContext context, int value, Widget? child) {
        final cursor = widget.cursorBuidler?.call(value);
        final cursorWidth = cursor?.preferredSize.width ?? 0;
        final initialPosX = (widget.innerPadding?.left ?? 0) -
            cursorWidth / 2 +
            stepIndicatorWidth / 2;
        return Stack(alignment: Alignment.center, children: [
          Padding(
              padding: widget.innerPadding ?? EdgeInsets.zero,
              child: StepProgressIndicator(
                  size: stepIndicatorWidth,
                  direction: widget.direction,
                  totalSteps: widget.totalSteps,
                  currentStep: value,
                  stepBuidler: null != widget.stepBuidler
                      ? (int step) => widget.stepBuidler!(step, step <= value)
                      : null)),
          if (null != cursor)
            Positioned(
                left: initialPosX +
                    stepIndicatorWidth * value +
                    value * stepSpace,
                child: GestureDetector(
                  child: cursor,
                  onHorizontalDragStart: (details) =>
                      widget.onStepStart?.call(value),
                  onHorizontalDragUpdate: (details) {
                    Offset globalPos = details.globalPosition;
                    int step = (globalPos.dx - cursorWidth / 2 - stepSpace) ~/
                        (stepIndicatorWidth + stepSpace);
                    int newValue = step.clamp(0, widget.totalSteps - 1);
                    // debugPrint(
                    //     'newValue:$newValue===>value:$value==globalPos$globalPos');
                    if (newValue != value) {
                      HapticFeedback.lightImpact();
                      _currentStepValue.value = newValue;
                      widget.onStepUpdate?.call(newValue);
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    widget.onStepEnded?.call(value);
                  },
                ))
        ]);
      },
    );
  }

  @override
  void didUpdateWidget(covariant StepProgressSlider oldWidget) {
    if (widget.initialStep != oldWidget.initialStep) {
      _currentStepValue.value = widget.initialStep;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _currentStepValue.dispose();
    super.dispose();
  }
}
