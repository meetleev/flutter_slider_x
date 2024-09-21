import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'slider_value.dart';

class Slice9ImageSlider extends StatefulWidget {
  final ImageProvider background;
  final ImageProvider bar;
  final Rect barCenterSlice;
  final double max;
  final double? min;
  final double height;
  final double value;
  final ValueChanged<double> onProgressChanged;
  final Widget Function(BuildContext context)? builder;
  final bool builderAnimateOpacityEnabled;
  const Slice9ImageSlider(
      {super.key,
      required this.background,
      required this.bar,
      required this.max,
      this.min,
      required this.height,
      this.value = 0,
      required this.barCenterSlice,
      required this.onProgressChanged,
      this.builderAnimateOpacityEnabled = true,
      this.builder});
  @override
  State<StatefulWidget> createState() => _Slice9ImageSliderState();
}

class _Slice9ImageSliderState extends State<Slice9ImageSlider> {
  double get _min => max(
      widget.max - widget.barCenterSlice.right + widget.barCenterSlice.left + 1,
      widget.min ?? 0);
  late ValueNotifier<SliderValue> _sliderValue;
  late ValueNotifier<double> _childOpacityValue;
  final double _minChildOpacity = 0.7;
  @override
  void initState() {
    _sliderValue = ValueNotifier(
        SliderValue(progress: widget.value, opacity: 0 < widget.value ? 1 : 0));
    _childOpacityValue = ValueNotifier(0 < widget.value ? 1 : _minChildOpacity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Image(image: widget.background),
          ValueListenableBuilder(
            valueListenable: _sliderValue,
            builder: (BuildContext context, SliderValue value, Widget? child) {
              return AnimatedOpacity(
                  opacity: value.opacity,
                  curve: const ElasticOutCurve(2),
                  duration: const Duration(milliseconds: 750),
                  child: Image(
                    image: widget.bar,
                    width: _min + value.progress * (widget.max - _min),
                    height: widget.height,
                    filterQuality: FilterQuality.medium,
                    centerSlice: widget.barCenterSlice,
                  ));
            },
          ),
          if (null != widget.builder)
            Positioned.fill(
                child: widget.builderAnimateOpacityEnabled?  ValueListenableBuilder(
              valueListenable: _childOpacityValue,
              builder: (BuildContext context, double value, Widget? child) {
                return Opacity(opacity: value, child: widget.builder!(context));
              },
            ):widget.builder!(context))
        ],
      ),
      onTap: () {
        _sliderValue.value = _sliderValue.value.copyWith(opacity: 1);
        _childOpacityValue.value = 1;
      },
      onHorizontalDragStart: (details) {
        // _sliderValue.value = _sliderValue.value.copyWith(opacity: 1);
      },
      onHorizontalDragUpdate: (details) {
        double per = details.delta.dx / (widget.max - _min);
        double progress = (_sliderValue.value.progress + per).clamp(0, 1);
        if (_sliderValue.value.progress != progress) {
          if (0 == progress ||
              1 == progress ||
              0 == _sliderValue.value.progress) {
            HapticFeedback.heavyImpact();
          }
          _sliderValue.value = _sliderValue.value.copyWith(
              opacity: 0 == progress ? _minChildOpacity : 1,
              progress: progress);
          if (widget.builderAnimateOpacityEnabled) {
            _childOpacityValue.value = 0 == progress ? _minChildOpacity : 1;
          }
        }
      },
      onHorizontalDragEnd: (details) {
        _sliderValue.value = _sliderValue.value
            .copyWith(opacity: 0 == _sliderValue.value.progress ? 0 : 1);
        widget.onProgressChanged(_sliderValue.value.progress);
        if (widget.builderAnimateOpacityEnabled && 0 == _sliderValue.value.progress) {
          _childOpacityValue.value = _minChildOpacity;
        }
      },
    );
  }

  @override
  void dispose() {
    _childOpacityValue.dispose();
    _sliderValue.dispose();
    super.dispose();
  }
}
