import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/saved_suggestions/saved_suggestions_repository.dart';
import 'package:provider/provider.dart';

class SavedSuggestions extends StatefulWidget {
  @override
  State createState() => _SavedSuggestionsState();
}

class _SavedSuggestionsState extends State<SavedSuggestions> {
  @override
  Widget build(BuildContext context) {
    final suggestionsRepository = Provider.of<SavedSuggestionsRepository>(context);

    final tiles = suggestionsRepository.saved.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
                pair.asPascalCase,
                style: TextStyle(fontSize: 18)
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
              onPressed: () async {
                suggestionsRepository.removePair(pair);
              },
            ),
          );
        }
    );

    final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles
    ).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView(children: divided)
    );
  }
}