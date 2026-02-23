class CarService {

 final String _url = 'https://car-data.p.rapidapi.com/cars?limit=10&page=0';
 final String _apiKey = 'TU_API_KEY_AQUI';
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
