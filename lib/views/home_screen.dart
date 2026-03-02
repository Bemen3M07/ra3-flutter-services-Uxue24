import 'package:flutter/material.dart';
import '../services/tmb_service.dart';
import '../models/stop_arrival_model.dart';
import '../models/line_model.dart';
import '../models/route_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TmbService _service = TmbService();
  final TextEditingController _controller = TextEditingController();

  StopArrivalModel? stopData;
  RouteModel? route;

  // Para usar FutureBuilder con las líneas:
  Future<List<LineModel>>? futureLines;

  bool isLoading = false;
  String? errorMessage;

  void clearAll() {
    stopData = null;
    route = null;
    errorMessage = null;
    futureLines = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TMB App")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Código de parada",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (_controller.text.isEmpty) return;

                setState(() {
                  isLoading = true;
                  clearAll();
                });

                try {
                  final data = await _service.getStopInfo(_controller.text);
                  setState(() {
                    stopData = data;
                  });
                } catch (e) {
                  setState(() {
                    errorMessage = "Error al obtener la parada";
                  });
                }

                setState(() {
                  isLoading = false;
                });
              },
              child: const Text("Buscar parada"),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  clearAll();
                  futureLines = _service.getBusLines();
                });
              },
              child: const Text("Cargar líneas"),
            ),

            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                  clearAll();
                });

                try {
                  final data = await _service.getRoute(
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

            if (isLoading) const CircularProgressIndicator(),

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Parada
                    if (stopData != null && stopData!.arrivals.isNotEmpty) ...[
                      const Text(
                        "Parada:",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...stopData!.arrivals.map(
                        (bus) => ListTile(
                          title: Text("Línea ${bus.line}"),
                          subtitle: Text(bus.destination),
                          trailing: Text(bus.time),
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                      ...route!.steps.map(
                        (step) => ListTile(
                          title: Text(step.mode),
                          subtitle: Text("${step.from} → ${step.to}"),
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