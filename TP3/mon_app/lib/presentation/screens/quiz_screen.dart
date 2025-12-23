import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/blocs/quiz_bloc.dart';
import '../../business_logic/events/quiz_event.dart';
import '../../business_logic/states/quiz_state.dart';
import '../widgets/question_card.dart';
import '../../data/services/sfx_player.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final SfxPlayer _sfx;

  @override
  void initState() {
    super.initState();
    _sfx = SfxPlayer();
  }

  @override
  void dispose() {
    _sfx.dispose();
    super.dispose();
  }

  void _handleChoice(BuildContext context, QuizState state, int choiceIndex) {
    final q = state.currentQuestion;
    if (q == null) return;

    // Empêche de rejouer le son si déjà répondu
    if (state.isAnswered) return;

    final isCorrect = choiceIndex == q.correctIndex;

    // On lance le son (sans await pour ne pas bloquer l’UI)
    if (isCorrect) {
      _sfx.correct();
    } else {
      _sfx.wrong();
    }

    // Ensuite on envoie l'event au BLoC
    context.read<QuizBloc>().add(QuizAnswerSelected(choiceIndex));
  }

  Future<void> _playEndSoundIfNeeded(QuizState state) async {
    final total = state.questions.length;
    final score = state.score;
    final percent = total == 0 ? 0.0 : (score / total);

    // règle victoire: >= 70%
    if (percent >= 0.7) {
      await _sfx.win();
    } else {
      await _sfx.lose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cs.primary.withOpacity(0.18),
              cs.surface,
              cs.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<QuizBloc, QuizState>(
            listenWhen: (prev, curr) =>
            prev.status != QuizStatus.finished &&
                curr.status == QuizStatus.finished,
            listener: (context, state) async {
              // Son win/lose à l'arrivée au résultat
              await _playEndSoundIfNeeded(state);
            },
            child: BlocBuilder<QuizBloc, QuizState>(
              builder: (context, state) {
                if (state.status == QuizStatus.loadingQuiz) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == QuizStatus.failure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text("Erreur: ${state.error ?? 'inconnue'}"),
                    ),
                  );
                }

                // ===================== RESULTAT =====================
                if (state.status == QuizStatus.finished) {
                  final total = state.questions.length;
                  final score = state.score;
                  final percent = total == 0 ? 0.0 : (score / total);

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _TopBar(
                          title: "Résultat",
                          onBack: () => Navigator.of(context).pop(),
                          onRestart: () =>
                              context.read<QuizBloc>().add(const QuizRestart()),
                          showRestart: false, // ✅ pas de recommencer ici
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    percent >= 0.7
                                        ? Icons.emoji_events_rounded
                                        : Icons.insights_rounded,
                                    size: 56,
                                    color: cs.primary,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Score: $score / $total",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: LinearProgressIndicator(
                                      value: percent,
                                      minHeight: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Text(
                                    percent >= 0.7
                                        ? "Excellent 👏"
                                        : "Tu peux faire encore mieux 💪",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: cs.onSurface.withOpacity(0.70),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Retour"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ===================== QUIZ =====================
                final q = state.currentQuestion;
                if (q == null) {
                  return const Center(child: Text("Aucune question chargée."));
                }

                final total = state.questions.length;
                final idx = state.currentIndex + 1;
                final progress = total == 0 ? 0.0 : (idx / total);

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _TopBar(
                        title: "Quiz",
                        subtitle: "Question $idx / $total",
                        onBack: () => Navigator.of(context).pop(),
                        onRestart: () =>
                            context.read<QuizBloc>().add(const QuizRestart()),
                        showRestart: true,
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _Pill(
                            icon: Icons.stars_rounded,
                            text: "Score: ${state.score}",
                          ),
                          const SizedBox(width: 10),
                          _Pill(
                            icon: Icons.timer_rounded,
                            text: state.isAnswered ? "Répondu" : "En cours",
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: QuestionCard(
                          questionText: q.text,
                          imageUrl: q.imageUrl,
                          choices: q.choices,
                          correctIndex: q.correctIndex,
                          selectedIndex: state.selectedIndex,
                          onChoice: (i) => _handleChoice(context, state, i),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(
                            (state.currentIndex + 1 >= state.questions.length)
                                ? Icons.flag_rounded
                                : Icons.arrow_forward_rounded,
                          ),
                          onPressed: state.isAnswered
                              ? () => context
                              .read<QuizBloc>()
                              .add(const QuizNextQuestion())
                              : null,
                          label: Text(
                            (state.currentIndex + 1 >= state.questions.length)
                                ? "Voir résultat"
                                : "Question suivante",
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onBack;
  final VoidCallback onRestart;
  final bool showRestart;

  const _TopBar({
    required this.title,
    required this.onBack,
    required this.onRestart,
    this.subtitle,
    this.showRestart = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.65),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showRestart)
          IconButton(
            tooltip: "Recommencer",
            onPressed: onRestart,
            icon: const Icon(Icons.restart_alt_rounded),
          )
        else
          const SizedBox(width: 48), // garde l’alignement visuel
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Pill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
