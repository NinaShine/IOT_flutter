class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  final String image;     // ← l'image de la question

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.image,
  });
}
