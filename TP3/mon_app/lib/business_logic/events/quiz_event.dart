import 'package:equatable/equatable.dart';

class QuizThemesRequested extends Equatable {
  const QuizThemesRequested();
  @override
  List<Object?> get props => [];
}

class QuizStarted extends Equatable {
  final String themeId;
  const QuizStarted(this.themeId);

  @override
  List<Object?> get props => [themeId];
}

class QuizAnswerSelected extends Equatable {
  final int selectedIndex;
  const QuizAnswerSelected(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}

class QuizNextQuestion extends Equatable {
  const QuizNextQuestion();
  @override
  List<Object?> get props => [];
}

class QuizRestart extends Equatable {
  const QuizRestart();
  @override
  List<Object?> get props => [];
}
