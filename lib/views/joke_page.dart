import 'package:flutter/material.dart';
import '../services/joke_service.dart';
import '../models/joke_model.dart';

class JokePage extends StatefulWidget {
 const JokePage({super.key});

 @override
 State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {

 JokeModel? joke;

 void loadJoke() async {
   final newJoke = await JokeService().getRandomJoke();
   setState(() {
     joke = newJoke;
   });
 }

 @override
 void initState() {
   super.initState();
   loadJoke();
 }

 @override
 Widget build(BuildContext context) {

   return Scaffold(
     appBar: AppBar(title: const Text('Chistes API')),
     body: Center(
       child: joke == null
           ? const CircularProgressIndicator()
           : Padding(
               padding: const EdgeInsets.all(20),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(joke!.setup),
                   const SizedBox(height: 20),
                   Text(
                     joke!.punchline,
                     style: const TextStyle(fontWeight: FontWeight.bold),
                   ),
                   const SizedBox(height: 20),
                   ElevatedButton(
                     onPressed: loadJoke,
                     child: const Text('Nuevo chiste'),
                   )
                 ],
               ),
             ),
     ),
   );
 }
}
