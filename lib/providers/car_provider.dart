import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../services/car_service.dart';

class CarProvider extends ChangeNotifier { 

 List<CarModel> _cars = []; // Lista privada de coches
 List<CarModel> get cars => _cars; // Getter público para acceder a la lista de coches

 bool _isLoading = false; // Variable privada para indicar si se están cargando los coches
 bool get isLoading => _isLoading; // Getter público para acceder al estado de carga

 Future<void> fetchCars() async { 
   _isLoading = true; // Indica que se están cargando los coches
   notifyListeners(); // Notifica a los widgets que están escuchando que el estado ha cambiado

   _cars = await CarService().getCars(); // Llama al servicio para obtener la lista de coches y la asigna a la variable privada

   _isLoading = false; // Indica que se ha terminado de cargar los coches
   notifyListeners(); // Notifica a los widgets que están escuchando que el estado ha cambiado
 }
}
