import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/books/domain/models/book_language.dart';

const String _languagePrefsKey = 'selected_language';

class LanguageState {
  final BookLanguage selectedLanguage;

  const LanguageState({
    required this.selectedLanguage,
  });

  LanguageState copyWith({
    BookLanguage? selectedLanguage,
  }) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

abstract class LanguageEvent {
  const LanguageEvent();
}

class LanguageChanged extends LanguageEvent {
  final BookLanguage language;

  const LanguageChanged(this.language);
}

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences _prefs;

  LanguageBloc(this._prefs) : super(LanguageState(
    selectedLanguage: _loadInitialLanguage(_prefs),
  )) {
    on<LanguageChanged>((event, emit) {
      _saveLanguage(event.language);
      emit(state.copyWith(selectedLanguage: event.language));
    });
  }

  static BookLanguage _loadInitialLanguage(SharedPreferences prefs) {
    final languageCode = prefs.getString(_languagePrefsKey);
    if (languageCode == null) return BookLanguage.english;
    
    return BookLanguage.values.firstWhere(
      (lang) => lang.code == languageCode,
      orElse: () => BookLanguage.english,
    );
  }

  void _saveLanguage(BookLanguage language) {
    _prefs.setString(_languagePrefsKey, language.code);
  }

  static Future<LanguageBloc> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LanguageBloc(prefs);
  }
}
