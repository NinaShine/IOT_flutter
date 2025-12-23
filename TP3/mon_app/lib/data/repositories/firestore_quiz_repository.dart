import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/theme_model.dart';
import '../models/question_model.dart';
import 'quiz_repository.dart';

class FirestoreQuizRepository implements QuizRepository {
  final FirebaseFirestore _db;

  FirestoreQuizRepository(this._db);

  @override
  Future<List<ThemeModel>> fetchThemes() async {
    final snap = await _db.collection('themes').get();
    return snap.docs
        .map((d) => ThemeModel.fromMap(d.id, d.data()))
        .toList();
  }

  @override
  Future<List<QuestionModel>> fetchQuestions(String themeId) async {
    final snap = await _db
        .collection('themes')
        .doc(themeId)
        .collection('questions')
        .get();

    return snap.docs
        .map((d) => QuestionModel.fromMap(d.id, d.data()))
        .toList();
  }
}
