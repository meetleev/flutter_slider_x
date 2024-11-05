class SliderValue {
  /// The progress of slider
  final double progress;

  /// The opacity of slider
  final double opacity;

  SliderValue({required this.progress, required this.opacity});

  SliderValue copyWith({double? progress, double? opacity}) {
    return SliderValue(
        progress: progress ?? this.progress, opacity: opacity ?? this.opacity);
  }
}
