import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_hello_world/main.dart';

void main() {
  testWidgets('Hello World screen displays correctly', (WidgetTester tester) async { 
    await tester.pumpWidget(const MyApp()); // Carga el widget MyApp en el entorno de prueba utilizando tester.pumpWidget(), lo que permite renderizar la interfaz de usuario definida en MyApp para realizar pruebas sobre ella. Al cargar MyApp, se inicia la aplicación y se muestra la pantalla de inicio (HomeScreen) como la pantalla principal de la aplicación, lo que permite verificar que los elementos de la interfaz de usuario se muestren correctamente en la pantalla.

    expect(find.text('Hello World!'), findsOneWidget); // Verifica que el texto "Hello World!" se muestre en la pantalla utilizando find.text() para buscar el widget de texto que contiene ese contenido, y findsOneWidget para asegurarse de que se encuentre exactamente un widget con ese texto en la pantalla. Si el texto "Hello World!" no se encuentra o si se encuentra más de una vez, la prueba fallará, lo que indicará que hay un problema con la visualización del texto en la pantalla de inicio (HomeScreen) de la aplicación.
    expect(find.text('Hello World'), findsOneWidget); // Verifica que el texto "Hello World" (sin el signo de exclamación) se muestre en la pantalla utilizando find.text() para buscar el widget de texto que contiene ese contenido, y findsOneWidget para asegurarse de que se encuentre exactamente un widget con ese texto en la pantalla. Si el texto "Hello World" no se encuentra o si se encuentra más de una vez, la prueba fallará, lo que indicará que hay un problema con la visualización del texto en la pantalla de inicio (HomeScreen) de la aplicación.
  });
}
