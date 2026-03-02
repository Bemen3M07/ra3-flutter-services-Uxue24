import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/stop_arrival_model.dart';
import '../models/line_model.dart';
import '../models/route_model.dart';

class TmbService {
  final String _appId = 'fb76219c';
  final String _appKey = '70d0a259cab0c2b26628777cfe04371c';

  // IBUS - Parada + buses que pasan
  Future<StopArrivalModel> getStopInfo(String stopCode) async {
    final url = Uri.parse(
      'https://api.tmb.cat/v1/ibus/stops/$stopCode?app_id=$_appId&app_key=$_appKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      print("STOP RESPONSE:");
      print(jsonData);

      return StopArrivalModel.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener la parada: ${response.statusCode}');
    }
  }

  // TRANSIT - Lista de líneas de bus (VERSIÓN ROBUSTA)
  Future<List<LineModel>> getBusLines() async {
    final url = Uri.parse(
      'https://api.tmb.cat/v1/transit/linies/bus?app_id=$_appId&app_key=$_appKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      print("LINES RESPONSE:");
      print(jsonData);

      List linesJson = [];

      // Caso 1: { data: { bus: [...] } }
      if (jsonData['data'] != null &&
          jsonData['data'] is Map &&
          jsonData['data']['bus'] != null) {
        linesJson = jsonData['data']['bus'];
      }
      // Caso 2: { data: [...] }
      else if (jsonData['data'] != null && jsonData['data'] is List) {
        linesJson = jsonData['data'];
      }
      // Caso 3: { data: { linies: [...] } }
      else if (jsonData['data'] != null &&
          jsonData['data'] is Map &&
          jsonData['data']['linies'] != null) {
        linesJson = jsonData['data']['linies'];
      }
      // Caso 4: { linies: [...] } directo
      else if (jsonData['linies'] != null) {
        linesJson = jsonData['linies'];
      }

      // Convierte cada línea a LineModel
      return linesJson.map((e) => LineModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener líneas: ${response.statusCode}');
    }
  }

  // PLANNER - Cálculo de ruta
  Future<RouteModel> getRoute({
    required String fromPlace,
    required String toPlace,
    required String date,
    required String time,
    required bool arriveBy,
  }) async {
    final url = Uri.parse(
      'https://api.tmb.cat/v1/planner/plan'
      '?fromPlace=$fromPlace'
      '&toPlace=$toPlace'
      '&date=$date'
      '&time=$time'
      '&arriveBy=$arriveBy'
      '&mode=TRANSIT,WALK'
      '&app_id=$_appId'
      '&app_key=$_appKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      print("ROUTE RESPONSE:");
      print(jsonData);

      return RouteModel.fromJson(jsonData);
    } else {
      throw Exception('Error al calcular ruta: ${response.statusCode}');
    }
  }
}