class StopArrivalModel {
  final String stopName;
  final List<BusArrival> arrivals;

  StopArrivalModel({
    required this.stopName,
    required this.arrivals,
  });

  factory StopArrivalModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    final ibus = data['ibus'] ?? [];

    return StopArrivalModel(
      stopName: data['stop_name'] ?? '',
      arrivals: List<BusArrival>.from(
        ibus.map((x) => BusArrival.fromJson(x)),
      ),
    );
  }
}

class BusArrival {
  final String line;
  final String destination;
  final String time;

  BusArrival({
    required this.line,
    required this.destination,
    required this.time,
  });

  factory BusArrival.fromJson(Map<String, dynamic> json) {
    return BusArrival(
      line: json['line'] ?? '',
      destination: json['destination'] ?? '',
      time: json['text-ca'] ?? json['text-es'] ?? '',
    );
  }
}