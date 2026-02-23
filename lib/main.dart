import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- Importa provider aquí
import 'providers/car_provider.dart';
import 'views/car_page.dart';
void main() {
 runApp(
   ChangeNotifierProvider(
     create: (_) => CarProvider(),
     child: const MyApp(),
   ),
 );
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
   return const MaterialApp(
     home: CarPage(),
   );
 }
}
