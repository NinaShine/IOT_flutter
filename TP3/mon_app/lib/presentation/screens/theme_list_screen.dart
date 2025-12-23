import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/blocs/quiz_bloc.dart';
import '../../business_logic/events/quiz_event.dart';
import '../../business_logic/states/quiz_state.dart';
import 'quiz_screen.dart';

class ThemeListScreen extends StatelessWidget {
  const ThemeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF7F3FF), // lavande très clair
              Color(0xFFF2FAFF), // bleu très clair
              Color(0xFFFFF7F2), // pêche très clair
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.quiz_rounded, color: cs.primary),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TP3 Quiz",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Choisis un thème pour commencer",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: "Rafraîchir",
                      onPressed: () => context
                          .read<QuizBloc>()
                          .add(const QuizThemesRequested()),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<QuizBloc, QuizState>(
                  builder: (context, state) {
                    if (state.status == QuizStatus.loadingThemes ||
                        state.status == QuizStatus.initial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == QuizStatus.failure) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Erreur: ${state.error ?? 'inconnue'}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    if (state.themes.isEmpty) {
                      return const Center(
                        child: Text("Aucun thème trouvé dans Firestore."),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      itemCount: state.themes.length,
                      itemBuilder: (context, i) {
                        final t = state.themes[i];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () {
                              context.read<QuizBloc>().add(QuizStarted(t.id));
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const QuizScreen(),
                                ),
                              );
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                color: cs.surface,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: cs.outlineVariant.withOpacity(0.4),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                    color: Colors.black.withOpacity(0.06),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    _ThemeThumb(
                                      imageUrl: t.imageUrl,
                                      fallbackIcon: Icons.folder_rounded,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            t.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Appuie pour lancer le quiz",
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              color: cs.onSurface
                                                  .withOpacity(0.65),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right_rounded),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeThumb extends StatelessWidget {
  final String? imageUrl;
  final IconData fallbackIcon;

  const _ThemeThumb({required this.imageUrl, required this.fallbackIcon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: cs.primary.withOpacity(0.10),
      ),
      clipBehavior: Clip.antiAlias,
      child: (imageUrl != null && imageUrl!.isNotEmpty)
          ? Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(fallbackIcon, color: cs.primary),
      )
          : Icon(fallbackIcon, color: cs.primary),
    );
  }
}
