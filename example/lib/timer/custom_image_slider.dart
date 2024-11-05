import 'package:flutter/material.dart';
import 'package:slider_x/slider_x.dart';

const _designSize = Size(640, 96);
const _designBarCenterSlice = Rect.fromLTRB(50, 10, 640 - 50, 86);

class CustomImageSlide extends StatelessWidget {
  final String background;
  final String bar;
  final double? min;
  final double value;
  final ValueChanged<double> onProgressChanged;
  final Widget Function(BuildContext)? builder;
  const CustomImageSlide(
      {super.key,
      required this.background,
      required this.bar,
      this.min,
      this.value = 0,
      required this.onProgressChanged,
      this.builder});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final max = constraints.maxWidth;
        final scale = max / _designSize.width;
        final height = max * _designSize.height / _designSize.width;
        final left = _designBarCenterSlice.left * scale;
        final barCenterSlice = Rect.fromLTRB(
            left,
            _designBarCenterSlice.top * scale,
            max - left,
            _designBarCenterSlice.bottom * scale);
        return Slice9ImageSlider(
            value: value,
            background: ExactAssetImage(background, scale: 1 / scale),
            bar: ExactAssetImage(bar, scale: 1 / scale),
            max: max,
            height: height,
            barCenterSlice: barCenterSlice,
            onProgressChanged: onProgressChanged,
            builderAnimateOpacityEnabled: false,
            builder: builder);
      },
    );
  }
}
