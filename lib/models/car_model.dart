class CarModel {
 final String make;
 final String model;
 final int year;

 CarModel({
   required this.make,
   required this.model,
   required this.year,
 });

 factory CarModel.fromJson(Map<String, dynamic> json) {
   return CarModel(
     make: json['make'],
     model: json['model'],
     year: json['year'],
   );
 }

 Map<String, dynamic> toJson() {
   return {
     'make': make,
     'model': model,
     'year': year,
   };
 }
}
