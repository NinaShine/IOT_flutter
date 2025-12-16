import '../../data/models/question.dart';

class QuizState {
  final int index;
  final int score;
  final bool answered;
  final int? selectedOption;
  final List<Question> questions;

  bool get isFinished =>
      index == questions.length - 1 && answered;

  int get wrongAnswers => questions.length - score;

  QuizState({
    required this.index,
    required this.score,
    required this.answered,
    required this.selectedOption,
    required this.questions,
  });

  QuizState copyWith({
    int? index,
    int? score,
    bool? answered,
    int? selectedOption,
    List<Question>? questions,
  }) {
    return QuizState(
      index: index ?? this.index,
      score: score ?? this.score,
      answered: answered ?? this.answered,
      selectedOption: selectedOption,
      questions: questions ?? this.questions,
    );
  }

  /// État initial
  factory QuizState.initial(List<Question> questions) {
    return QuizState(
      index: 0,
      score: 0,
      answered: false,
      selectedOption: null,
      questions: questions,
    );
  }
}
