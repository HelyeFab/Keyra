import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:Keyra/core/widgets/keyra_page_background.dart';
import 'package:Keyra/features/common/presentation/utils/connectivity_utils.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/core/ui_language/service/ui_translation_service.dart';
import 'package:Keyra/features/badges/presentation/widgets/badges_overview_card.dart';
import 'package:Keyra/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:Keyra/features/dashboard/presentation/pages/study_session_page.dart';
import 'package:Keyra/features/dashboard/presentation/pages/study_words_page.dart';
import 'package:Keyra/features/dashboard/presentation/widgets/circular_stats_card.dart';
import 'package:Keyra/features/dashboard/presentation/widgets/no_saved_words_dialog.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(
        userStatsRepository: UserStatsRepository(),
      ),
      child: const _DashboardPageContent(),
    );
  }
}

class _DashboardPageContent extends StatefulWidget {
  const _DashboardPageContent();

  @override
  State<_DashboardPageContent> createState() => _DashboardPageContentState();
}

class _DashboardContent extends StatelessWidget {
  final int booksRead;
  final int favoriteBooks;
  final int readingStreak;
  final int savedWords;
  final bool isPremium;
  final int? bookLimit;

  const _DashboardContent({
    required this.booksRead,
    required this.favoriteBooks,
    required this.readingStreak,
    required this.savedWords,
    required this.isPremium,
    required this.bookLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Row(
                children: [
                  SizedBox(),
                  SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CircularStatsCard(
                              title: UiTranslationService.translate(
                                context,
                                'books_read',
                              ),
                              value: booksRead,
                              maxValue: 500, // Baron level requirement
                              icon: Icons.book,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Expanded(
                            child: CircularStatsCard(
                              title: UiTranslationService.translate(
                                context,
                                'favorite_books',
                              ),
                              value: favoriteBooks,
                              maxValue: 70, // Baron level requirement
                              icon: Icons.favorite,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CircularStatsCard(
                              title: UiTranslationService.translate(
                                context,
                                'reading_streak',
                              ),
                              value: readingStreak,
                              maxValue: 150, // Baron level requirement
                              icon: Icons.local_fire_department,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 4,
                              color: Theme.of(context).colorScheme.surfaceContainerLowest,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const StudyWordsPage(),
                                        ),
                                      )
                                      .then((_) {
                                    context.read<DashboardBloc>().loadDashboardStats();
                                  });
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.bookmark,
                                            size: 20,
                                            color: Theme.of(context).colorScheme.tertiary,
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              UiTranslationService.translate(
                                                context,
                                                'saved_words',
                                              ),
                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                color: Theme.of(context).colorScheme.onSurface,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.chevron_right,
                                            size: 20,
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        savedWords.toString(),
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 4,
                              color: Theme.of(context).colorScheme.surfaceContainerLowest,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.menu_book,
                                          size: 20,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            UiTranslationService.translate(
                                              context,
                                              'book_limit',
                                            ),
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (isPremium)
                                      Image.asset(
                                        'assets/images/ministats/infinity.png',
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.contain,
                                      )
                                    else
                                      Text(
                                        bookLimit?.toString() ?? '0',
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Column(
                        children: [
                          BadgesOverviewCard(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardPageContentState extends State<_DashboardPageContent> with AutomaticKeepAliveClientMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  bool get wantKeepAlive => true;

  void _dashboardStateListener(BuildContext context, DashboardState state) {
    state.maybeWhen(
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: UiTranslationService.translate(context, 'ok', null, false),
              textColor: Colors.white,
              onPressed: () {
                context.read<DashboardBloc>().loadDashboardStats();
              },
            ),
          ),
        );
      },
      orElse: () {},
    );
  }

  void _startStudySession(BuildContext context, BookLanguage? language) async {
    final savedWordsRepo = context.read<SavedWordsRepository>();
    final words = await savedWordsRepo.getSavedWordsList(
      language: language?.code.toLowerCase(),
    );

    if (!context.mounted) return;

    if (words.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Provider<SavedWordsRepository>.value(
            value: savedWordsRepo,
            child: StudySessionPage(
              words: words,
            ),
          ),
        ),
      );
    } else {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => NoSavedWordsDialog(
          showLanguageSpecific: language != null,
          languageCode: language?.code,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Load stats when page is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final auth = FirebaseAuth.instance;
        if (auth.currentUser != null) {
          if (await ConnectivityUtils.checkConnectivity(context)) {
            context.read<DashboardBloc>().loadDashboardStats();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Material(
      type: MaterialType.transparency,
      child: KeyraPageBackground(
        page: 'dashboard',
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<DashboardBloc, DashboardState>(
                listener: _dashboardStateListener,
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      if (await ConnectivityUtils.checkConnectivity(context)) {
                        context.read<DashboardBloc>().loadDashboardStats();
                      }
                    },
                    child: state.when(
                      initial: () => const Center(child: SizedBox()),
                      loading: () => const Center(child: SizedBox()),
                      loaded: (booksRead, favoriteBooks, readingStreak, savedWords, isPremium, bookLimit) => _DashboardContent(
                        booksRead: booksRead,
                        favoriteBooks: favoriteBooks,
                        readingStreak: readingStreak,
                        savedWords: savedWords,
                        isPremium: isPremium,
                        bookLimit: bookLimit,
                      ),
                      error: (message) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.error,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error: $message',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (await ConnectivityUtils.checkConnectivity(context)) {
                                    context.read<DashboardBloc>().loadDashboardStats();
                                  }
                                },
                                icon: const Icon(Icons.refresh),
                                label: Text(UiTranslationService.translate(context, 'ok')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
