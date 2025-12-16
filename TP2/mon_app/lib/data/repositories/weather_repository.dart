import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherRepository {
  final String apiKey = "ce0f0f382f4123b5c15bad9080f6ff40";

  Future<WeatherModel?> getWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=fr",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
  Future<List<WeatherModel>> getForecast(String city) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric&lang=fr"
    );

    final response = await http.get(url);

    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    final List list = data["list"];

    // Regrouper par journée (ex : 12h de chaque jour)
    final Map<String, WeatherModel> daily = {};

    for (var item in list) {
      final dateTxt = item["dt_txt"];    // exemple : "2024-12-16 12:00:00"

      if (dateTxt.contains("12:00:00")) {
        daily[dateTxt] = WeatherModel.fromJsonForecast(item, data["city"]["name"]);
      }
    }

    return daily.values.toList();
  }
}
