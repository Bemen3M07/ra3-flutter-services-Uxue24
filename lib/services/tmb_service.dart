import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/stop_arrival_model.dart'; // Modelo de datos para la información de llegada a una parada
import '../models/line_model.dart'; // Modelo de datos para una línea de transporte (puede incluir información como nombre, descripción, horarios, etc.)
import '../models/route_model.dart'; // Modelo de datos para una ruta de transporte (puede incluir información como origen, destino, duración, pasos de la ruta, etc.)

class TmbService { 
  final String _appId = 'fb76219c'; // ID de aplicación para autenticarse con la API de TMB
  final String _appKey = '70d0a259cab0c2b26628777cfe04371c'; // Clave de aplicación para autenticarse con la API de TMB
 
  // IBUS - Parada + buses que pasan
  Future<StopArrivalModel> getStopInfo(String stopCode) async { 
    final url = Uri.parse(
      'https://api.tmb.cat/v1/ibus/stops/$stopCode?app_id=$_appId&app_key=$_appKey', // URL de la API para obtener la información de llegada a una parada específica, incluyendo el código de la parada y los parámetros de autenticación (ID de aplicación y clave de aplicación)
    );

    final response = await http.get(url); // Realiza una solicitud GET a la URL de la API para obtener la información de llegada a la parada

    if (response.statusCode == 200) { // Si la respuesta de la API es exitosa (código de estado 200)
      final Map<String, dynamic> jsonData = json.decode(response.body); // Decodifica la respuesta JSON de la API en un mapa de objetos dinámicos

      print("STOP RESPONSE:"); // Imprime un mensaje de depuración para indicar que se ha recibido la respuesta de la API para la parada
      print(jsonData);  // Imprime la respuesta JSON decodificada para verificar su estructura y contenido

      return StopArrivalModel.fromJson(jsonData); // Crea una instancia de StopArrivalModel a partir de la respuesta JSON utilizando el método fromJson de StopArrivalModel, y devuelve la información de llegada a la parada
    } else {
      throw Exception('Error al obtener la parada: ${response.statusCode}'); // Si la respuesta de la API no es exitosa, lanza una excepción con un mensaje de error que incluye el código de estado de la respuesta
    }
  }

  // TRANSIT - Lista de líneas de bus (VERSIÓN ROBUSTA)
  Future<List<LineModel>> getBusLines() async { 
    final url = Uri.parse(
      'https://api.tmb.cat/v1/transit/linies/bus?app_id=$_appId&app_key=$_appKey', // URL de la API para obtener la lista de líneas de bus, incluyendo los parámetros de autenticación (ID de aplicación y clave de aplicación)
    );

    final response = await http.get(url); // Realiza una solicitud GET a la URL de la API para obtener la lista de líneas de bus

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body); // Decodifica la respuesta JSON de la API en un mapa de objetos dinámicos

      print("LINES RESPONSE:"); // Imprime un mensaje de depuración para indicar que se ha recibido la respuesta de la API para las líneas de bus
      print(jsonData);

      List linesJson = [];

      // Caso 1: { data: { bus: [...] } }
      if (jsonData['data'] != null && 
          jsonData['data'] is Map && // Verifica que 'data' existe y es un mapa
          jsonData['data']['bus'] != null) { // Verifica que 'bus' existe dentro de 'data'
        linesJson = jsonData['data']['bus']; // Asigna la lista de líneas de bus a partir de 'data.bus'
      } 
      // Caso 2: { data: [...] }
      else if (jsonData['data'] != null && jsonData['data'] is List) { // Verifica que 'data' existe y es una lista
        linesJson = jsonData['data']; // Asigna la lista de líneas de bus a partir de 'data' directamente
      }
      // Caso 3: { data: { linies: [...] } }
      else if (jsonData['data'] != null && // Verifica que 'data' existe
          jsonData['data'] is Map && // Verifica que 'data' es un mapa
          jsonData['data']['linies'] != null) { // Verifica que 'linies' existe dentro de 'data'
        linesJson = jsonData['data']['linies']; // Asigna la lista de líneas de bus a partir de 'data.linies'
      }
      // Caso 4: { linies: [...] } directo
      else if (jsonData['linies'] != null) {
        linesJson = jsonData['linies'];
      }

      // Convierte cada línea a LineModel
      return linesJson.map((e) => LineModel.fromJson(e)).toList(); // Mapea cada objeto JSON de línea a una instancia de LineModel utilizando el método fromJson de LineModel, y devuelve la lista de líneas de bus
    } else {
      throw Exception('Error al obtener líneas: ${response.statusCode}'); // Si la respuesta de la API no es exitosa, lanza una excepción con un mensaje de error que incluye el código de estado de la respuesta
    }
  }

  // PLANNER - Cálculo de ruta
  Future<RouteModel> getRoute({
    required String fromPlace, // Lugar de origen para el cálculo de la ruta
    required String toPlace,  // Lugar de destino para el cálculo de la ruta
    required String date,   // Fecha para el cálculo de la ruta (puede estar en formato "YYYY-MM-DD" o "DD/MM/YYYY" dependiendo de la API)
    required String time,  // Hora para el cálculo de la ruta (puede estar en formato "HH:mm" o "HH:mm:ss" dependiendo de la API)
    required bool arriveBy,  // Indica si la hora proporcionada es para llegar a la hora de destino (true) o para salir a la hora de origen (false)
  }) async {
    final url = Uri.parse(
      'https://api.tmb.cat/v1/planner/plan' // URL de la API para calcular una ruta de transporte, incluyendo los parámetros necesarios para el cálculo de la ruta (lugar de origen, lugar de destino, fecha, hora, tipo de hora) y los parámetros de autenticación (ID de aplicación y clave de aplicación)
      '?fromPlace=$fromPlace' 
      '&toPlace=$toPlace'
      '&date=$date'
      '&time=$time'
      '&arriveBy=$arriveBy'
      '&mode=TRANSIT,WALK'
      '&app_id=$_appId'
      '&app_key=$_appKey',
    );

    final response = await http.get(url); // Realiza una solicitud GET a la URL de la API para calcular la ruta de transporte

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body); // Decodifica la respuesta JSON de la API en un mapa de objetos dinámicos

      print("ROUTE RESPONSE:");
      print(jsonData);

      return RouteModel.fromJson(jsonData); // Crea una instancia de RouteModel a partir de la respuesta JSON utilizando el método fromJson de RouteModel, y devuelve la ruta de transporte calculada
    } else {
      throw Exception('Error al calcular ruta: ${response.statusCode}'); // Si la respuesta de la API no es exitosa, lanza una excepción con un mensaje de error que incluye el código de estado de la respuesta
    }
  }
}