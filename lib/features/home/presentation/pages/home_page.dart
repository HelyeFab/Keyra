import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/keyra_scaffold.dart';
import '../../../../core/presentation/bloc/language_bloc.dart';
import '../../../navigation/presentation/pages/navigation_page.dart';
import '../../../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../../core/widgets/reading_language_selector_no_bg.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/mini_stats_display_no_bg.dart';
import '../../../../features/books/domain/models/book.dart';
import '../../../../features/books/presentation/widgets/book_card.dart';
import '../../../../features/books/presentation/pages/book_reader_page.dart';
import '../../../../features/books/data/repositories/book_repository.dart';
import '../../../../features/books/data/repositories/firestore_populator.dart';
import '../../../../features/dashboard/data/repositories/user_stats_repository.dart';
import '../../../../features/dictionary/data/services/dictionary_service.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../../common/presentation/utils/connectivity_utils.dart';
import '../../../../features/badges/presentation/widgets/badge_display.dart';
import '../../../../features/badges/presentation/bloc/badge_bloc.dart';
import '../../../../features/badges/presentation/bloc/badge_state.dart';
import '../../../../features/badges/presentation/bloc/badge_event.dart';
import '../../../common/presentation/widgets/no_internet_dialog.dart';
import '../../../../features/books/data/services/book_cover_cache_manager.dart';
import '../../../subscription/data/repositories/subscription_repository.dart';
import '../../../subscription/domain/entities/subscription_helper.dart';
import '../../../subscription/presentation/widgets/book_limit_dialog.dart';
import '../../../dictionary/data/services/translation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BookRepository? _bookRepository;
  final _userStatsRepository = UserStatsRepository();
  final _dictionaryService = DictionaryService();
  List<Book> _recentBooks = [];
  List<Book> _inProgressBooks = [];
  bool _isLoadingRecent = true;
  bool _isLoadingInProgress = true;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
    // Initialize badge bloc
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BadgeBloc>().add(const BadgeEvent.started());
      }
    });
  }

  Future<void> _initializeRepository() async {
    _bookRepository = await BookRepository.create();
    if (mounted) {
      _loadBooks();
      _loadInProgressBooks();
    }
  }

  void _loadInProgressBooks() {
    setState(() {
      _isLoadingInProgress = true;
    });

    _bookRepository?.getInProgressBooks().listen(
      (books) {
        if (mounted) {
          setState(() {
            _inProgressBooks = books;
            _isLoadingInProgress = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isLoadingInProgress = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(UiTranslations.of(context)
                    .translate('home_error_load_books'))),
          );
        }
      },
    );
  }

  void _loadBooks() async {
    if (!mounted) return;

    setState(() {
      _isLoadingRecent = true;
    });

    try {
      final hasConnectivity =
          await ConnectivityUtils.checkConnectivity(context);
      if (!hasConnectivity) {
        setState(() {
          _isLoadingRecent = false;
        });
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const NoInternetDialog(),
          );
        }
        return;
      }

      if (_bookRepository == null) {
        await _initializeRepository();
        return;
      }

      final populator = FirestorePopulator();
      final exists = await populator.areSampleBooksPopulated();
      if (!exists) {
        await populator.populateWithSampleBooks();
      } else {}

      _bookRepository?.getRecentBooks().listen(
        (loadedBooks) {
          if (loadedBooks.isEmpty) {
            populator.populateWithSampleBooks().then((_) {
              if (mounted) {
                _loadBooks();
              }
            }).catchError((error) {
              if (mounted) {
                setState(() {
                  _isLoadingRecent = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(UiTranslations.of(context)
                          .translate('home_error_load_books'))),
                );
              }
            });
          } else {
            if (mounted) {
              setState(() {
                _recentBooks = loadedBooks;
                _isLoadingRecent = false;
              });
            }
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _isLoadingRecent = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(UiTranslations.of(context)
                      .translate('home_error_load_books'))),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingRecent = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(UiTranslations.of(context)
                  .translate('home_error_load_books'))),
        );
      }
    }
  }

  void _toggleFavorite(int index) async {
    if (!await ConnectivityUtils.checkConnectivity(context)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const NoInternetDialog(),
      );
      return;
    }

    final book = _recentBooks[index];
    final updatedBook = book.copyWith(isFavorite: !book.isFavorite);

    setState(() {
      _recentBooks[index] = updatedBook;
      final inProgressIndex =
          _inProgressBooks.indexWhere((b) => b.id == book.id);
      if (inProgressIndex != -1) {
        _inProgressBooks[inProgressIndex] = updatedBook;
      }
    });

    try {
      await _bookRepository?.updateBookFavoriteStatus(updatedBook);
    } catch (e) {
      setState(() {
        _recentBooks[index] = book;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                UiTranslations.of(context).translate('home_error_favorite'))),
      );
    }
  }

  void _onBookTap(Book book) async {
    if (_bookRepository == null) {
      return;
    }

    try {
      final subscription =
          await SubscriptionRepository().getCurrentSubscription();
      if (subscription == null) return;

      if (subscription.hasReachedBookLimit) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => BookLimitDialog(
            currentBooks: subscription.booksRead,
            bookLimit: subscription.bookLimit,
            nextIncreaseDate: subscription.nextLimitIncrease,
          ),
        );
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
            translationService: context.read<TranslationService>(),
          ),
        ),
      );
    } catch (e) {
      // Allow reading in case of error to prevent blocking users
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
            translationService: context.read<TranslationService>(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (context) => DashboardBloc(
        userStatsRepository: UserStatsRepository(),
      ),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return KeyraScaffold(
            currentIndex: 0,
            onNavigationChanged: (index) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => NavigationPage(initialIndex: index),
                ),
                (route) => false,
              );
            },
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<BadgeBloc, BadgeState>(
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
                            const MiniStatsDisplayNoBg(),
                            ReadingLanguageSelectorNoBg(
                              currentLanguage: languageState.selectedLanguage,
                              onLanguageChanged: (language) {
                                if (language != null) {
                                  context.read<LanguageBloc>().add(
                                        LanguageChanged(language),
                                      );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: AppSpacing.lg),
                              child: Text(
                                UiTranslations.of(context)
                                    .translate('home_recently_added_stories'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            SizedBox(
                              height: 260,
                              child: _isLoadingRecent
                                  ? const Center(
                                      child: LoadingIndicator(size: 100),
                                    )
                                  : _recentBooks.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(AppSpacing.lg),
                                        child: Text(
                                          UiTranslations.of(context).translate('home_no_recent_books'),
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.md),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _recentBooks.length,
                                      itemBuilder: (context, index) {
                                        final book = _recentBooks[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: AppSpacing.md),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              minWidth: 160,
                                              maxWidth: 200,
                                            ),
                                            child: BookCard(
                                              title: book.getTitle(languageState
                                                  .selectedLanguage),
                                              coverImagePath: book.coverImage,
                                              isFavorite: book.isFavorite,
                                              onFavoriteTap: () =>
                                                  _toggleFavorite(index),
                                              onTap: () => _onBookTap(book),
                                              category:
                                                  book.categories.isNotEmpty
                                                      ? book.categories.first
                                                      : null,
                                              totalPages: book.totalPages,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg),
                              child: Text(
                                UiTranslations.of(context)
                                    .translate('home_continue_reading'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _isLoadingInProgress
                                ? const Center(
                                    child: LoadingIndicator(size: 100),
                                  )
                                : _inProgressBooks.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              AppSpacing.lg),
                                          child: Text(
                                            UiTranslations.of(context).translate(
                                                'home_no_in_progress_books'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.7),
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.fromLTRB(
                                            AppSpacing.md,
                                            0,
                                            AppSpacing.md,
                                            120.0),
                                        itemCount: _inProgressBooks.length,
                                        itemBuilder: (context, index) {
                                          final book = _inProgressBooks[index];
                                          return Card(
                                            elevation: 2,
                                            margin: const EdgeInsets.only(
                                                bottom: AppSpacing.md,
                                                left: AppSpacing.sm,
                                                right: AppSpacing.sm),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerLowest,
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: AppSpacing.md,
                                                vertical: AppSpacing.sm,
                                              ),
                                              leading: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppSpacing.radiusSm),
                                                  child: CachedNetworkImage(
                                                    cacheManager:
                                                        BookCoverCacheManager
                                                            .instance,
                                                    imageUrl: book.coverImage,
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                    memCacheWidth: 100,
                                                    memCacheHeight: 100,
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surfaceContainerHighest,
                                                      child: const Center(
                                                        child: LoadingIndicator(
                                                            size: 24),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) {
                                                      return Container(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surfaceContainerHighest,
                                                        child: const Center(
                                                          child: Icon(
                                                              Icons
                                                                  .broken_image_outlined,
                                                              size: 24),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                book.getTitle(languageState
                                                    .selectedLanguage),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                              ),
                                              subtitle: Text(
                                                UiTranslations.of(context)
                                                    .translate(
                                                        'home_page_progress')
                                                    .replaceAll(
                                                        '{0}',
                                                        (book.currentPage + 1)
                                                            .toString())
                                                    .replaceAll(
                                                        '{1}',
                                                        book.pages.length
                                                            .toString()),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withOpacity(0.7),
                                                    ),
                                              ),
                                              trailing: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                              ),
                                              onTap: () => _onBookTap(book),
                                            ),
                                          );
                                        },
                                      ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
