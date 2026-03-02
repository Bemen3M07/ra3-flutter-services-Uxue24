import 'package:flutter/material.dart';
import '../services/joke_service.dart';
import '../models/joke_model.dart';

class JokePage extends StatefulWidget {
 const JokePage({super.key}); // Clase que representa la página de chistes, que es un widget con estado (StatefulWidget) para poder mostrar un chiste aleatorio obtenido desde la API y actualizar la interfaz de usuario cada vez que se solicite un nuevo chiste. La clase JokePage extiende StatefulWidget, lo que permite crear una instancia de su estado asociado (_JokePageState) para manejar la lógica de carga y visualización de los chistes en la interfaz de usuario.
 
 @override
 State<JokePage> createState() => _JokePageState(); // Método que crea el estado asociado a esta página, que es una instancia de la clase _JokePageState, donde se implementará la lógica para cargar un chiste aleatorio desde la API utilizando el servicio (JokeService) y mostrar el chiste en la interfaz de usuario. Al crear el estado asociado, se permite manejar la lógica de carga y actualización de los chistes en la interfaz de usuario cada vez que se solicite un nuevo chiste.
}

class _JokePageState extends State<JokePage> { 

 JokeModel? joke; 

 void loadJoke() async {
   final newJoke = await JokeService().getRandomJoke(); // Llama al servicio (JokeService) para obtener un chiste aleatorio desde la API utilizando el método getRandomJoke(), y espera a que se complete la solicitud para obtener el chiste. El resultado se almacena en la variable newJoke, que es una instancia de JokeModel que contiene la información del chiste obtenido desde la API.
   setState(() {
     joke = newJoke; // Actualiza el estado de la página asignando el nuevo chiste obtenido desde la API a la variable joke, lo que provocará que la interfaz de usuario se reconstruya para mostrar el nuevo chiste. Al llamar a setState(), se notifica a Flutter que el estado ha cambiado y que la interfaz de usuario debe actualizarse para reflejar el nuevo estado, lo que permitirá mostrar el nuevo chiste en la pantalla cada vez que se solicite un nuevo chiste utilizando el botón correspondiente en la interfaz de usuario.
   });
 }

 @override
 void initState() {
   super.initState(); // Llama al método initState de la clase padre (State) para asegurarse de que se realice la inicialización adecuada del estado antes de cargar el chiste. Esto es importante para evitar posibles problemas de contexto o de acceso a la instancia del servicio antes de que esté completamente inicializada.
   loadJoke();
 }

 @override
 Widget build(BuildContext context) {

   return Scaffold(
     appBar: AppBar(title: const Text('Chistes API')), // Barra de la aplicación (AppBar) que se muestra en la parte superior de la página, con un título que indica que esta página muestra chistes obtenidos desde una API. El título es un widget de texto (Text) con el contenido "Chistes API".
     body: Center(
       child: joke == null
           ? const CircularProgressIndicator() // Si la variable joke es null (lo que indica que aún no se ha cargado un chiste desde la API), muestra un indicador de carga (CircularProgressIndicator) en el centro de la pantalla para informar al usuario que se está cargando el chiste. El widget CircularProgressIndicator se muestra condicionalmente utilizando un operador ternario, lo que permite mostrarlo solo cuando no se ha cargado un chiste válido desde la API.
           : Padding(
               padding: const EdgeInsets.all(20), // Agrega un padding de 20 píxeles alrededor del contenido que muestra el chiste, utilizando el widget Padding para proporcionar un espacio visual entre el contenido del chiste y los bordes de la pantalla, lo que mejora la apariencia y legibilidad del chiste en la interfaz de usuario.
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente el contenido de la columna que muestra el chiste, utilizando mainAxisAlignment: MainAxisAlignment.center para alinear el contenido en el centro de la pantalla, lo que mejora la presentación del chiste en la interfaz de usuario.
                 children: [
                   Text(joke!.setup),
                   const SizedBox(height: 20), // Agrega un espacio vertical de 20 píxeles entre el texto del setup del chiste y el texto del punchline, utilizando el widget SizedBox para proporcionar un espacio visual entre los elementos de la interfaz de usuario, lo que mejora la apariencia y legibilidad del chiste en la pantalla.
                   Text(
                     joke!.punchline,
                     style: const TextStyle(fontWeight: FontWeight.bold), // Aplica un estilo de texto en negrita al punchline del chiste, utilizando el widget TextStyle con fontWeight: FontWeight.bold para resaltar el punchline y mejorar su visibilidad en la interfaz de usuario, lo que hace que el punchline del chiste sea más destacado y fácil de leer para el usuario.
                   ),
                   const SizedBox(height: 20), // Agrega un espacio vertical de 20 píxeles entre el texto del punchline del chiste y el botón para solicitar un nuevo chiste, utilizando el widget SizedBox para proporcionar un espacio visual entre los elementos de la interfaz de usuario, lo que mejora la apariencia y legibilidad del chiste en la pantalla.
                   ElevatedButton(
                     onPressed: loadJoke,
                     child: const Text('Nuevo chiste'), // Botón que permite al usuario solicitar un nuevo chiste desde la API, utilizando el widget ElevatedButton con un texto que indica "Nuevo chiste". Al presionar el botón, se llama al método loadJoke() para cargar un nuevo chiste desde la API y actualizar la interfaz de usuario con el nuevo chiste obtenido.
                   )
                 ],
               ),
             ),
     ),
   );
 }
}
