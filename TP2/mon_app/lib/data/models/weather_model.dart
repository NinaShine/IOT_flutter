class WeatherModel {
  final String city;
  final String description;
  final double temperature;
  final int humidity;
  final double wind;
  final String icon;

  WeatherModel({
    required this.city,
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.wind,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json["name"],
      description: json["weather"][0]["description"],
      temperature: json["main"]["temp"].toDouble(),
      humidity: json["main"]["humidity"],
      wind: json["wind"]["speed"].toDouble(),
      icon: json["weather"][0]["icon"],
    );
  }
  factory WeatherModel.fromJsonForecast(Map<String, dynamic> json, String city) {
    return WeatherModel(
      city: city,
      description: json["weather"][0]["description"],
      temperature: json["main"]["temp"].toDouble(),
      humidity: json["main"]["humidity"],
      wind: json["wind"]["speed"].toDouble(),
      icon: json["weather"][0]["icon"],
    );
  }
}
