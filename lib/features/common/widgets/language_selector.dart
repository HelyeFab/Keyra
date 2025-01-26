import 'package:flutter/material.dart';
import '../models/language.dart';

class LanguageSelector extends StatefulWidget {
  final List<Language> languages;
  final Language? selectedLanguage;
  final ValueChanged<Language> onLanguageSelected;
  final bool searchable;

  const LanguageSelector({
    Key? key,
    required this.languages,
    required this.selectedLanguage,
    required this.onLanguageSelected,
    this.searchable = false,
  }) : super(key: key);

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late TextEditingController _searchController;
  late List<Language> _filteredLanguages;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredLanguages = List.from(widget.languages);
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterLanguages(String query) {
    setState(() {
      _filteredLanguages = widget.languages
          .where((language) =>
              language.name.toLowerCase().contains(query.toLowerCase()) ||
              language.code.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.languages.isEmpty) {
      return const Center(
        child: Text('No languages available'),
      );
    }

    return Column(
      children: [
        if (widget.searchable) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search languages',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filterLanguages,
            ),
          ),
        ],
        Expanded(
          child: _filteredLanguages.isEmpty
              ? const Center(
                  child: Text('No languages found'),
                )
              : ListView.builder(
                  itemCount: _filteredLanguages.length,
                  itemBuilder: (context, index) {
                    final language = _filteredLanguages[index];
                    return ListTile(
                      leading: Image.asset(
                        language.flag,
                        width: 32,
                        height: 32,
                      ),
                      title: Text(language.name),
                      selected: widget.selectedLanguage == language,
                      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      onTap: () => widget.onLanguageSelected(language),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
