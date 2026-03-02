import 'package:flutter/material.dart';
import '../services/tmb_service.dart';
import '../models/stop_arrival_model.dart';
import '../models/line_model.dart';
import '../models/route_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // Constructor de la clase HomeScreen, que es un widget con estado (StatefulWidget) para poder manejar el estado de la carga de datos y la información obtenida desde la API de TMB, como la información de llegada a una parada, la lista de líneas de bus y las rutas de transporte calculadas. Esto permitirá mostrar esta información en la interfaz de usuario y actualizarla dinámicamente cuando se realicen nuevas consultas a la API.

  @override
  State<HomeScreen> createState() => _HomeScreenState(); // Método que crea el estado asociado a esta página, que es una instancia de la clase _HomeScreenState, donde se implementará la lógica para cargar los datos desde la API de TMB y mostrar la información correspondiente en la interfaz de usuario. El estado de esta página se encargará de manejar la carga de datos, el almacenamiento de la información obtenida desde la API y la actualización de la interfaz de usuario cuando se realicen nuevas consultas a la API.
}

class _HomeScreenState extends State<HomeScreen> {
  final TmbService _service = TmbService(); // Instancia del servicio TmbService para realizar las consultas a la API de TMB y obtener la información de llegada a una parada, la lista de líneas de bus y las rutas de transporte calculadas. Esta instancia se utilizará en los métodos de esta clase para llamar a los métodos del servicio y manejar la respuesta obtenida desde la API.
  final TextEditingController _controller = TextEditingController(); // Controlador de texto para manejar la entrada del código de parada en un campo de texto (TextField) en la interfaz de usuario. Este controlador se utilizará para obtener el valor ingresado por el usuario y realizar la consulta a la API de TMB para obtener la información de llegada a la parada correspondiente al código ingresado.

  StopArrivalModel? stopData; // Variable para almacenar la información de llegada a una parada obtenida desde la API de TMB, utilizando el modelo de datos StopArrivalModel. Esta variable se actualizará con la información obtenida desde la API y se mostrará en la interfaz de usuario para que el usuario pueda ver los detalles de la llegada a la parada consultada.
  RouteModel? route; // Variable para almacenar la información de una ruta de transporte calculada obtenida desde la API de TMB, utilizando el modelo de datos RouteModel. Esta variable se actualizará con la información obtenida desde la API y se mostrará en la interfaz de usuario para que el usuario pueda ver los detalles de la ruta calculada, como los pasos de la ruta, los modos de transporte involucrados, etc.

  // Para usar FutureBuilder con las líneas:
  Future<List<LineModel>>? futureLines;

  bool isLoading = false; // Variable para indicar si se están cargando los datos desde la API de TMB, lo que permitirá mostrar un indicador de carga (CircularProgressIndicator) en la interfaz de usuario mientras se espera la respuesta de la API. Esta variable se actualizará a true cuando se inicie una consulta a la API y se establecerá a false cuando se reciba la respuesta, lo que permitirá controlar la visualización del indicador de carga en la interfaz de usuario.
  String? errorMessage; // Variable para almacenar un mensaje de error en caso de que ocurra un error al realizar las consultas a la API de TMB, lo que permitirá mostrar un mensaje de error en la interfaz de usuario para informar al usuario sobre el problema ocurrido. Esta variable se actualizará con un mensaje de error específico cuando se capture una excepción durante las consultas a la API, y se mostrará en la interfaz de usuario para que el usuario pueda entender el motivo del error.
 
  void clearAll() {
    stopData = null; 
    route = null;
    errorMessage = null;
    futureLines = null;
  }

