import 'package:flutter_hello_world/services/car_service.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {

 test('Get cars from API', () async {

   final service = CarService(); // Crea una instancia del servicio (CarService) para poder llamar al método getCars() y obtener la lista de coches desde la API.
   final cars = await service.getCars(); // Llama al método getCars() del servicio para obtener la lista de coches desde la API, y espera a que se complete la solicitud para obtener los datos. El resultado se almacena en la variable cars, que es una lista de objetos CarModel que contienen la información de cada coche obtenida desde la API.

   expect(cars.isNotEmpty, true); // Verifica que la lista de coches obtenida desde la API no esté vacía, utilizando el método isNotEmpty para comprobar que se han obtenido datos válidos desde la API. Si la lista de coches está vacía, la prueba fallará, lo que indicará que hubo un problema al obtener los datos desde la API o que la API no devolvió ningún coche válido.
 });
}
