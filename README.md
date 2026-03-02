
ra3-flutter-services-Uxue24-main

modelos

servicios

provider (estado)

vistas

La aplicación incluye tres funcionalidades principales:

Consulta de coches desde una API

Obtención de chistes aleatorios

Consulta de información de transporte (TMB)

Estructura del proyecto
lib/
 ├─ main.dart
 ├─ models/
 ├─ services/
 ├─ providers/
 └─ views/

Además se incluyen las carpetas estándar de Flutter:

android/
web/
test/
main.dart

Archivo de entrada de la aplicación.

Clases
MyApp

Es el widget raíz de la aplicación.

Responsabilidades:

Configurar la app con MaterialApp

Establecer HomeScreen como pantalla principal

models

Contiene los modelos de datos que representan la información recibida desde las APIs.

car_model.dart
Clase: CarModel

Representa un coche.

Propiedades:

make → marca

model → modelo

year → año

Métodos:

CarModel.fromJson(Map<String, dynamic>)

toJson()

joke_model.dart
Clase: JokeModel

Representa un chiste.

Propiedades:

setup → introducción

punchline → remate

Métodos:

JokeModel.fromJson(Map<String, dynamic>)

line_model.dart
Clase: LineModel

Representa una línea de transporte.

Propiedades:

name → nombre de la línea

description → descripción

Métodos:

LineModel.fromJson(Map<String, dynamic>)

route_model.dart
Clase: RouteModel

Representa una ruta de transporte completa.

Propiedades:

steps → lista de pasos de la ruta

Métodos:

RouteModel.fromJson(Map<String, dynamic>)

Este modelo se construye a partir de la estructura plan → itineraries → legs devuelta por la API.

stop_arrival_model.dart
Clase: StopArrivalModel

Representa la información de una parada.

Propiedades:

stopName → nombre de la parada

arrivals → lista de llegadas

Métodos:

StopArrivalModel.fromJson(Map<String, dynamic>)

Clase: BusArrival

Modelo auxiliar que representa una llegada de autobús concreta (se construye dentro del mismo archivo).

services

Contiene todas las clases encargadas de comunicarse con APIs externas.

car_service.dart
Clase: CarService

Responsable de obtener coches desde una API externa (RapidAPI).

Propiedades:

_url

_apiKey

_host

Métodos:

Future<List<CarModel>> getCars()

Convierte la respuesta en una lista de CarModel.

joke_service.dart
Clase: JokeService

Obtiene una lista de chistes desde una API pública y devuelve uno aleatorio.

Métodos:

Future<JokeModel> getRandomJoke()

tmb_service.dart
Clase: TmbService

Servicio que se comunica con la API de TMB.

Propiedades:

_appId

_appKey

Métodos principales:

Future<StopArrivalModel> getStopInfo(String stopCode)

Métodos adicionales para obtener líneas y rutas (según la API de TMB).

Este servicio devuelve datos que luego se transforman en:

StopArrivalModel

LineModel

RouteModel

providers

Contiene la gestión de estado usando Provider.

car_provider.dart
Clase: CarProvider

Extiende ChangeNotifier.

Propiedades privadas:

_cars → lista de coches

_isLoading → indica si se están cargando los datos

Getters:

cars

isLoading

Métodos:

Future<void> fetchCars()

Este método:

Activa el estado de carga

Llama a CarService

Actualiza la lista

Notifica a los widgets

views

Contiene todas las pantallas de la aplicación.

car_page.dart
Clase: CarPage

Pantalla para mostrar la lista de coches.

Características:

Es un StatefulWidget

Usa Provider<CarProvider>

En initState() llama a fetchCars()

Se encarga de:

Mostrar estado de carga

Mostrar la lista de coches

home_screen.dart
Clase: HomeScreen

Pantalla principal de la aplicación.

Responsabilidades:

Introducir un código de parada

Consultar la API de TMB

Mostrar información de:

llegadas a una parada

rutas de transporte

Propiedades principales:

TmbService _service

TextEditingController _controller

StopArrivalModel? stopData

RouteModel? route

joke_page.dart
Clase: JokePage

Pantalla que muestra un chiste aleatorio.

Propiedades:

JokeModel? joke

Métodos:

loadJoke()

Cada vez que se pulsa el botón se llama a JokeService y se actualiza el estado con setState.

test

Contiene pruebas unitarias.

