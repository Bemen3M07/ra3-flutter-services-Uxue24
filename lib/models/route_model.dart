class RouteModel {
  final List<RouteStep> steps;

  RouteModel({required this.steps});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final plan = json['plan'] ?? {};
    final itineraries = plan['itineraries'] ?? [];

    if (itineraries.isEmpty) {
      return RouteModel(steps: []);
    }

    final legs = itineraries[0]['legs'] ?? [];

    return RouteModel(
      steps: List<RouteStep>.from(
        legs.map((x) => RouteStep.fromJson(x)),
      ),
    );
  }
}

class RouteStep {
  final String mode;
  final String from;
  final String to;

  RouteStep({
    required this.mode,
    required this.from,
    required this.to,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) {
    return RouteStep(
      mode: json['mode'] ?? '',
      from: json['from']['name'] ?? '',
      to: json['to']['name'] ?? '',
    );
  }
}