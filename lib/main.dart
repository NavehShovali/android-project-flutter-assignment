import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/authentication/user_repository.dart';
import 'package:hello_me/random_words.dart';
import 'package:hello_me/saved_suggestions/saved_suggestions_repository.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                snapshot.error.toString(),
                textDirection: TextDirection.ltr,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //oke
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRepository>(create: (_) => UserRepository.instance()),
        ChangeNotifierProvider<SavedSuggestionsRepository>(create: (_) => SavedSuggestionsRepository.instance())
      ],
      child: Consumer2<UserRepository, SavedSuggestionsRepository>(
        builder: (context, userRepo, suggestionsRepo, child) {
          return MaterialApp(
              title: 'Startup Name Generator',
              theme: ThemeData(
                  primaryColor: Colors.red
              ),
              home: RandomWords()
          );
        }
      ),
    );
  }
}