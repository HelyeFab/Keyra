import 'dart:io';
import 'package:Keyra/core/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/book.dart';
import '../../domain/models/book_language.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import '../services/book_cache_service.dart';
import 'package:Keyra/features/subscription/data/repositories/subscription_repository.dart';
import 'package:Keyra/features/subscription/domain/entities/subscription_helper.dart';

class BookRepository {
  final BookCacheService _cacheService;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final UserStatsRepository _userStatsRepository;
  final SubscriptionRepository _subscriptionRepository;

  static Future<BookRepository> create({
    BookCacheService? cacheService,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
    UserStatsRepository? userStatsRepository,
    SubscriptionRepository? subscriptionRepository,
  }) async {
    final repo = BookRepository._(
      cacheService: cacheService,
      firestore: firestore,
      storage: storage,
      auth: auth,
      userStatsRepository: userStatsRepository,
      subscriptionRepository: subscriptionRepository,
    );
    await repo._initCacheService();
    return repo;
  }

  BookRepository._({
    BookCacheService? cacheService,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
    UserStatsRepository? userStatsRepository,
    SubscriptionRepository? subscriptionRepository,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _userStatsRepository = userStatsRepository ?? UserStatsRepository(),
        _subscriptionRepository = subscriptionRepository ?? SubscriptionRepository(),
        _cacheService = cacheService ?? BookCacheService();

  Future<void> _initCacheService() async {
    try {
      Logger.log('BookRepository: Initializing cache service...');
      await _cacheService.init();
      Logger.log('BookRepository: Cache service initialized successfully');
    } catch (e, stackTrace) {
      Logger.error('BookRepository: Failed to initialize cache service', error: e, stackTrace: stackTrace);
      // Continue without cache if initialization fails
    }
  }

  bool _isCacheInitialized() {
    try {
      return _cacheService.hasCache;
    } catch (e) {
      Logger.error('BookRepository: Cache not initialized', error: e);
      return false;
    }
  }

  // Get books that are in progress (started but not finished)
  Stream<List<Book>> getInProgressBooks() async* {
    Logger.log('BookRepository: Starting getInProgressBooks');

    try {
      final user = _auth.currentUser;
      if (user == null) {
        Logger.log('BookRepository: No user logged in');
        yield [];
        return;
      }

      // Get user's reading progress
      final userBooksQuery = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .where('isCompleted', isEqualTo: false) // Books that aren't completed
          .orderBy('lastUpdated',
              descending: true); // Most recently updated first

      await for (final userBooksSnapshot in userBooksQuery.snapshots()) {
        Logger.log('BookRepository: Received user books update with ${userBooksSnapshot.docs.length} books');

        if (userBooksSnapshot.docs.isEmpty) {
          Logger.log('BookRepository: No in-progress books found');
          yield [];
          continue;
        }

        // Get current stats to check lastBookId
        final stats = await _userStatsRepository.getUserStats();

        // Get all book IDs that are not completed
        final inProgressBookIds =
            userBooksSnapshot.docs.map((doc) => doc.id).toSet();

        // Get the full book data from the global books collection
        final booksSnapshot = await _firestore
            .collection('books')
            .where(FieldPath.documentId, whereIn: inProgressBookIds.toList())
            .get();

        Logger.log('BookRepository: Fetched ${booksSnapshot.docs.length} books from global collection');

        // Get user's favorites
        Set<String> favoriteBookIds = {};
        try {
          final userFavoritesDoc = await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('favorites')
              .get();
          favoriteBookIds = userFavoritesDoc.docs.map((doc) => doc.id).toSet();
        } catch (e) {
          Logger.error('BookRepository: Failed to fetch favorites', error: e);
        }

        // Merge book data with user progress
        List<Book> inProgressBooks = [];
        for (var bookDoc in booksSnapshot.docs) {
          try {
            // Get the user's progress data for this book
            final userBookDoc = userBooksSnapshot.docs
                .firstWhere((doc) => doc.id == bookDoc.id);

            // Create book with metadata from global collection
            final book = Book.fromMap(bookDoc.data(), docId: bookDoc.id);

            // Add user-specific data
            final userBookData = userBookDoc.data();
            final isFavorite = favoriteBookIds.contains(book.id);

            inProgressBooks.add(book.copyWith(
              currentPage: userBookData['currentPage'] as int? ?? 0,
              lastReadAt: userBookData['lastReadAt'] != null
                  ? (userBookData['lastReadAt'] as Timestamp).toDate()
                  : null,
              currentLanguage: userBookData['currentLanguage'] != null
                  ? BookLanguage.fromCode(
                      userBookData['currentLanguage'] as String)
                  : book.defaultLanguage,
              isFavorite: isFavorite,
            ));
          } catch (e) {
            Logger.error('BookRepository: Failed to process book', error: e);
            continue;
          }
        }

        // Sort by lastUpdated to ensure most recent books appear first
        inProgressBooks.sort((a, b) {
          final aDate = a.lastReadAt ?? a.createdAt;
          final bDate = b.lastReadAt ?? b.createdAt;
          return bDate.compareTo(aDate);
        });

        Logger.log('BookRepository: In-progress books sorted by last update');

        Logger.log('BookRepository: Yielding ${inProgressBooks.length} in-progress books');
        yield inProgressBooks;
      }
    } catch (e) {
      Logger.error('BookRepository: Failed to get in-progress books', error: e);
      yield [];
    }
  }

  // Get recent books
  Stream<List<Book>> getRecentBooks() async* {
    Logger.log('BookRepository: Starting getRecentBooks');

    try {
      await for (final snapshot in _firestore
          .collection('books')
          .where('isRecent', isEqualTo: true)
          .snapshots()) {
        Logger.log('BookRepository: Received ${snapshot.docs.length} recent books');

        final user = _auth.currentUser;
        List<Book> books = [];
        Set<String> favoriteBookIds = {};

        if (user != null) {
          try {
            final userFavoritesDoc = await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('favorites')
                .get();
            favoriteBookIds =
                userFavoritesDoc.docs.map((doc) => doc.id).toSet();
          } catch (e) {
            Logger.error('BookRepository: Failed to fetch favorites', error: e);
          }
        }

        for (var doc in snapshot.docs) {
          try {
            final data = doc.data();
            final createdAt = (data['createdAt'] as Timestamp).toDate();
            final now = DateTime.now();
            final sevenDaysAgo = now.subtract(const Duration(days: 7));
            
            // Check if book should still be recent
            if (createdAt.isBefore(sevenDaysAgo)) {
              Logger.log('BookRepository: Book ${doc.id} is older than 7 days, filtering from UI');
              continue; // Skip this book in the UI since it's no longer recent
            }
            
            final book = Book.fromMap(data, docId: doc.id);
            books.add(book.copyWith(
              isFavorite: favoriteBookIds.contains(book.id),
            ));
          } catch (e) {
            Logger.error('BookRepository: Failed to process recent book', error: e);
            continue;
          }
        }

        yield books;
      }
    } catch (e) {
      Logger.error('BookRepository: Failed to get recent books', error: e);
      yield [];
    }
  }

  // Get all books
  Stream<List<Book>> getAllBooks() async* {
    Logger.log('BookRepository: Starting getAllBooks');

    final user = _auth.currentUser;
    try {
      // Ensure cache service is initialized
      await _initCacheService();

      // First, check and return cached books if available
      if (_isCacheInitialized() && _cacheService.hasCache) {
        final cachedBooks = _cacheService.getCachedBooks();
        Logger.log('BookRepository: Returning ${cachedBooks.length} cached books');

        // Get user's favorites to merge with cached books
        if (user != null) {
          try {
            final userFavoritesDoc = await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('favorites')
                .get();
            final favoriteBookIds =
                userFavoritesDoc.docs.map((doc) => doc.id).toSet();

            // Check and update cached books
            List<Book> updatedCachedBooks = [];
            bool cacheNeedsUpdate = false;

            for (var book in cachedBooks) {
              final now = DateTime.now();
              final sevenDaysAgo = now.subtract(const Duration(days: 7));
              
              if (book.isRecent && book.createdAt.isBefore(sevenDaysAgo)) {
                Logger.log('BookRepository: Cached book ${book.id} is older than 7 days, filtering from UI');
                // Add to cache with updated status for UI only
                updatedCachedBooks.add(book.copyWith(
                  isRecent: false,
                  isFavorite: favoriteBookIds.contains(book.id)
                ));
                cacheNeedsUpdate = true;
              } else {
                updatedCachedBooks.add(book.copyWith(
                  isFavorite: favoriteBookIds.contains(book.id)
                ));
              }
            }

            // Update cache if needed
            if (cacheNeedsUpdate) {
              await _cacheService.cacheBooks(updatedCachedBooks);
            }

            yield updatedCachedBooks;
          } catch (e) {
            Logger.error('BookRepository: Failed to fetch favorites for cached books', error: e);
            yield cachedBooks;
          }
        } else {
          yield cachedBooks;
        }

        // Add delay before starting Firestore stream to allow cached images to load
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      Logger.error('BookRepository: Failed to access cache', error: e);
      // Continue without cache
    }
    Logger.log('BookRepository: User authentication status - ${user != null ? 'Logged in' : 'Not logged in'}');

    try {
      // Listen to Firestore updates
      await for (final snapshot in _firestore.collection('books').snapshots()) {
        Logger.log('BookRepository: Received Firestore update with ${snapshot.docs.length} books');

        List<Book> books = [];
        Set<String> favoriteBookIds = {};

        // If user is logged in, fetch user-specific data
        Map<String, DocumentSnapshot> userBookDocs = {};
        if (user != null) {
          try {
            // Get user's favorites
            final userFavoritesDoc = await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('favorites')
                .get();
            favoriteBookIds =
                userFavoritesDoc.docs.map((doc) => doc.id).toSet();
            Logger.log('BookRepository: Fetched ${favoriteBookIds.length} favorites for user');

            // Get user's reading progress for all books
            final userBooksDoc = await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('books')
                .get();
            userBookDocs = {for (var doc in userBooksDoc.docs) doc.id: doc};
            Logger.log('BookRepository: Fetched reading progress for ${userBookDocs.length} books');
          } catch (e) {
            Logger.error('BookRepository: Failed to fetch user data', error: e);
            // Continue with empty user data
          }
        }

        // Process each book document
        for (var doc in snapshot.docs) {
          try {
            Logger.log('BookRepository: Processing book ${doc.id}');
            final data = doc.data();
            Logger.log('BookRepository: Book data - isRecent: ${data['isRecent']}');
            final book = Book.fromMap(data, docId: doc.id);
            Logger.log('BookRepository: Processed book isRecent: ${book.isRecent}');
            
            // Check if book is older than 7 days
            final createdAt = (data['createdAt'] as Timestamp).toDate();
            final now = DateTime.now();
            final sevenDaysAgo = now.subtract(const Duration(days: 7));
            
            if (book.isRecent && createdAt.isBefore(sevenDaysAgo)) {
              Logger.log('BookRepository: Book ${doc.id} is older than 7 days, filtering from UI');
              data['isRecent'] = false; // Update local data only
            }
            
            final isFavorite = favoriteBookIds.contains(book.id);

            // Get user's reading progress for this book
            final userBookDoc = userBookDocs[doc.id];
            final userData = userBookDoc?.data() as Map<String, dynamic>?;

            // Add to books list with user-specific data
            books.add(book.copyWith(
              currentPage: userData?['currentPage'] as int? ?? 0,
              lastReadAt: userData?['lastReadAt'] != null
                  ? (userData!['lastReadAt'] as Timestamp).toDate()
                  : null,
              currentLanguage: userData?['currentLanguage'] != null
                  ? BookLanguage.fromCode(
                      userData!['currentLanguage'] as String)
                  : book.defaultLanguage,
              isFavorite: isFavorite,
            ));
          } catch (e) {
            Logger.error('BookRepository: Failed to process book', error: e);
            // Continue processing other books
            continue;
          }
        }

        // Update cache with new books
        if (books.isNotEmpty) {
          Logger.log('BookRepository: Caching ${books.length} books');
          await _cacheService.cacheBooks(books);
        }

        // Yield the updated book list
        Logger.log('BookRepository: Yielding ${books.length} books');
        yield books;
      }
    } catch (e) {
      Logger.error('BookRepository: Failed to get all books', error: e);
      // If we have cached books, return them as fallback
      if (_cacheService.hasCache) {
        Logger.log('BookRepository: Returning cached books as fallback');
        yield _cacheService.getCachedBooks();
      } else {
        Logger.log('BookRepository: No cached books available for fallback');
        yield [];
      }
    }
  }

  // Get a single book by ID
  Future<Book?> getBookById(String id) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Get book metadata from global collection
      final bookDoc = await _firestore.collection('books').doc(id).get();
      if (!bookDoc.exists) {
        Logger.log('BookRepository: Book $id not found in global collection');
        return null;
      }

      // Create base book from global data
      final book = Book.fromMap(bookDoc.data()!, docId: id);

      // Get user's reading progress
      final userBookRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .doc(id);

      final userBookDoc = await userBookRef.get();

      // Initialize book progress if it doesn't exist
      if (!userBookDoc.exists) {
        Logger.log('BookRepository: Initializing book progress for $id');
        final initialData = {
          'currentPage': 0,
          'lastReadAt': null,
          'isCompleted': false,
          'currentLanguage': book.defaultLanguage.code,
          'lastUpdated': FieldValue.serverTimestamp(),
        };
        await userBookRef.set(initialData);
      }

      // Get favorite status
      final userFavoriteDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(id)
          .get();

      // Get user book data safely
      final userData = userBookDoc.exists ? userBookDoc.data() : null;
      final currentLanguageCode = userData?['currentLanguage'] as String?;

      // Merge user-specific data
      return book.copyWith(
        currentPage: userData?['currentPage'] as int? ?? 0,
        lastReadAt: userData?['lastReadAt'] != null
            ? (userData!['lastReadAt'] as Timestamp).toDate()
            : null,
        currentLanguage: currentLanguageCode != null
            ? BookLanguage.fromCode(currentLanguageCode)
            : book.defaultLanguage,
        isFavorite: userFavoriteDoc.exists,
      );
    } catch (e) {
      Logger.error('BookRepository: Failed to fetch book', error: e);
      return null;
    }
  }

  // Add a new book
  Future<String> addBook(Book book, File bookFile, File? coverImage) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Upload book file
    final bookRef = _storage.ref('books/${book.id}/${book.title}.pdf');
    await bookRef.putFile(bookFile);
    final bookUrl = await bookRef.getDownloadURL();

    // Upload cover image if provided
    String coverUrl = book.coverImage;
    if (coverImage != null) {
      final coverRef = _storage.ref('covers/${book.id}.jpg');
      await coverRef.putFile(coverImage);
      coverUrl = await coverRef.getDownloadURL();
    }

    // Create book with updated URLs
    final updatedBook = book.copyWith(
      fileUrl: bookUrl,
      coverImage: coverUrl,
    );

    // Only admin can add books to the global collection
    throw Exception('Regular users cannot add new books. Please contact an administrator.');
  }

