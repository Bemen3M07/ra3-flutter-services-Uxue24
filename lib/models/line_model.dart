class LineModel { // Modelo de datos para una línea de transporte
  final String name; // Nombre de la línea
  final String description; // Descripción de la línea (puede incluir información adicional como horarios, rutas, etc.)

  LineModel({ 
    required this.name, // Nombre de la línea
    required this.description, // Descripción de la línea (puede incluir información adicional como horarios, rutas, etc.)
  });

  factory LineModel.fromJson(Map<String, dynamic> json) { // Crea una instancia de LineModel a partir de un JSON
    return LineModel(  
      name: json['name'] ?? '', // Nombre de la línea (si no está presente en el JSON, se asigna una cadena vacía)
      description: json['desc'] ?? '', // Descripción de la línea (si no está presente en el JSON, se asigna una cadena vacía)
    );
  }
}