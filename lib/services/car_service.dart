import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_hello_world/models/car_model.dart';

class CarService {

final String _url = 'https://car-data.p.rapidapi.com/cars?limit=10&page=0';
final String _apiKey = '7d5f6cf3famsh4d2717acd0f6080p15f7e7jsnfc6853b11e23';
final String _host = 'car-data.p.rapidapi.com';

 Future<List<CarModel>> getCars() async {

   final response = await http.get(
     Uri.parse(_url),
     headers: {
       'X-RapidAPI-Key': _apiKey,
       'X-RapidAPI-Host': _host,
     },
   );

   if (response.statusCode == 200) {
     List jsonResponse = json.decode(response.body);
     return jsonResponse.map((car) => CarModel.fromJson(car)).toList();
   } else {
     throw Exception('Error al cargar coches');
   }
 }
}
