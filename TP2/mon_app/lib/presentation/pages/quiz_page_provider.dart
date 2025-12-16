import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/quiz_provider.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    // 🔥 ÉCRAN FINAL (RÉCAPITULATIF)
    if (quiz.isFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text("Résultat du Quiz")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Quiz Terminé ! 🎉",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Text(
                "Score : ${quiz.score}/${quiz.questions.length}",
                style: const TextStyle(fontSize: 22),
              ),

              const SizedBox(height: 10),

              Text(
                "Bonnes réponses : ${quiz.score}",
                style: const TextStyle(fontSize: 20, color: Colors.green),
              ),

              Text(
                "Mauvaises réponses : ${quiz.wrongAnswers}",
                style: const TextStyle(fontSize: 20, color: Colors.red),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  quiz.resetQuiz();
                },
                child: const Text("Recommencer"),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Retour à l'accueil"),
              ),
            ],
          ),
        ),
      );
    }

    // 🔥 PAGE DU QUIZ
    final question = quiz.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: Text("Question ${quiz.index + 1}/${quiz.questions.length}"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (question.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  question.image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            Text(
              question.text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Column(
              children: List.generate(question.options.length, (index) {
                final option = question.options[index];
                final isCorrect = index == question.correctIndex;
                final isSelected = index == quiz.selectedOption;

                Color buttonColor = Colors.blue;

                if (quiz.answered) {
                  if (isCorrect) buttonColor = Colors.green;
                  if (isSelected && !isCorrect) buttonColor = Colors.red;
                }

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => quiz.selectAnswer(index),
                    child: Text(option, style: const TextStyle(fontSize: 18)),
                  ),
                );
              }),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: quiz.answered ? quiz.nextQuestion : null,
                child: const Text("Suivant"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