  // Update a book
  Future<void> updateBook(Book book) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Check if book is being completed
    final isCompleting = book.currentPage >= book.pages.length - 1;
    final wasCompleted = (await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('books')
                .doc(book.id)
                .get())
            .data()?['isCompleted'] ??
        false;

    final userBookData = {
      'currentPage': book.currentPage,
      'lastReadAt':
          book.lastReadAt != null ? Timestamp.fromDate(book.lastReadAt!) : null,
      'isCompleted': isCompleting,
      'currentLanguage': book.currentLanguage.code ?? book.defaultLanguage.code,
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    // Use a transaction to ensure atomic updates
    await _firestore.runTransaction((transaction) async {
      // Update user-specific reading progress first
      final userBookRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .doc(book.id);
      
      transaction.set(userBookRef, userBookData, SetOptions(merge: true));
      Logger.log('BookRepository: User book data saved successfully');

      // Update user stats only if book is completed
      if (isCompleting && !wasCompleted) {
        Logger.log('BookRepository: Book completed, marking as read');
        await _userStatsRepository.markBookAsRead(bookId: book.id);
        
        // Check if we need to show book limit dialog
        final subscription = await _subscriptionRepository.getCurrentSubscription();
        if (subscription != null && !subscription.canReadBooks) {
          throw Exception('BOOK_LIMIT_REACHED');
        }
      }
    }).catchError((error) {
      if (error is Exception && error.toString().contains('BOOK_LIMIT_REACHED')) {
        // Let the UI handle showing the dialog
        throw error;
      }
      Logger.error('BookRepository: Failed to update book', error: error, throwError: true);
      throw Exception('Failed to update book: $error');
    });
  }

