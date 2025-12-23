class ThemeModel {
  final String id;
  final String title;
  final String? imageUrl;

  const ThemeModel({
    required this.id,
    required this.title,
    this.imageUrl,
  });

  factory ThemeModel.fromMap(String id, Map<String, dynamic> data) {
    return ThemeModel(
      id: id,
      title: (data['title'] ?? '') as String,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'imageUrl': imageUrl,
  };
}