  @override
  Widget build(BuildContext context) { // Método que construye la interfaz de usuario de la página, donde se mostrará un campo de texto para ingresar el código de parada, botones para realizar las consultas a la API de TMB (buscar parada, cargar líneas y calcular ruta), un indicador de carga mientras se esperan las respuestas de la API, y la información obtenida desde la API (llegada a la parada, lista de líneas de bus y detalles de la ruta calculada) o un mensaje de error en caso de que ocurra un error durante las consultas a la API. La interfaz de usuario se actualizará dinámicamente en función del estado de carga, la información obtenida desde la API y los mensajes de error, proporcionando una experiencia interactiva para el usuario al consultar la información relacionada con el transporte público utilizando la API de TMB.
    return Scaffold(
      appBar: AppBar(title: const Text("TMB App")), // Barra de la aplicación (AppBar) que se muestra en la parte superior de la página, con un título que indica que esta aplicación está relacionada con TMB (Transports Metropolitans de Barcelona). El título es un widget de texto (Text) con el contenido "TMB App".
      body: Padding(
        padding: const EdgeInsets.all(16), // Padding alrededor del contenido de la página para proporcionar un espacio entre el borde de la pantalla y los elementos de la interfaz de usuario, utilizando el widget Padding con un valor de padding de 16 píxeles en todos los lados (EdgeInsets.all(16)).
        child: Column(
          children: [ 
            TextField( 
              controller: _controller, // Campo de texto para ingresar el código de parada, utilizando el widget TextField con un controlador de texto (TextEditingController) para manejar la entrada del usuario. El controlador se asigna a la variable _controller, lo que permitirá obtener el valor ingresado por el usuario para realizar la consulta a la API de TMB y obtener la información de llegada a la parada correspondiente al código ingresado.
              decoration: const InputDecoration(
                labelText: "Código de parada", // Etiqueta que se muestra dentro del campo de texto para indicar al usuario que debe ingresar el código de parada. La etiqueta es un widget de texto (Text) con el contenido "Código de parada".
              ),
            ),

            const SizedBox(height: 20), // Espacio vertical entre el campo de texto y los botones, utilizando el widget SizedBox con una altura de 20 píxeles para proporcionar un espacio visual entre los elementos de la interfaz de usuario.

            ElevatedButton(
              onPressed: () async { // Botón para buscar la información de llegada a una parada, utilizando el widget ElevatedButton con un controlador de eventos onPressed que se ejecuta cuando el usuario presiona el botón. El evento onPressed es una función asíncrona (async) que realiza la consulta a la API de TMB para obtener la información de llegada a la parada correspondiente al código ingresado en el campo de texto, y actualiza el estado de la página con la información obtenida o con un mensaje de error en caso de que ocurra un error durante la consulta.
                if (_controller.text.isEmpty) return; // Verifica si el campo de texto está vacío, y si es así, no realiza la consulta a la API y simplemente retorna, evitando así realizar una consulta con un código de parada vacío que podría resultar en un error o una respuesta no válida desde la API.

                setState(() {
                  isLoading = true; // Indica que se están cargando los datos desde la API de TMB, lo que permitirá mostrar un indicador de carga (CircularProgressIndicator) en la interfaz de usuario mientras se espera la respuesta de la API. El estado se actualiza a true para indicar que se ha iniciado la consulta a la API.
                  clearAll();
                });

                try {
                  final data = await _service.getStopInfo(_controller.text); // Realiza la consulta a la API de TMB utilizando el servicio TmbService para obtener la información de llegada a la parada correspondiente al código ingresado en el campo de texto (_controller.text). La consulta es asíncrona, por lo que se utiliza await para esperar la respuesta de la API antes de continuar con la ejecución del código. Si la consulta es exitosa, se almacena la información obtenida en la variable data.
                  setState(() {
                    stopData = data; // Actualiza el estado de la página con la información de llegada a la parada obtenida desde la API, asignando el valor de data a la variable stopData. Esto permitirá mostrar la información de llegada a la parada en la interfaz de usuario, proporcionando detalles como los buses que llegan a la parada, sus destinos y horarios.
                  });
                } catch (e) {
                  setState(() {
                    errorMessage = "Error al obtener la parada"; // Si ocurre un error durante la consulta a la API, se captura la excepción y se actualiza el estado de la página con un mensaje de error específico, asignando el valor "Error al obtener la parada" a la variable errorMessage. Esto permitirá mostrar un mensaje de error en la interfaz de usuario para informar al usuario sobre el problema ocurrido al intentar obtener la información de llegada a la parada.
                  });
                }

                setState(() {
                  isLoading = false; // Indica que se ha completado la carga de datos desde la API de TMB, lo que permitirá ocultar el indicador de carga (CircularProgressIndicator) en la interfaz de usuario. El estado se actualiza a false para indicar que se ha recibido la respuesta de la API y se ha procesado la información obtenida, ya sea mostrando los detalles de llegada a la parada o un mensaje de error en caso de que ocurriera un error durante la consulta.
                });
              },
              child: const Text("Buscar parada"), // Texto que se muestra dentro del botón para indicar al usuario que al presionar el botón se realizará la búsqueda de la información de llegada a una parada. El texto es un widget de texto (Text) con el contenido "Buscar parada".
            ),

            ElevatedButton(
              onPressed: () { // Botón para cargar la lista de líneas de bus, utilizando el widget ElevatedButton con un controlador de eventos onPressed que se ejecuta cuando el usuario presiona el botón. El evento onPressed es una función que actualiza el estado de la página para indicar que se están cargando los datos desde la API de TMB, limpia cualquier información previa y asigna la consulta a la API para obtener la lista de líneas de bus a la variable futureLines. Esto permitirá mostrar un indicador de carga mientras se espera la respuesta de la API, y luego mostrar la lista de líneas de bus obtenida desde la API en la interfaz de usuario utilizando un FutureBuilder.
                setState(() {
                  isLoading = true;
                  clearAll();
                  futureLines = _service.getBusLines(); // Realiza la consulta a la API de TMB utilizando el servicio TmbService para obtener la lista de líneas de bus. La consulta es asíncrona, por lo que se asigna a la variable futureLines, lo que permitirá utilizar un FutureBuilder en la interfaz de usuario para mostrar un indicador de carga mientras se espera la respuesta de la API, y luego mostrar la lista de líneas de bus obtenida desde la API una vez que se haya recibido la respuesta.
                });
              },
              child: const Text("Cargar líneas"), // Texto que se muestra dentro del botón para indicar al usuario que al presionar el botón se realizará la carga de la lista de líneas de bus. El texto es un widget de texto (Text) con el contenido "Cargar líneas".
            ),

            ElevatedButton(
              onPressed: () async { 
                setState(() {
                  isLoading = true; 
                  clearAll();
                });

                try {
                  final data = await _service.getRoute( // Realiza la consulta a la API de TMB utilizando el servicio TmbService para calcular una ruta de transporte entre un lugar de origen y un lugar de destino, con una fecha y hora específicas, y un tipo de hora (llegar a la hora de destino o salir a la hora de origen). La consulta es asíncrona, por lo que se utiliza await para esperar la respuesta de la API antes de continuar con la ejecución del código. Si la consulta es exitosa, se almacena la información obtenida en la variable data.
                    fromPlace: "41.3755204,2.1498870",
                    toPlace: "41.422520,2.187824",
                    date: "03-03-2026",
                    time: "12:00",
                    arriveBy: false,
                  );

                  setState(() {
                    route = data;
                  });
                } catch (e) {
                  setState(() {
                    errorMessage = "Error al calcular ruta";
                  });
                }

                setState(() {
                  isLoading = false;
                });
              },
              child: const Text("Calcular ruta"),
            ),

            const SizedBox(height: 20),

            if (isLoading) const CircularProgressIndicator(), // Si se están cargando los datos desde la API de TMB (isLoading es true), muestra un indicador de carga (CircularProgressIndicator) en la interfaz de usuario para informar al usuario que se está esperando la respuesta de la API. El widget CircularProgressIndicator se muestra condicionalmente utilizando un operador ternario, lo que permite mostrarlo solo cuando isLoading es true.

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red), // Si hay un mensaje de error (errorMessage no es null), muestra el mensaje de error en la interfaz de usuario utilizando un widget de texto (Text) con un estilo de texto que tiene el color rojo para resaltar el mensaje de error y llamar la atención del usuario sobre el problema ocurrido durante las consultas a la API de TMB.
              ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido de la columna al inicio (izquierda) para que los títulos y la información obtenida desde la API se muestren alineados a la izquierda, proporcionando una presentación más organizada y fácil de leer para el usuario. El widget Column tiene la propiedad crossAxisAlignment establecida en CrossAxisAlignment.start, lo que indica que los elementos dentro de la columna deben alinearse al inicio del eje horizontal (izquierda).
                  children: [

                    // Parada
                    if (stopData != null && stopData!.arrivals.isNotEmpty) ...[ // Si hay información de llegada a una parada (stopData no es null y la lista de llegadas no está vacía), muestra la información de llegada a la parada en la interfaz de usuario. Se utiliza el operador de propagación (...) para incluir los widgets dentro del bloque condicional, lo que permite mostrar los detalles de llegada a la parada, como los buses que llegan a la parada, sus destinos y horarios, utilizando un ListTile para cada bus que llega a la parada.
                      const Text(
                        "Parada:",
                        style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10), // Espacio vertical entre el título "Parada:" y la lista de llegadas a la parada, utilizando el widget SizedBox con una altura de 10 píxeles para proporcionar un espacio visual entre los elementos de la interfaz de usuario.
                      ...stopData!.arrivals.map(
                        (bus) => ListTile(
                          title: Text("Línea ${bus.line}"), // Título que muestra la línea del bus que llega a la parada, utilizando un widget de texto (Text) con el contenido "Línea " seguido del número de línea obtenido desde la información de llegada a la parada (bus.line).
                          subtitle: Text(bus.destination), // Subtítulo que muestra el destino del bus que llega a la parada, utilizando un widget de texto (Text) con el contenido del destino obtenido desde la información de llegada a la parada (bus.destination).
                          trailing: Text(bus.time), // Texto que se muestra al final del ListTile para indicar el horario de llegada del bus a la parada, utilizando un widget de texto (Text) con el contenido del horario obtenido desde la información de llegada a la parada (bus.time).
                        ),
                      ),
                    ],

                    // Líneas (con FutureBuilder)
                    if (futureLines != null) ...[
                      const Text(
                        "Líneas:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300, // Altura para que ListView.builder funcione dentro de SingleChildScrollView
                        child: FutureBuilder<List<LineModel>>(
                          future: futureLines,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) { // Si la consulta a la API de TMB para obtener la lista de líneas de bus aún está en espera (connectionState es ConnectionState.waiting), muestra un indicador de carga (CircularProgressIndicator) en la interfaz de usuario para informar al usuario que se está esperando la respuesta de la API. El widget CircularProgressIndicator se muestra condicionalmente utilizando un operador ternario, lo que permite mostrarlo solo cuando la consulta aún está en espera.
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}')); // Si ocurre un error durante la consulta a la API para obtener la lista de líneas de bus (snapshot.hasError es true), muestra un mensaje de error en la interfaz de usuario utilizando un widget de texto (Text) que incluye el mensaje de error obtenido desde el snapshot (snapshot.error). Esto permitirá informar al usuario sobre el problema ocurrido al intentar obtener la lista de líneas de bus desde la API de TMB.
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) { // Si la consulta a la API de TMB para obtener la lista de líneas de bus se ha completado pero no se ha recibido ningún dato (snapshot.hasData es false o snapshot.data es una lista vacía), muestra un mensaje en la interfaz de usuario indicando que no hay líneas disponibles. El widget Text se muestra condicionalmente utilizando un operador ternario, lo que permite mostrarlo solo cuando no se han recibido datos válidos desde la API.
                              return const Center(child: Text('No hay líneas disponibles'));
                            } else {
                              final lines = snapshot.data!;
                              return ListView.builder(
                                itemCount: lines.length,
                                itemBuilder: (context, index) {
                                  final line = lines[index];
                                  return ListTile(
                                    title: Text(line.name),
                                    subtitle: Text(line.description),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],

                    // Ruta
                    if (route != null && route!.steps.isNotEmpty) ...[
                      const Text(
                        "Ruta:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...route!.steps.map( // Si hay información de una ruta de transporte calculada (route no es null y la lista de pasos no está vacía), muestra los detalles de la ruta calculada en la interfaz de usuario. Se utiliza el operador de propagación (...) para incluir los widgets dentro del bloque condicional, lo que permite mostrar los detalles de cada paso de la ruta utilizando un ListTile para cada paso, donde se muestra el modo de transporte, el lugar de origen y el lugar de destino del paso.
                        (step) => ListTile(
                          title: Text(step.mode),
                          subtitle: Text("${step.from} → ${step.to}"), // Subtítulo que muestra el lugar de origen y el lugar de destino del paso de la ruta, utilizando un widget de texto (Text) con interpolación de cadenas para mostrar el formato "origen → destino" utilizando los valores obtenidos desde la información de la ruta calculada (step.from y step.to).
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}