  // Update book favorite status
  Future<void> updateBookFavoriteStatus(Book book) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Get fresh ID token to ensure we have valid authentication
    try {
      final idToken = await user.getIdToken(true);
      Logger.log('Got fresh ID token');

      // Verify user is properly authenticated
      Logger.log('User auth state:');
      Logger.log('- UID: ${user.uid}');
      Logger.log('- Email: ${user.email}');
      Logger.log('- Email verified: ${user.emailVerified}');
      Logger.log('- Anonymous: ${user.isAnonymous}');

      final bookDoc = await _firestore.collection('books').doc(book.id).get();
      if (!bookDoc.exists) {
        throw Exception('Book ${book.id} does not exist');
      }
      Logger.log('Book exists: ${book.id}');

      final userRef = _firestore.collection('users').doc(user.uid);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        Logger.log('Creating user document for ${user.uid}');
        await userRef.set({
          'email': user.email,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      Logger.log('User document exists for ${user.uid}');

      final favoriteRef = userRef.collection('favorites').doc(book.id);

      if (book.isFavorite) {
        Logger.log('Adding book ${book.id} to favorites');
        await favoriteRef.set({
          'bookId': book.id,
          'timestamp': FieldValue.serverTimestamp(),
        });
        await _userStatsRepository.incrementFavoriteBooks();
      } else {
        Logger.log('Removing book ${book.id} from favorites');
        await favoriteRef.delete();
        await _userStatsRepository.decrementFavoriteBooks();
      }
      Logger.log('Successfully updated favorite status');
    } catch (e, stackTrace) {
      Logger.error('Failed to update favorite status', error: e, stackTrace: stackTrace, throwError: true);
      throw Exception('Failed to update favorite status: ${e.toString()}');
    }
  }

  // Delete a book
  Future<void> deleteBook(String id) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Delete book file and cover from Storage
    try {
      await _storage.ref('books/$id').delete();
      await _storage.ref('covers/$id.jpg').delete();
    } catch (e) {
      Logger.error('BookRepository: Failed to delete storage files', error: e);
      // Continue with deletion even if storage files don't exist
    }

    // Delete user-specific data
    try {
      await Future.wait([
        // Delete from user's books collection
        _firestore
            .collection('users')
            .doc(user.uid)
            .collection('books')
            .doc(id)
            .delete(),

        // Delete from user's favorites if exists
        _firestore
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(id)
            .delete(),
      ]);
    } catch (e) {
      Logger.error('BookRepository: Failed to delete book documents', error: e, throwError: true);
      throw Exception('Failed to delete book: ${e.toString()}');
    }
  }
}
