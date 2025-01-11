import 'package:flutter/material.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../data/repositories/saved_words_repository.dart';
import '../../domain/models/saved_word.dart';
import 'package:timeago/timeago.dart' as timeago;

class SavedWordsPage extends StatelessWidget {
  final SavedWordsRepository _repository = SavedWordsRepository();

  SavedWordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(UiTranslations.of(context).translate('saved_words_title')),
        ),
        body: StreamBuilder<List<SavedWord>>(
          stream: _repository.getSavedWords(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${UiTranslations.of(context).translate('error_occurred')}: ${snapshot.error}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            }

            final words = snapshot.data ?? [];
            if (words.isEmpty) {
              return Center(
                child: Text(UiTranslations.of(context).translate('no_saved_words_message')),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: words.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final word = words[index];
                return Dismissible(
                  key: Key(word.id),
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _repository.removeWord(word.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(UiTranslations.of(context).translate('word_removed').replaceAll('{0}', word.word)),
                        action: SnackBarAction(
                          label: UiTranslations.of(context).translate('undo'),
                          onPressed: () {
                            _repository.saveWord(word);
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                word.word,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                timeago.format(word.savedAt ?? DateTime.now()),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${UiTranslations.of(context).translate('definition')}: ${word.definition.startsWith('common_definition:') ? UiTranslations.of(context).translate('common_definition') : word.definition}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (word.examples.isNotEmpty ?? false) ...[
                            const SizedBox(height: 8),
                            Text(
                              '${UiTranslations.of(context).translate('examples')}: "${word.examples.first}"',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
