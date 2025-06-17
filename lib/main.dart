import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DogBreedViewer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DogBreedViewer extends StatefulWidget {
  const DogBreedViewer({super.key});

  @override
  State<DogBreedViewer> createState() => _DogBreedViewerState();
}

class _DogBreedViewerState extends State<DogBreedViewer> {
  Map<String, dynamic>? _breeds;
  String? _currentBreed;
  String? _currentImageUrl;
  final Random _random = Random();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBreeds();
  }

  Future<void> _loadBreeds() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://dog.ceo/api/breeds/list/all'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _breeds = data['message'];
      await _showRandomBreed();
    } else {
      throw Exception('Failed to load breeds');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showRandomBreed() async {
    if (_breeds == null) return;

    setState(() {
      _isLoading = true;
    });

    final breedList = _breeds!.keys.toList();
    final randomIndex = _random.nextInt(breedList.length);
    final breed = breedList[randomIndex];

    final imgResponse = await http.get(
      Uri.parse('https://dog.ceo/api/breed/$breed/images/random'),
    );
    String imageUrl = '';
    if (imgResponse.statusCode == 200) {
      final imgData = jsonDecode(imgResponse.body);
      imageUrl = imgData['message'];
    }

    setState(() {
      _currentBreed = breed;
      _currentImageUrl = imageUrl;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 171, 191),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 148, 199, 247),
        title: const Text("Random Dog Viewer"),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      color: const Color.fromARGB(255, 5, 117, 106),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Lade...",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Icon(Icons.pets, size: 48, color: Colors.teal.shade300),
                ],
              ),
            )
          : _currentBreed == null
          ? const Center(child: Text("Keine Daten geladen"))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentBreed!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    constraints: BoxConstraints(maxHeight: 300, maxWidth: 350),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      _currentImageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return SizedBox(
                          height: 300,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            "Bild konnte nicht geladen werden",
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.teal.shade300,
                    ),
                    onPressed: _showRandomBreed,
                    icon: const Icon(Icons.pets, size: 22),
                    label: const Text(
                      "Nächste Rasse",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
