import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_me/saved_suggestions/saved_suggestions_controller.dart';

class SavedSuggestionsRepository with ChangeNotifier {
  FirebaseAuth _auth;
  Set<WordPair> _saved;
  User _user;
  SavedSuggestionsController _controller = SavedSuggestionsController.instance();

  SavedSuggestionsRepository.instance()
    : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Set<WordPair> get saved => _saved;

  Future<void> addPair(WordPair pair) async {
    _saved.add(pair);

    if (_user != null) {
      await _controller.setSavedSuggestions(_user.uid, _saved);
    }

    notifyListeners();
  }

  Future<void> removePair(WordPair pair) async {
    _saved.remove(pair);

    if (_user != null) {
      await _controller.setSavedSuggestions(_user.uid, _saved);
    }

    notifyListeners();
  }

  Future<void> _onAuthStateChanged(User user) async {
    if (user == null) {
      _saved = new Set<WordPair>();
      _user = null;
    } else {
      _user = user;
      final userSaved = await _controller.getSavedSuggestions(user.uid);
      userSaved.addAll(_saved ?? Set<WordPair>());
      _saved = userSaved;
      await _controller.setSavedSuggestions(user.uid, userSaved);
    }

    notifyListeners();
  }
}