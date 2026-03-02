class JokeModel { // Modelo de datos para un chiste
 final String setup; // Parte inicial del chiste
 final String punchline; // Parte final del chiste (remate)

 JokeModel({ 
   required this.setup, // Parte inicial del chiste
   required this.punchline, // Parte final del chiste (remate)
 });

 factory JokeModel.fromJson(Map<String, dynamic> json) { // Crea una instancia de JokeModel a partir de un JSON
   return JokeModel( 
     setup: json['setup'], // Parte inicial del chiste
     punchline: json['punchline'], // Parte final del chiste (remate
   );
 }
}
