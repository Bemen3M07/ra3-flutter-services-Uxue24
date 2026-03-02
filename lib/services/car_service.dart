import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_hello_world/models/car_model.dart';

class CarService {
 
final String _url = 'https://car-data.p.rapidapi.com/cars?limit=10&page=0'; // URL de la API para obtener la lista de coches
final String _apiKey = '7d5f6cf3famsh4d2717acd0f6080p15f7e7jsnfc6853b11e23'; // Clave de API para autenticarse con la API de coches
final String _host = 'car-data.p.rapidapi.com'; // Host de la API para autenticarse con la API de coches
 
 Future<List<CarModel>> getCars() async { // Método para obtener la lista de coches desde la API

   final response = await http.get(
     Uri.parse(_url), // Realiza una solicitud GET a la URL de la API
     headers: { 
       'X-RapidAPI-Key': _apiKey,  // Agrega la clave de API en los encabezados de la solicitud para autenticarse con la API de coches
       'X-RapidAPI-Host': _host, // Agrega el host de la API en los encabezados de la solicitud para autenticarse con la API de coches
     },
   );

   if (response.statusCode == 200) { // Si la respuesta de la API es exitosa (código de estado 200)
     List jsonResponse = json.decode(response.body); // Decodifica la respuesta JSON de la API en una lista de objetos dinámicos
     return jsonResponse.map((car) => CarModel.fromJson(car)).toList(); // Mapea cada objeto JSON de coche a una instancia de CarModel utilizando el método fromJson de CarModel, y devuelve la lista de coches
   } else {
     throw Exception('Error al cargar coches'); // Si la respuesta de la API no es exitosa, lanza una excepción con un mensaje de error
   }
 }
}
