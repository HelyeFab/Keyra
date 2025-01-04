import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/presentation/bloc/language_bloc.dart';
import '../../../../core/widgets/reading_language_selector.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/mini_stats_display.dart';
import '../../../../core/widgets/menu_button.dart';
import '../../../books/domain/models/book.dart';
import '../../../books/presentation/widgets/book_card.dart';
import '../../../books/presentation/pages/book_reader_page.dart';
import '../../../books/data/repositories/book_repository.dart';
import '../../../dashboard/data/repositories/user_stats_repository.dart';
import '../../../dictionary/data/services/dictionary_service.dart';
import '../../../../core/ui_language/service/ui_translation_service.dart';
import '../../../badges/presentation/widgets/badge_display.dart';
import '../../../badges/presentation/bloc/badge_bloc.dart';
import '../../../badges/presentation/bloc/badge_state.dart';
import '../../../badges/presentation/bloc/badge_event.dart';
import '../../../books/data/services/book_cover_cache_manager.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late TextEditingController _searchController;
  BookRepository? _bookRepository;
  late UserStatsRepository _userStatsRepository;
  late DictionaryService _dictionaryService;
  late List<Book> _filteredBooks;
  late List<Book> _allBooks;
  Timer? _debounce;
  late bool _isSearching;
  late bool _isLoading;
  late String _activeFilter;

  @override
  void initState() {
    print('LibraryPage: initState() called');
    super.initState();
    _searchController = TextEditingController();
    _userStatsRepository = UserStatsRepository();
    _dictionaryService = DictionaryService();
    _filteredBooks = [];
    _allBooks = [];
    _debounce = null;
    _isSearching = false;
    _isLoading = true;
    _activeFilter = 'all';
    print('LibraryPage: Calling _initializeRepository()');
    _initializeRepository();
    _searchController.addListener(_onSearchChanged);
    // Initialize badge bloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print('LibraryPage: Initializing BadgeBloc');
        context.read<BadgeBloc>().add(const BadgeEvent.started());
      }
    });
  }

  Future<void> _initializeRepository() async {
    print('Initializing BookRepository...');
    try {
      _bookRepository = await BookRepository.create();
      print('BookRepository initialized successfully');
      if (mounted) {
        print('Loading books...');
        _loadBooks();
      }
    } catch (e) {
      print('Error initializing BookRepository: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing library: ${e.toString()}'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _initializeRepository,
            ),
          ),
        );
      }
    }
  }

  void _loadBooks() async {
    if (_bookRepository == null) return;
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    bool isFirstLoad = true;
    
    _bookRepository!.getAllBooks().listen(
      (loadedBooks) async {
        if (!mounted) return;

        // Only pre-cache on first load
        if (isFirstLoad && loadedBooks.isNotEmpty) {
          isFirstLoad = false;
          final coverUrls = loadedBooks.map((book) => book.coverImage).toList();
          try {
            await BookCoverCacheManager.instance.preCacheBookCovers(coverUrls);
          } catch (e) {
            print('LibraryPage: Error pre-caching book covers: $e');
            // Continue even if pre-caching fails
          }
        }

        if (loadedBooks.isEmpty && _allBooks.isNotEmpty) {
          // Keep existing books if we get an empty list (might be offline)
          print('LibraryPage: Keeping existing books as new list is empty');
        } else {
          setState(() {
            _allBooks = loadedBooks;
            _filteredBooks = loadedBooks;
            _isLoading = false;
          });
        }
      },
      onError: (error) {
        print('LibraryPage: Error loading books: $error');
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading books: ${error.toString()}'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadBooks,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(() => _isSearching = true);

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterBooks();
    });
  }

  void _filterBooks() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      var filtered = _allBooks.where((book) {
        final matchesSearch = book
            .getTitle(context.read<LanguageBloc>().state.selectedLanguage)
            .toLowerCase()
            .contains(searchTerm);

        switch (_activeFilter) {
          case 'all':
            return matchesSearch;
          case 'favorites':
            return matchesSearch && book.isFavorite;
          case 'recents':
            return matchesSearch && book.categories.contains('Recents');
          default:
            return matchesSearch && book.categories.contains(_activeFilter);
        }
      }).toList();

      _filteredBooks = filtered;
      _isSearching = false;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _activeFilter = filter;
    });
    _filterBooks();
  }

  void _toggleFavorite(int index) async {
    final book = _filteredBooks[index];
    final bookIndex = _allBooks.indexWhere((b) => b.id == book.id);
    if (bookIndex != -1) {
      final updatedBook = _allBooks[bookIndex].copyWith(
        isFavorite: !_allBooks[bookIndex].isFavorite,
      );

      setState(() {
        _allBooks[bookIndex] = updatedBook;
        _filteredBooks[index] = updatedBook;
      });

      try {
        await _bookRepository?.updateBookFavoriteStatus(updatedBook);
      } catch (e) {
        // Revert on error
        setState(() {
          _allBooks[bookIndex] = book;
          _filteredBooks[index] = book;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating favorite status')),
        );
      }
    }
  }

  void _navigateToBookReader(BuildContext context, Book book) {
    if (_bookRepository == null) {
      print('LibraryPage: BookRepository not initialized');
      return;
    }
    
    final selectedLanguage =
        context.read<LanguageBloc>().state.selectedLanguage;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookReaderPage(
          book: book,
          language: selectedLanguage,
          userStatsRepository: _userStatsRepository,
          dictionaryService: _dictionaryService,
          bookRepository: _bookRepository!,
        ),
      ),
    );
  }

  void _onBookTap(Book book) {
    _navigateToBookReader(context, book);
  }

  Widget _buildFilterChip(String label) {
    final translatedLabel = UiTranslationService.translate(context, 'library_filter_$label');
    bool isSelected = _activeFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        label: Text(translatedLabel),
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
        ),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        selectedColor: Theme.of(context).colorScheme.primary,
        onSelected: (selected) {
          _onFilterChanged(selected ? label : 'all');
        },
      ),
    );
  }

  Widget _buildBookGrid(List<Book> books) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookCard(
          title: book
              .getTitle(context.read<LanguageBloc>().state.selectedLanguage),
          coverImagePath: book.coverImage,
          isFavorite: book.isFavorite,
          onFavoriteTap: () => _toggleFavorite(index),
          onTap: () => _onBookTap(book),
        );
      },
    );
  }

  Widget _buildLanguageSelector() {
    return ReadingLanguageSelector(
      currentLanguage: context.read<LanguageBloc>().state.selectedLanguage,
      onLanguageChanged: (language) {
        if (language != null) {
          context.read<LanguageBloc>().add(
                LanguageChanged(language),
              );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
          return Material(
            type: MaterialType.transparency,
            child: GradientBackground(
              pageIndex: 1,
              child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: BlocBuilder<BadgeBloc, BadgeState>(
                  builder: (context, state) {
                    return state.map(
                      initial: (_) => const SizedBox.shrink(),
                      loaded: (loaded) => BadgeDisplay(
                        level: loaded.progress.currentLevel,
                      ),
                      levelingUp: (levelingUp) => BadgeDisplay(
                        level: levelingUp.progress.currentLevel,
                      ),
                    );
                  },
                ),
              ),
              actions: const [
                MenuButton(),
                SizedBox(width: 16),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MiniStatsDisplay(),
                        Row(
                          children: [
                            _buildLanguageSelector(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: UiTranslationService.translate(context, 'library_search_books'),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _isSearching
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: LoadingIndicator(size: 24),
                                ),
                              )
                            : _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withOpacity(0.3),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Row(
                      children: [
                        _buildFilterChip('all'),
                        _buildFilterChip('favorites'),
                        _buildFilterChip('recents'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _loadBooks();
                      },
                      child: _isLoading
                          ? const Center(
                              child: LoadingIndicator(size: 100),
                            )
                          : _filteredBooks.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.library_books_outlined,
                                        size: 64,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      Text(
                                        UiTranslationService.translate(context, 'library_no_books'),
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      TextButton(
                                        onPressed: _loadBooks,
                                        child: Text(UiTranslationService.translate(context, 'library_retry')),
                                      ),
                                    ],
                                  ),
                                )
                              : _buildBookGrid(_filteredBooks),
                    ),
                  ),
                ],
              ),
            ),
          ],
          )));
      },
    );
  }
}
