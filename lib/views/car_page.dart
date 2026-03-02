import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // <- Esto es clave
import '../providers/car_provider.dart';


class CarPage extends StatefulWidget { // Página para mostrar la lista de coches
 const CarPage({super.key}); // Constructor de la clase CarPage, que es un widget con estado (StatefulWidget) para poder manejar el estado de la carga de coches y la lista de coches obtenida desde la API

 @override
 State<CarPage> createState() => _CarPageState(); // Método que crea el estado asociado a esta página, que es una instancia de la clase _CarPageState, donde se implementará la lógica para cargar los coches desde la API y mostrar la lista de coches en la interfaz de usuario
}

class _CarPageState extends State<CarPage> { 

 @override
 void initState() {  // Método que se llama cuando se inicializa el estado de la página, donde se realizará la carga de coches desde la API utilizando el proveedor (CarProvider) para obtener los datos y actualizar la interfaz de usuario
   super.initState(); // Llama al método initState de la clase padre (State) para asegurarse de que se realice la inicialización adecuada del estado antes de cargar los coches
   Future.microtask(() => // Utiliza Future.microtask para programar la carga de coches después de que se haya completado la inicialización del estado, evitando así posibles problemas de contexto o de acceso a la instancia del proveedor antes de que esté completamente inicializada
       Provider.of<CarProvider>(context, listen: false).fetchCars()); // Obtiene la instancia del proveedor (CarProvider) utilizando Provider.of, con listen: false para evitar que este widget se reconstruya cada vez que el estado del proveedor cambie, y llama al método fetchCars() del proveedor para iniciar la carga de coches desde la API. Esto permitirá que la lista de coches se actualice en la interfaz de usuario una vez que se hayan obtenido los datos desde la API.
 }

 @override
 Widget build(BuildContext context) { // Método que construye la interfaz de usuario de la página, donde se mostrará un indicador de carga mientras se están obteniendo los datos desde la API, y una lista de coches una vez que se hayan cargado los datos. Utiliza el proveedor (CarProvider) para acceder al estado de carga y a la lista de coches, y muestra la información correspondiente en la interfaz de usuario.

   final provider = Provider.of<CarProvider>(context); // Obtiene la instancia del proveedor (CarProvider) utilizando Provider.of, lo que permite acceder al estado de carga (isLoading) y a la lista de coches (cars) para mostrar la información correspondiente en la interfaz de usuario. Al no especificar listen: false, este widget se reconstruirá automáticamente cada vez que el estado del proveedor cambie, lo que es necesario para actualizar la interfaz de usuario cuando se carguen los datos desde la API.

   return Scaffold(
     appBar: AppBar(
       title: const Text('Lista de Coches - Uxue'), // Título de la barra de la aplicación (AppBar) que se muestra en la parte superior de la página, indicando que esta página muestra una lista de coches. El título es un widget de texto (Text) con el contenido "Lista de Coches - Uxue".
     ),
     body: provider.isLoading // Si el proveedor indica que se están cargando los coches (isLoading es true), muestra un indicador de carga (CircularProgressIndicator) centrado en la pantalla. Si no se están cargando los coches (isLoading es false), muestra una lista de coches utilizando ListView.builder, donde cada elemento de la lista es un ListTile que muestra el nombre del coche (marca y modelo) como título, y el año del coche como subtítulo. La cantidad de elementos en la lista se determina por la longitud de la lista de coches obtenida desde el proveedor (provider.cars.length).
         ? const Center(child: CircularProgressIndicator()) // Si el proveedor indica que se están cargando los coches (isLoading es true), muestra un indicador de carga (CircularProgressIndicator) centrado en la pantalla utilizando el widget Center para centrar el indicador.
         : ListView.builder(
             itemCount: provider.cars.length, // La cantidad de elementos en la lista se determina por la longitud de la lista de coches obtenida desde el proveedor (provider.cars.length), lo que permite mostrar un ListTile para cada coche en la lista.
             itemBuilder: (context, index) { // El itemBuilder es una función que se llama para construir cada elemento de la lista, donde se obtiene el coche correspondiente al índice actual (index) de la lista de coches del proveedor (provider.cars[index]), y se devuelve un ListTile que muestra el nombre del coche (marca y modelo) como título, y el año del coche como subtítulo.
               final car = provider.cars[index]; // Obtiene el coche correspondiente al índice actual (index) de la lista de coches del proveedor (provider.cars[index]), lo que permite acceder a las propiedades del coche (como marca, modelo y año) para mostrarlas en el ListTile.
               return ListTile(
                 title: Text('${car.make} ${car.model}'), // Muestra el nombre del coche (marca y modelo) como título del ListTile utilizando un widget de texto (Text) con interpolación de cadenas para combinar la marca y el modelo del coche.
                 subtitle: Text('Año: ${car.year}'), // Muestra el año del coche como subtítulo del ListTile utilizando un widget de texto (Text) con interpolación de cadenas para mostrar el año del coche.
               );
             },
           ),
   );
 }
}
