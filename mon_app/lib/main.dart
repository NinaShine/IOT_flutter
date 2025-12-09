import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,   // Enlève le bandeau "debug"
      title: 'TP1 flutter',
      theme: ThemeData(                    // Thème général de l’app
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),           // Page de démarrage
    );
  }
}
