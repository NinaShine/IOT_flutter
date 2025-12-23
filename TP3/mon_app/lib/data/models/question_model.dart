class QuestionModel {
  final String id;
  final String text;
  final String? imageUrl;
  final List<String> choices;
  final int correctIndex;

  const QuestionModel({
    required this.id,
    required this.text,
    required this.choices,
    required this.correctIndex,
    this.imageUrl,
  });

  factory QuestionModel.fromMap(String id, Map<String, dynamic> data) {
    return QuestionModel(
      id: id,
      text: (data['text'] ?? '') as String,
      imageUrl: data['imageUrl'] as String?,
      choices: List<String>.from(data['choices'] ?? const <String>[]),
      correctIndex: (data['correctIndex'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'text': text,
    'imageUrl': imageUrl,
    'choices': choices,
    'correctIndex': correctIndex,
  };
}
