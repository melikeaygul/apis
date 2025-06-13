import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DogBreedsScreen());
  }
}

class DogBreedsScreen extends StatelessWidget {
  const DogBreedsScreen({super.key});

  final String jsonString = '''
  {
    "message": {
      "affenpinscher": [],
      "african": [],
      "airedale": [],
      "akita": [],
      "australian": ["kelpie", "shepherd"],
      "bakharwal": ["indian"]
    },
    "status": "success"
  }
  ''';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final Map<String, dynamic> breeds = data["message"];

    final String status = data["status"];
    final String firstBreed = breeds.keys.first;
    final String australianSubBreeds = breeds["australian"].join(", ");

    return Scaffold(
      appBar: AppBar(title: const Text("Dog Breeds")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: $status", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              "Erste Rasse: $firstBreed",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Australian Unterrassen: $australianSubBreeds",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
