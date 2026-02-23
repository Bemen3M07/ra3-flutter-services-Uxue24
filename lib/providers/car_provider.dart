import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../services/car_service.dart';

class CarProvider extends ChangeNotifier {

 List<CarModel> _cars = [];
 List<CarModel> get cars => _cars;

 bool _isLoading = false;
 bool get isLoading => _isLoading;

 Future<void> fetchCars() async {
   _isLoading = true;
   notifyListeners();

   _cars = await CarService().getCars();

   _isLoading = false;
   notifyListeners();
 }
}
