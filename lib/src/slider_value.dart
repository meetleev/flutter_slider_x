class SliderValue {
  final double progress;
  final double opacity;

  SliderValue({required this.progress, required this.opacity});

  SliderValue copyWith({double? progress, double? opacity}) {
    return SliderValue(
        progress: progress ?? this.progress, opacity: opacity ?? this.opacity);
  }
}
