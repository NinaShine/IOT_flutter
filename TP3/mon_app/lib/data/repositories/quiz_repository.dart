import '../models/theme_model.dart';
import '../models/question_model.dart';

abstract class QuizRepository {
  Future<List<ThemeModel>> fetchThemes();
  Future<List<QuestionModel>> fetchQuestions(String themeId);
}
