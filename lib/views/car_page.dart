import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // <- Esto es clave
import '../providers/car_provider.dart';


class CarPage extends StatefulWidget {
 const CarPage({super.key});

 @override
 State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {

 @override
 void initState() {
   super.initState();
   Future.microtask(() =>
       Provider.of<CarProvider>(context, listen: false).fetchCars());
 }

 @override
 Widget build(BuildContext context) {

   final provider = Provider.of<CarProvider>(context);

   return Scaffold(
     appBar: AppBar(
       title: const Text('Lista de Coches - Uxue'),
     ),
     body: provider.isLoading
         ? const Center(child: CircularProgressIndicator())
         : ListView.builder(
             itemCount: provider.cars.length,
             itemBuilder: (context, index) {
               final car = provider.cars[index];
               return ListTile(
                 title: Text('${car.make} ${car.model}'),
                 subtitle: Text('Año: ${car.year}'),
               );
             },
           ),
   );
 }
}
