import 'package:flutter/material.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../../features/books/domain/models/book_language.dart';
import '../../../../features/dictionary/domain/models/saved_word.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';
import '../widgets/word_card.dart';

class StudyWordsPage extends StatefulWidget {
  const StudyWordsPage({super.key});

  @override
  State<StudyWordsPage> createState() => _StudyWordsPageState();
}

class _StudyWordsPageState extends State<StudyWordsPage> {
  final SavedWordsRepository _repository = SavedWordsRepository();
  BookLanguage? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(UiTranslationService.translate(context, 'saved_words_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(UiTranslationService.translate(context, 'select language')),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(UiTranslationService.translate(context, 'all')),
                        onTap: () {
                          setState(() {
                            _selectedLanguage = null;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ...BookLanguage.values.map(
                        (language) => ListTile(
                          leading: Image.asset(
                            language.flagAsset,
                            width: 24,
                            height: 24,
                          ),
                          title: Text(language.displayName),
                          onTap: () {
                            setState(() {
                              _selectedLanguage = language;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<SavedWord>>(
        stream: _repository.getSavedWords(language: _selectedLanguage?.code),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final words = snapshot.data ?? [];
          if (words.isEmpty) {
            return Center(
              child: Text(
                UiTranslationService.translate(
                  context,
                  _selectedLanguage != null 
                    ? 'no_saved_words_language_message'
                    : 'no_saved_words_message'
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: words.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(words[index].id),
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _repository.removeWord(words[index].id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        UiTranslationService.translate(context, 'word deleted'),
                      ),
                    ),
                  );
                },
                child: WordCard(
                  word: words[index],
                  onLanguageSelected: (language) {
                    setState(() {
                      _selectedLanguage = language;
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
