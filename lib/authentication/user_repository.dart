import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseStorage _firebaseStorage;
  User _user;
  Status _status = Status.Uninitialized;

  UserRepository.instance()
    : _auth = FirebaseAuth.instance,
      _firebaseStorage = FirebaseStorage.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;

  User get user => _user;

  Future<bool> signUp(String email, String password) async {
    bool success = false;
    try {
      _status = Status.Authenticating;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      success =  true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
    }

    return success;
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<String> updateAvatar(File file) async {
    if (_status != Status.Authenticated) {
      return Future.value('');
    }

    final ref = _firebaseStorage.ref().child('avatars/${_user.uid}');
    final task = ref.putFile(file);
    await task.whenComplete(() {});
    final url = await ref.getDownloadURL();
    await user.updateProfile(photoURL: url);
    await user.reload();
    notifyListeners();
    return url;
  }

  Future<void> _onAuthStateChanged(User user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _status = Status.Authenticated;
    }

    notifyListeners();
  }
}