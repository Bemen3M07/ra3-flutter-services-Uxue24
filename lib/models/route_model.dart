class RouteModel {
  final List<RouteStep> steps; // Lista de pasos en la ruta

  RouteModel({required this.steps}); // Constructor que requiere la lista de pasos

  factory RouteModel.fromJson(Map<String, dynamic> json) { // Crea una instancia de RouteModel a partir de un JSON
    final plan = json['plan'] ?? {}; // Obtiene el plan de viaje del JSON, si no existe, se asigna un mapa vacío
    final itineraries = plan['itineraries'] ?? []; // Obtiene las itinerarios del plan, si no existen, se asigna una lista vacía

    if (itineraries.isEmpty) { 
      return RouteModel(steps: []); // Si no hay itinerarios, se devuelve un RouteModel con una lista de pasos vacía
    }

    final legs = itineraries[0]['legs'] ?? []; // Obtiene las piernas del primer itinerario, si no existen, se asigna una lista vacía

    return RouteModel( 
      steps: List<RouteStep>.from(  // Crea una lista de RouteStep a partir de las piernas del itinerario
        legs.map((x) => RouteStep.fromJson(x)), // Mapea cada pierna a un RouteStep utilizando el método fromJson de RouteStep
      ),
    );
  }
}

class RouteStep {
  final String mode; // Modo de transporte (por ejemplo, "WALK", "BUS", "SUBWAY", etc.)
  final String from; // Punto de origen del paso
  final String to; // Punto de destino del paso

  RouteStep({
    required this.mode,  // Constructor que requiere el modo de transporte, el punto de origen y el punto de destino
    required this.from, // Punto de origen del paso
    required this.to, // Punto de destino del paso
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) { // Crea una instancia de RouteStep a partir de un JSON
    return RouteStep( 
      mode: json['mode'] ?? '', // Obtiene el modo de transporte del JSON, si no existe, se asigna una cadena vacía
      from: json['from']['name'] ?? '', // Obtiene el nombre del punto de origen del JSON, si no existe, se asigna una cadena vacía
      to: json['to']['name'] ?? '', // Obtiene el nombre del punto de destino del JSON, si no existe, se asigna una cadena vacía
    );
  }
}