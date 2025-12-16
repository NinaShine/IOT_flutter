import 'package:flutter/material.dart';
import '../repositories/questions.dart' as repo;
import '../models/question.dart';

class QuizProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedOption;

  // 🔥 LISTE DES QUESTIONS
  List<Question> get questions => repo.questions;

  // 🔥 GETTERS
  Question get currentQuestion => questions[_currentIndex];
  int get index => _currentIndex;
  int get score => _score;
  bool get answered => _answered;
  int? get selectedOption => _selectedOption;

  bool get isFinished =>
      _currentIndex == questions.length - 1 && _answered;

  int get wrongAnswers => questions.length - _score;

  // 🔥 UTILISATEUR CHOISIT UNE RÉPONSE
  void selectAnswer(int index) {
    if (_answered) return;

    _selectedOption = index;
    _answered = true;

    if (index == currentQuestion.correctIndex) {
      _score++;
    }

    notifyListeners();
  }

  // 🔥 QUESTION SUIVANTE
  void nextQuestion() {
    if (_currentIndex < questions.length - 1) {
      _currentIndex++;
      _answered = false;
      _selectedOption = null;
    } else {
      _answered = true;
    }

    notifyListeners();
  }

  // 🔥 RESET COMPLET
  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _answered = false;
    _selectedOption = null;
    notifyListeners();
  }
}
