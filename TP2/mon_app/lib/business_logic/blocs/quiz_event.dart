abstract class QuizEvent {}

class SelectAnswerEvent extends QuizEvent {
  final int index;
  SelectAnswerEvent(this.index);
}

class NextQuestionEvent extends QuizEvent {}

class ResetQuizEvent extends QuizEvent {}
