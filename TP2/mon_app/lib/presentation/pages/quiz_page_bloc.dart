import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/blocs/quiz_bloc.dart';
import '../../business_logic/blocs/quiz_event.dart';
import '../../business_logic/blocs/quiz_state.dart';

class QuizPageBloc extends StatelessWidget {
  const QuizPageBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        final bloc = context.read<QuizBloc>();

        if (state.isFinished) {
          return Scaffold(
            appBar: AppBar(title: const Text("Résultat")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Quiz terminé ! 🎉",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text("Score : ${state.score}/${state.questions.length}",
                      style: const TextStyle(fontSize: 22)),
                  Text("Bonnes réponses : ${state.score}",
                      style: const TextStyle(fontSize: 20, color: Colors.green)),
                  Text("Mauvaises réponses : ${state.wrongAnswers}",
                      style: const TextStyle(fontSize: 20, color: Colors.red)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => bloc.add(ResetQuizEvent()),
                    child: const Text("Recommencer"),
                  ),
                ],
              ),
            ),
          );
        }

        final question = state.questions[state.index];

        return Scaffold(
          appBar: AppBar(
            title:
            Text("Question ${state.index + 1}/${state.questions.length}"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(question.image, height: 180),

                const SizedBox(height: 20),

                Text(question.text,
                    style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                const SizedBox(height: 20),

                Column(
                  children: List.generate(question.options.length, (index) {
                    final option = question.options[index];
                    final isCorrect = index == question.correctIndex;
                    final isSelected = index == state.selectedOption;

                    Color color = Colors.blue;
                    if (state.answered) {
                      if (isCorrect) color = Colors.green;
                      if (isSelected && !isCorrect) color = Colors.red;
                    }

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: color),
                        onPressed: () =>
                            bloc.add(SelectAnswerEvent(index)),
                        child: Text(option),
                      ),
                    );
                  }),
                ),

                const Spacer(),

                ElevatedButton(
                  onPressed: state.answered
                      ? () => bloc.add(NextQuestionEvent())
                      : null,
                  child: const Text("Suivant"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
