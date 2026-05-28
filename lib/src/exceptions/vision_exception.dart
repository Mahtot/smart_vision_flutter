class VisionException implements Exception {
  final String message;

  VisionException(this.message);

  @override
  String toString() => 'VisionException: $message';
}
