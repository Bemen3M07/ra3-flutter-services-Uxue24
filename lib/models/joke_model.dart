class JokeModel {
 final String setup;
 final String punchline;

 JokeModel({
   required this.setup,
   required this.punchline,
 });

 factory JokeModel.fromJson(Map<String, dynamic> json) {
   return JokeModel(
     setup: json['setup'],
     punchline: json['punchline'],
   );
 }
}
