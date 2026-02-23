import 'package:flutter/material.dart';
import 'views/joke_page.dart'; // o 'car_page.dart', según quieras probar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: JokePage(), // Cambia por CarPage() si quieres
    );
  }
}