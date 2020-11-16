import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/saved_suggestions/saved_suggestions.dart';
import 'package:hello_me/saved_suggestions/saved_suggestions_repository.dart';
import 'package:provider/provider.dart';
import 'app_snapping_sheet.dart';
import 'authentication/login.dart';
import 'authentication/user_repository.dart';

class RandomWords extends StatefulWidget {

  RandomWords({
    Key key
  }) : super(key: key);

  @override
  State createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);
  final List<WordPair> _suggestions = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);
    final suggestionsRepository = Provider.of<SavedSuggestionsRepository>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Startup Name Generator'),
          actions: [
            IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
            userRepository.status == Status.Authenticated
                ? IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async {
                    setState(() {
                      userRepository.signOut();
                    });
                  },
                )
                : IconButton(
                  icon: Icon(Icons.login),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => Login()
                        )
                    );
                  }
                )
          ],
        ),
        body: Builder(
          builder: (context) => AppSnappingSheet(child: _buildSuggestions(suggestionsRepository), scaffoldContext: context,),
        )
    );
  }

  Widget _buildSuggestions(SavedSuggestionsRepository savedSuggestionsRepository) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }

        final int index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index], savedSuggestionsRepository);
      },
    );
  }

  Widget _buildRow(WordPair pair, SavedSuggestionsRepository savedSuggestionsRepository) {
    final alreadySaved = savedSuggestionsRepository.saved?.contains(pair) ?? false;
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        if (alreadySaved) {
          savedSuggestionsRepository.removePair(pair);
        } else {
          savedSuggestionsRepository.addPair(pair);
        }
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => SavedSuggestions()
      ),
    );
  }
}