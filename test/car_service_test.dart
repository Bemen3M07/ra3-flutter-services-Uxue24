import 'package:flutter_hello_world/services/car_service.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {

 test('Get cars from API', () async {

   final service = CarService();
   final cars = await service.getCars();

   expect(cars.isNotEmpty, true);
 });
}
