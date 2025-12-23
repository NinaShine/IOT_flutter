import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/quiz_repository.dart';
import '../events/quiz_event.dart';
import '../states/quiz_state.dart';

class QuizBloc extends Bloc<Object, QuizState> {
  final QuizRepository _repo;

  QuizBloc(this._repo) : super(QuizState.initialState) {
    on<QuizThemesRequested>(_onThemesRequested);
    on<QuizStarted>(_onQuizStarted);
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizNextQuestion>(_onNextQuestion);
    on<QuizRestart>(_onRestart);
  }

  Future<void> _onThemesRequested(
      QuizThemesRequested event,
      Emitter<QuizState> emit,
      ) async {
    emit(state.copyWith(status: QuizStatus.loadingThemes, error: null));
    try {
      final themes = await _repo.fetchThemes();
      emit(state.copyWith(
        status: QuizStatus.themesLoaded,
        themes: themes,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: QuizStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onQuizStarted(
      QuizStarted event,
      Emitter<QuizState> emit,
      ) async {
    emit(state.copyWith(
      status: QuizStatus.loadingQuiz,
      activeThemeId: event.themeId,
      questions: const [],
      currentIndex: 0,
      selectedIndex: null,
      score: 0,
      error: null,
    ));

    try {
      final questions = await _repo.fetchQuestions(event.themeId);
      if (questions.isEmpty) {
        emit(state.copyWith(
          status: QuizStatus.failure,
          error: "Aucune question trouvée pour ce thème.",
        ));
        return;
      }

      emit(state.copyWith(
        status: QuizStatus.inQuestion,
        questions: questions,
        currentIndex: 0,
        selectedIndex: null,
        score: 0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: QuizStatus.failure,
        error: e.toString(),
      ));
    }
  }

  void _onAnswerSelected(
      QuizAnswerSelected event,
      Emitter<QuizState> emit,
      ) {
    if (state.status != QuizStatus.inQuestion) return;
    if (state.isAnswered) return; // évite double clic

    final q = state.currentQuestion;
    if (q == null) return;

    final isCorrect = event.selectedIndex == q.correctIndex;
    emit(state.copyWith(
      selectedIndex: event.selectedIndex,
      score: state.score + (isCorrect ? 1 : 0),
    ));
  }

  void _onNextQuestion(
      QuizNextQuestion event,
      Emitter<QuizState> emit,
      ) {
    if (state.status != QuizStatus.inQuestion) return;
    if (!state.isAnswered) return;

    final next = state.currentIndex + 1;
    if (next >= state.questions.length) {
      emit(state.copyWith(status: QuizStatus.finished, selectedIndex: null));
    } else {
      emit(state.copyWith(
        currentIndex: next,
        selectedIndex: null,
      ));
    }
  }

  void _onRestart(
      QuizRestart event,
      Emitter<QuizState> emit,
      ) {
    emit(state.copyWith(
      status: QuizStatus.themesLoaded,
      activeThemeId: null,
      questions: const [],
      currentIndex: 0,
      selectedIndex: null,
      score: 0,
      error: null,
    ));
  }
}
