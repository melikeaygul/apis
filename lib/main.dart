import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

class DogBreedsScreen extends StatefulWidget {
  const DogBreedsScreen({super.key});

  @override
  State<DogBreedsScreen> createState() => _DogBreedsScreenState();
}

class _DogBreedsScreenState extends State<DogBreedsScreen> {
  late Future<Map<String, dynamic>> _futureBreeds;

  @override
  void initState() {
    super.initState();
    _futureBreeds = fetchBreeds();
  }

  Future<Map<String, dynamic>> fetchBreeds() async {
    final response = await http.get(
      Uri.parse('https://dog.ceo/api/breeds/list/all'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load breeds');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dog Breeds")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futureBreeds,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              final String status = data["status"];
              final Map<String, dynamic> breeds = data["message"];

              final String firstBreed = breeds.keys.first;
              final String australianSubBreeds = (breeds["australian"] as List)
                  .join(", ");

              return Column(
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
              );
            } else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }
}
