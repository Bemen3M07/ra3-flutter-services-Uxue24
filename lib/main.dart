import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
 runApp(const MyApp()); // Función principal que se ejecuta al iniciar la aplicación, donde se llama a runApp() para iniciar la aplicación y se pasa una instancia de MyApp como argumento, lo que indica que MyApp es el widget raíz de la aplicación. Al ejecutar runApp(), se inicia la aplicación y se muestra la interfaz de usuario definida en MyApp, que a su vez muestra la pantalla de inicio (HomeScreen) como la pantalla principal de la aplicación.
}

class MyApp extends StatelessWidget {
 const MyApp({super.key}); // Constructor de la clase MyApp, que es un widget sin estado (StatelessWidget) para definir la estructura básica de la aplicación, incluyendo el tema y la pantalla de inicio. La clase MyApp extiende StatelessWidget, lo que indica que este widget no tiene estado mutable y se utiliza principalmente para definir la estructura de la aplicación y mostrar la pantalla de inicio (HomeScreen) como el widget principal de la aplicación.

 @override
 Widget build(BuildContext context) { 
   return const MaterialApp( 
     debugShowCheckedModeBanner: false, // Elimina la etiqueta de "debug" que aparece en la esquina superior derecha de la aplicación cuando se ejecuta en modo de desarrollo, lo que mejora la apariencia de la aplicación durante el desarrollo y las pruebas. Al establecer debugShowCheckedModeBanner en false, se oculta esta etiqueta de "debug" para que no aparezca en la interfaz de usuario de la aplicación.
     home: HomeScreen(),
   );
 }
}
