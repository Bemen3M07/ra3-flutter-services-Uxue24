class StopArrivalModel {
  final String stopName; // Nombre de la parada
  final List<BusArrival> arrivals; // Lista de llegadas de buses a esa parada

  StopArrivalModel({
    required this.stopName, // Nombre de la parada
    required this.arrivals, // Lista de llegadas de buses a esa parada
  });

  factory StopArrivalModel.fromJson(Map<String, dynamic> json) { // Crea una instancia de StopArrivalModel a partir de un JSON
    final data = json['data'] ?? {}; // Obtiene los datos del JSON, si no existen, se asigna un mapa vacío

    final ibus = data['ibus'] ?? []; // Obtiene la lista de llegadas de buses del JSON, si no existe, se asigna una lista vacía

    return StopArrivalModel( 
      stopName: data['stop_name'] ?? '', // Obtiene el nombre de la parada del JSON, si no existe, se asigna una cadena vacía
      arrivals: List<BusArrival>.from( // Crea una lista de BusArrival a partir de la lista de llegadas de buses del JSON
        ibus.map((x) => BusArrival.fromJson(x)), // Mapea cada llegada de bus a una instancia de BusArrival utilizando el método fromJson de BusArrival
      ),
    );
  }
}

class BusArrival { 
  final String line; // Línea del bus que llega a la parada
  final String destination;   // Destino del bus que llega a la parada
  final String time; // Hora de llegada del bus a la parada (puede estar en formato "text-ca" o "text-es" dependiendo del idioma)

  BusArrival({
    required this.line, // Línea del bus que llega a la parada
    required this.destination,  // Destino del bus que llega a la parada
    required this.time, // Hora de llegada del bus a la parada (puede estar en formato "text-ca" o "text-es" dependiendo del idioma)
  });

  factory BusArrival.fromJson(Map<String, dynamic> json) { // Crea una instancia de BusArrival a partir de un JSON
    return BusArrival(
      line: json['line'] ?? '', // Obtiene la línea del bus del JSON, si no existe, se asigna una cadena vacía
      destination: json['destination'] ?? '', // Obtiene el destino del bus del JSON, si no existe, se asigna una cadena vacía
      time: json['text-ca'] ?? json['text-es'] ?? '', // Obtiene la hora de llegada del bus del JSON, primero intenta con "text-ca", si no existe, intenta con "text-es", si tampoco existe, se asigna una cadena vacía
    );
  }
}