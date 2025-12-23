import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {
  final String questionText;
  final String? imageUrl;
  final List<String> choices;
  final int correctIndex;
  final int? selectedIndex;
  final void Function(int index) onChoice;

  const QuestionCard({
    super.key,
    required this.questionText,
    required this.choices,
    required this.correctIndex,
    required this.selectedIndex,
    required this.onChoice,
    this.imageUrl,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int? localSelected;

  @override
  void initState() {
    super.initState();
    localSelected = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.questionText != widget.questionText) {
      localSelected = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final answered = widget.selectedIndex != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _HeaderImage(imageUrl: widget.imageUrl),
            const SizedBox(height: 12),
            Text(
              widget.questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: widget.choices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final label = widget.choices[i];
                  final isSelected = localSelected == i;
                  final isCorrect = i == widget.correctIndex;

                  Color? border;
                  Color? bg;
                  IconData? icon;

                  if (answered) {
                    if (isCorrect) {
                      border = Colors.green.withOpacity(0.55);
                      bg = Colors.green.withOpacity(0.12);
                      icon = Icons.check_circle_rounded;
                    } else if (isSelected && !isCorrect) {
                      border = Colors.red.withOpacity(0.55);
                      bg = Colors.red.withOpacity(0.12);
                      icon = Icons.cancel_rounded;
                    } else {
                      border = cs.outlineVariant.withOpacity(0.35);
                      bg = cs.surface;
                    }
                  } else {
                    border = isSelected
                        ? cs.primary.withOpacity(0.55)
                        : cs.outlineVariant.withOpacity(0.35);
                    bg = isSelected ? cs.primary.withOpacity(0.10) : cs.surface;
                  }

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: answered
                        ? null
                        : () {
                      setState(() => localSelected = i);
                      widget.onChoice(i);
                    },
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cs.primary.withOpacity(0.10),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + i), // A, B, C, D
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (icon != null) Icon(icon),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              answered
                  ? "Appuie sur « Question suivante »"
                  : "Choisis une réponse",
              style: TextStyle(
                fontSize: 12.5,
                color: cs.onSurface.withOpacity(0.65),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  final String? imageUrl;

  const _HeaderImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 170,
        width: double.infinity,
        color: cs.primary.withOpacity(0.08),
        child: hasImage
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(Icons.broken_image_rounded, color: cs.primary),
          ),
        )
            : Center(
          child: Icon(Icons.image_rounded, size: 46, color: cs.primary),
        ),
      ),
    );
  }
}
