import '../models/question.dart';

final List<Question> questions = [
  Question(
    text: "What is the capital of France?",
    options: ["Berlin", "Madrid", "Paris", "Rome"],
    correctIndex: 2,
    image: "assets/images/france.jpg",
  ),

  Question(
    text: "2 + 2 = ?",
    options: ["3", "4", "22", "5"],
    correctIndex: 1,
    image: "assets/images/math.jpg",
  ),

  Question(
    text: "What color is the sky?",
    options: ["Blue", "Green", "Red", "Yellow"],
    correctIndex: 0,
    image: "assets/images/sky.jpg",
  ),
];
