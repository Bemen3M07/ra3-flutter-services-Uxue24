class LineModel {
  final String name;
  final String description;

  LineModel({
    required this.name,
    required this.description,
  });

  factory LineModel.fromJson(Map<String, dynamic> json) {
    return LineModel(
      name: json['name'] ?? '',
      description: json['desc'] ?? '',
    );
  }
}