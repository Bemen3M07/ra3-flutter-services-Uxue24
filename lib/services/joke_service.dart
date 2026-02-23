import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/joke_model.dart';

class JokeService {

 final String _url = 'https://api.sampleapis.com/jokes/goodJokes';

 Future<JokeModel> getRandomJoke() async {

   final response = await http.get(Uri.parse(_url));

   if (response.statusCode == 200) {
     List jsonResponse = json.decode(response.body);
     final random = Random();
     final joke = jsonResponse[random.nextInt(jsonResponse.length)];
     return JokeModel.fromJson(joke);
   } else {
     throw Exception('Error al cargar chiste');
   }
 }
}
