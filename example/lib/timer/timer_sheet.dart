import 'package:flutter/material.dart';
import 'package:slider_x/slider_x.dart';

const double paddingSmall = 15;
const double paddingMedium = 25;
const Color defaultBgColor = Color(0xFF273E50);
const String imgLine3_1 = 'assets/textures/line3_n.png';
const String imgLine3_2 = 'assets/textures/line3_s.png';

class TimerSheet extends StatefulWidget {
  const TimerSheet({super.key});

  @override
  State<StatefulWidget> createState() => _TimerSheetState();
}

class _TimerSheetState extends State<TimerSheet> {
  final int totalSteps = 30;
  final ValueNotifier<int> _timedownDurationValue = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          bottom: paddingMedium + 3, left: paddingSmall, right: paddingSmall),
      padding: const EdgeInsets.symmetric(
          vertical: paddingMedium, horizontal: paddingSmall),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0), color: defaultBgColor),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ValueListenableBuilder(
                  valueListenable: _timedownDurationValue,
                  builder: (BuildContext context, int value, Widget? child) {
                    String text = 'Timed mute';
                    if (0 < value) {
                      int mins = value ~/ Duration.secondsPerMinute;
                      int secs = value % Duration.secondsPerMinute;
                      text =
                          '${mins.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}';
                    }
                    return Text(text,
                        style: const TextStyle(
                            color: Color(0xffE1D0D0), fontSize: 24));
                  }),
              ValueListenableBuilder(
                  valueListenable: _timedownDurationValue,
                  builder: (BuildContext context, int value, Widget? child) {
                    final initialStep = _calculateStep(value, totalSteps);
                    return StepProgressSlider(
                        height: 80,
                        totalSteps: totalSteps,
                        stepIndicatorSize: const Size(3.5, 53),
                        initialStep: initialStep,
                        margin: const EdgeInsets.only(
                            top: paddingSmall - 5, bottom: paddingMedium - 5),
                        innerPadding: const EdgeInsets.symmetric(
                            horizontal: paddingMedium + 6),
                        cursorBuidler: (step) => _TimerCursor(
                            step: step, scale: 2, totalSteps: totalSteps),
                        onStepStart: (value) {},
                        onStepUpdate: (value) => _timedownDurationValue.value =
                            _calculateDuration(totalSteps, value) *
                                Duration.secondsPerMinute,
                        stepBuidler: (step, selected) => Image.asset(
                            selected ? imgLine3_2 : imgLine3_1,
                            scale: 2));
                  }),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timedownDurationValue.dispose();
    super.dispose();
  }
}

const String imgCircle = 'assets/textures/circle.png';

class _TimerCursor extends StatelessWidget implements PreferredSizeWidget {
  final int step;
  final int totalSteps;
  final double scale;
  const _TimerCursor(
      {required this.step, required this.totalSteps, required this.scale});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(imgCircle, scale: scale),
        if (0 == step) const Text('Close')
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromRadius(53 / 2);
}

int _calculateDuration(int totalSteps, int curStep) =>
    Duration.minutesPerHour * curStep ~/ (totalSteps - 1);

int _calculateStep(int seconds, int totalSteps) =>
    (seconds * totalSteps / (Duration.minutesPerHour * Duration.minutesPerHour))
        .ceil();
