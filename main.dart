import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String _dogImageUrl = '';
  String _clock = DateTime.now().toIso8601String();

  @override
  void initState() {
    super.initState();
    _fetchDogImage(); // Fetch the initial dog image when the app starts
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchDogImage(); // Fetch a new dog image every 5 seconds
    });
    Timer.periodic(const Duration(seconds: 0), (timer) {
      setState(() {
        _clock = DateTime.now().toIso8601String();
      });
    });
  }

  Future<void> _fetchDogImage() async {
    try {
      final response =
          await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imageUrl = data['message'];
        setState(() {
          _dogImageUrl = imageUrl;
        });
      } else {
        print('Failed to load dog image: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading dog image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _clock,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Random Dog Image:',
                    style: const TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  _dogImageUrl.isNotEmpty
                      ? Image.network(
                          _dogImageUrl,
                          width: 200, // Adjust the width as needed
                          height: 200, // Adjust the height as needed
                        )
                      : CircularProgressIndicator(), // Show a loading indicator while fetching
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
