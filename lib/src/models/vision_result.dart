class VisionResult {
  final String description;

  VisionResult({required this.description});

  factory VisionResult.fromJson(Map<String, dynamic> json) {
    return VisionResult(description: json['description'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'description': description};
  }
}
