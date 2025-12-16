import 'package:flutter/material.dart';
import '../data/questions.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int questionIndex = 0;
  int? selectedIndex;
  int score = 0;
  List<bool> answers = [];

  // Quand on clique sur une option
  void _selectAnswer(int index) {
    setState(() {
      selectedIndex = index;

      bool isCorrect =
          index == questions[questionIndex].correctIndex;

      answers.add(isCorrect);

      if (isCorrect) score++;
    });
  }

  // Passer à la question suivante
  void _nextQuestion() {
    if (questionIndex < questions.length - 1) {
      setState(() {
        questionIndex++;
        selectedIndex = null;
      });
    } else {
      _showFinalScore();
    }
  }

  // Popup résultat final
  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Résultat final"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Score : $score / ${questions.length}",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            const Text("Récapitulatif :"),
            const SizedBox(height: 10),
            ...answers.asMap().entries.map((entry) {
              int idx = entry.key;
              bool correct = entry.value;
              return Text(
                "Q${idx + 1} : ${correct ? "✔ Correct" : "✘ Faux"}",
                style: TextStyle(
                  fontSize: 16,
                  color: correct ? Colors.green : Colors.red,
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                questionIndex = 0;
                selectedIndex = null;
                score = 0;
                answers.clear();
              });
            },
            child: const Text("Recommencer"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = questions[questionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F1F9),

      appBar: AppBar(
        title: Text("${questionIndex + 1} / ${questions.length}"),
        centerTitle: true,
        backgroundColor: Color(0xFFE5D0FF),      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // IMAGE (style exercice 1, arrondie + ombre)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE5D0FF).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage(current.image),
              ),
            ),

            const SizedBox(height: 25),

            // QUESTION CARD (même style que profile card)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                current.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // OPTIONS
            ...List.generate(current.options.length, (index) {
              final option = current.options[index];

              // Couleurs selon état
              Color bg = Colors.white;

              if (selectedIndex != null) {
                if (index == current.correctIndex) {
                  bg = Colors.green.shade300; // bonne réponse
                } else if (index == selectedIndex) {
                  bg = Colors.red.shade300; // mauvaise réponse
                }
              }

              return GestureDetector(
                onTap: selectedIndex == null
                    ? () => _selectAnswer(index)
                    : null,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // BOUTON NEXT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIndex == null ? null : _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE5D0FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  foregroundColor: Colors.white,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Next", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
