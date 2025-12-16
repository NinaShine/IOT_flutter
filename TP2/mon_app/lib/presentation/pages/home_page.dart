import 'package:flutter/material.dart';
import 'package:mon_app/presentation/pages/quiz_page_bloc.dart';
import 'package:mon_app/presentation/pages/weather_page.dart';
import 'quiz_page_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TP2 - Quiz")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WeatherPage()),
            );
          },
          child: const Text("Météo"),
        ),


      ),
    );
  }
}
