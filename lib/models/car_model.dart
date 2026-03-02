class CarModel {
 final String make; // Marca del coche
 final String model; // Modelo del coche
 final int year; // Año de fabricación

 CarModel({
   required this.make, // Marca del coche
   required this.model, // Modelo del coche
   required this.year, // Año de fabricación
 });

 factory CarModel.fromJson(Map<String, dynamic> json) { // Crea una instancia de CarModel a partir de un JSON
   return CarModel(
     make: json['make'], // Marca del coche
     model: json['model'], // Modelo del coche
     year: json['year'], // Año de fabricación
   );
 }

 Map<String, dynamic> toJson() { // Convierte una instancia de CarModel a un JSON
   return {
     'make': make, // Marca del coche
     'model': model, // Modelo del coche
     'year': year, // Año de fabricación
   };
 }
}
