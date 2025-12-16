import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/repositories/weather_repository.dart';
import '../../data/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final repo = WeatherRepository();
  final controller = TextEditingController();

  WeatherModel? weather;
  List<WeatherModel> forecast = [];
  bool loading = false;
  bool error = false;

  Future<void> fetchWeather() async {
    final city = controller.text.trim();
    if (city.isEmpty) return;

    setState(() {
      loading = true;
      error = false;
    });

    final result = await repo.getWeather(city);
    final nextDays = await repo.getForecast(city);

    setState(() {
      weather = result;
      forecast = nextDays;
      loading = false;
      error = (result == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat("EEEE dd MMMM", "fr_FR").format(DateTime.now());

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF74ABE2), Color(0xFF5563DE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Météo"),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Champ de recherche
              TextField(
                controller: controller,
                onSubmitted: (_) => fetchWeather(),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Entrez une ville",
                  labelStyle: const TextStyle(color: Colors.white70),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: fetchWeather,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (loading)
                const CircularProgressIndicator(color: Colors.white),

              if (error)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Ville introuvable ❌",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),

              if (weather != null && !loading) ...[
                const SizedBox(height: 20),

                // --- NOM + DATE ---
                Text(
                  weather!.city,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  today,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 20),

                // --- CARTE MÉTÉO ---
                Card(
                  color: Colors.white.withOpacity(0.15),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Image.network(
                          "https://openweathermap.org/img/wn/${weather!.icon}@4x.png",
                          width: 120,
                        ),

                        Text(
                          "${weather!.temperature}°C",
                          style: const TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          weather!.description.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Icon(FontAwesomeIcons.droplet, color: Colors.white),
                                Text("${weather!.humidity}%",
                                    style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(FontAwesomeIcons.wind, color: Colors.white),
                                Text("${weather!.wind} m/s",
                                    style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ------- PRÉVISIONS SUR 4 JOURS -------
                const Text(
                  "Prévisions",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: forecast.length,
                    itemBuilder: (context, index) {
                      final f = forecast[index];
                      final date = DateFormat("EEE dd", "fr_FR")
                          .format(DateTime.now().add(Duration(days: index + 1)));

                      return Card(
                        color: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: 110,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(date,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Image.network(
                                "https://openweathermap.org/img/wn/${f.icon}.png",
                                width: 50,
                              ),
                              Text(
                                "${f.temperature}°C",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