car_service_test.dart

Pruebas relacionadas con el servicio de coches.

widget_test.dart

Prueba básica de widgets generada por Flutter.

Arquitectura del proyecto

El proyecto sigue una arquitectura simple por capas:

Views  →  Provider  →  Services  →  API
           ↓
         Models

Las views no acceden directamente a las APIs.

Los services se encargan únicamente de la comunicación HTTP.

Los models representan los datos.

El provider gestiona el estado de los coches.

Dependencias principales

http → peticiones HTTP

provider → gestión de estado




























[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/urLBeyZM)
# flutter-empty-2026

Plantilla de flux de treball per recrear una estructura neta de projecte Flutter només amb:

- Plataforma Web
- Plataforma Android

Aquest README està pensat perquè puguis reiniciar el repositori a un estat mínim i regenerar els fitxers de plataforma necessaris de manera reproduïble.

Aquest document s'ha fet amb l'ajuda de Copilot

## 1) Prerequisits

- Flutter SDK instal·lat i disponible al PATH
- Comprova la instal·lació de Flutter:

```bash
flutter doctor
```

## 2) Comença des d’un estat net del repositori

Si vols descartar els canvis locals i tornar a l’últim estat confirmat al repositori:

```bash
git reset --hard
git clean -fd
```

## 3) Genera només l’estructura de plataforma Web + Android

Des de l’arrel del projecte:

```bash
flutter create --platforms=web,android .
```

Què fa aquesta comanda:

- Regenera els fitxers d’esquelet de Flutter que faltin
- Crea/actualitza les carpetes de plataforma `web/` i `android/`
- Manté el codi Dart existent de l’app sempre que sigui possible

Opcions disponibles per `--platforms`:

- `android`
- `ios`
- `web`
- `windows`
- `macos`
- `linux`

Exemple amb totes les plataformes:

```bash
flutter create --platforms=android,ios,web,windows,macos,linux .
```

Pots combinar només les que necessitis, separades per comes.

## 4) Comandes de compilació

Compila només l’app web:

```bash
flutter build web
```

Compila l’APK d’Android:

```bash
flutter build apk
```

Android App Bundle opcional (Play Store):

```bash
flutter build appbundle
```

## 5) Comandes d’execució (segons dispositiu)

Fes `flutter run -d <dispositiu>` per executar l’aplicació en un dispositiu concret.

Opcionalment, pots afegir `&` al final de la comanda per executar-la en segon pla.

- `-d` és el mateix que `--device-id`.
- `&` executa la comanda en segon pla (el `run` bloqueja la terminal si no l’afegeixes).
- Serveix per indicar a Flutter en quin dispositiu/target vols executar l’app.
- Exemples: `chrome`, `android`, `ios`, `windows`, `macos`, `linux` (segons les plataformes que tinguis disponibles al teu entorn).

### Chrome

Executa al navegador Chrome:

```bash
flutter run -d chrome
```

L’opció `chrome` es pot executar directament per desenvolupament i proves.
Si vols desplegar la versió web en un servidor, has de generar el build amb `flutter build web` i publicar el contingut de `build/web`.

### Android

Arrenca un emulador Android per línia de comandes (CLI):

```bash
flutter emulators # Per veure tots els emuladors disponibles
flutter emulators --launch <emulator_id>
flutter devices # Per veure tots els dispositius iniciats
flutter run -d <device_id>
```

Exemple:

```bash
flutter emulators --launch Pixel_6_API_34
flutter run -d emulator-5554
```

## 6) Comportament esperat de Git

- Hauries de veure fitxers de codi/configuració dins de `web/` i `android/` versionats a Git.
- No hauries de pujar sortides de compilació generades dins de `build/`.
- No hauries de pujar fitxers locals d’IDE (`.idea/`, `.vscode/`, `*.iml`).

Si cal, mantén aquestes regles a `.gitignore`:

```gitignore
build/
.idea/
.vscode/
*.iml
```

Nota:

- No ignoris tota la carpeta `web/` si web és una plataforma suportada.
- No ignoris tota la carpeta `android/` si Android és una plataforma suportada.

## 7) Checklist ràpid de verificació

Després de regenerar, comprova:

```bash
flutter analyze
flutter test
flutter build web
flutter build apk
```

Si totes les comandes passen, el teu flux de plantilla neta és correcte.





