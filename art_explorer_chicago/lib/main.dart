import 'package:flutter/material.dart';

import 'screens/home_shell.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget for the Art Explorer Chicago app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Explorer Chicago',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}
