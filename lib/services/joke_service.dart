import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/joke_model.dart';

class JokeService {

 final String _url = 'https://api.sampleapis.com/jokes/goodJokes'; // URL de la API para obtener chistes

 Future<JokeModel> getRandomJoke() async { // Método para obtener un chiste aleatorio desde la API
 
   final response = await http.get(Uri.parse(_url)); // Realiza una solicitud GET a la URL de la API para obtener la lista de chistes

   if (response.statusCode == 200) { // Si la respuesta de la API es exitosa (código de estado 200)
     List jsonResponse = json.decode(response.body); // Decodifica la respuesta JSON de la API en una lista de objetos dinámicos
     final random = Random(); // Crea una instancia de la clase Random para generar un número aleatorio
     final joke = jsonResponse[random.nextInt(jsonResponse.length)]; // Selecciona un chiste aleatorio de la lista utilizando el número aleatorio generado
     return JokeModel.fromJson(joke); // Crea una instancia de JokeModel a partir del chiste seleccionado utilizando el método fromJson de JokeModel, y devuelve el chiste
   } else { // Si la respuesta de la API no es exitosa, lanza una excepción con un mensaje de error
     throw Exception('Error al cargar chiste'); // Si la respuesta de la API no es exitosa, lanza una excepción con un mensaje de error
   }
 }
}
