import 'package:equatable/equatable.dart';
import '../../data/models/theme_model.dart';
import '../../data/models/question_model.dart';

enum QuizStatus {
  initial,
  loadingThemes,
  themesLoaded,
  loadingQuiz,
  inQuestion,
  finished,
  failure,
}

class QuizState extends Equatable {
  final QuizStatus status;
  final List<ThemeModel> themes;

  final String? activeThemeId;
  final List<QuestionModel> questions;
  final int currentIndex;

  final int? selectedIndex; // réponse choisie pour la question courante
  final int score;
  final String? error;

  const QuizState({
    required this.status,
    this.themes = const [],
    this.activeThemeId,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedIndex,
    this.score = 0,
    this.error,
  });

  QuestionModel? get currentQuestion {
    if (questions.isEmpty) return null;
    if (currentIndex < 0 || currentIndex >= questions.length) return null;
    return questions[currentIndex];
  }

  bool get isAnswered => selectedIndex != null;

  QuizState copyWith({
    QuizStatus? status,
    List<ThemeModel>? themes,
    String? activeThemeId,
    List<QuestionModel>? questions,
    int? currentIndex,
    int? selectedIndex,
    int? score,
    String? error,
  }) {
    return QuizState(
      status: status ?? this.status,
      themes: themes ?? this.themes,
      activeThemeId: activeThemeId ?? this.activeThemeId,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedIndex: selectedIndex,
      score: score ?? this.score,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    themes,
    activeThemeId,
    questions,
    currentIndex,
    selectedIndex,
    score,
    error,
  ];

  static const initialState = QuizState(status: QuizStatus.initial);
}
