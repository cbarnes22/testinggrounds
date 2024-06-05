import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Project',
      theme: ThemeData(
          //primarySwatch: Colors.deepPurple,
          ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark, // Use dark mode
      home: const HomeScreen(),
    );
  }
}
