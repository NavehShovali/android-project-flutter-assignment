import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';

class SavedSuggestionsController {
  static const COLLECTION = 'suggestions';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static SavedSuggestionsController _instance = SavedSuggestionsController._();

  SavedSuggestionsController._();

  factory SavedSuggestionsController.instance() => _instance;

  Future<Set<WordPair>> getSavedSuggestions(String userId) {
    if (userId == null) {
      return Future.value(Set<WordPair>());
    }

    return _firestore.collection(COLLECTION)
        .doc(userId)
        .get()
        .then((doc) => doc.data())
        .then((data) {
          if (data == null || data['suggestions'] == null) {
            return Set<WordPair>();
          }
          return Set<WordPair>.from(data['suggestions'].map((s) => WordPair(s['first'], s['second'])));
        });
  }

  Future<void> setSavedSuggestions(String userId, Set<WordPair> saved) {
    final data = saved.map((pair) => { 'first': pair.first, 'second': pair.second }).toList();
    return _firestore.collection(COLLECTION)
        .doc(userId)
        .set({ 'suggestions': data });
  }
}