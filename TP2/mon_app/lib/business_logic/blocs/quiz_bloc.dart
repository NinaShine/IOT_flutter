import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/questions.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizState.initial(questions)) {

    /// Sélection d'une réponse
    on<SelectAnswerEvent>((event, emit) {
      final correct = state.questions[state.index].correctIndex;
      final isCorrect = (event.index == correct);

      emit(state.copyWith(
        answered: true,
        selectedOption: event.index,
        score: state.score + (isCorrect ? 1 : 0),
      ));
    });

    /// Passer à la question suivante
    on<NextQuestionEvent>((event, emit) {
      if (state.index < state.questions.length - 1) {
        emit(state.copyWith(
          index: state.index + 1,
          answered: false,
          selectedOption: null,
        ));
      }
    });

    /// Reset complet
    on<ResetQuizEvent>((event, emit) {
      emit(QuizState.initial(state.questions));
    });
  }
}
