import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/book.dart';
import '../../domain/models/book_language.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import '../services/book_cache_service.dart';

class BookRepository {
  final BookCacheService _cacheService;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final UserStatsRepository _userStatsRepository;

  static Future<BookRepository> create({
    BookCacheService? cacheService,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
    UserStatsRepository? userStatsRepository,
  }) async {
    final repo = BookRepository._(
      cacheService: cacheService,
      firestore: firestore,
      storage: storage,
      auth: auth,
      userStatsRepository: userStatsRepository,
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
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _userStatsRepository = userStatsRepository ?? UserStatsRepository(),
        _cacheService = cacheService ?? BookCacheService();

  Future<void> _initCacheService() async {
    try {
      print('BookRepository: Initializing cache service...');
      await _cacheService.init();
      print('BookRepository: Cache service initialized successfully');
    } catch (e, stackTrace) {
      print('BookRepository: Error initializing cache service: $e');
      print('Stack trace: $stackTrace');
      // Continue without cache if initialization fails
    }
  }

  // Get books that are in progress (started but not finished)
  Stream<List<Book>> getInProgressBooks() async* {
    print('BookRepository: Starting getInProgressBooks');
    
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('BookRepository: No user logged in');
        yield [];
        return;
      }

      // Get user's reading progress
      final userBooksQuery = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .where('isCompleted', isEqualTo: false)  // Books that aren't completed
          .orderBy('lastUpdated', descending: true);  // Most recently updated first

      await for (final userBooksSnapshot in userBooksQuery.snapshots()) {
        print('BookRepository: Received user books update with ${userBooksSnapshot.docs.length} books');
        
        if (userBooksSnapshot.docs.isEmpty) {
          print('BookRepository: No in-progress books found');
          yield [];
          continue;
        }

        // Get current stats to check lastBookId
        final stats = await _userStatsRepository.getUserStats();
        
        // Get all book IDs that are not completed
        final inProgressBookIds = userBooksSnapshot.docs
            .map((doc) => doc.id)
            .toSet();
        
        // Get the full book data from the global books collection
        final booksSnapshot = await _firestore
            .collection('books')
            .where(FieldPath.documentId, whereIn: inProgressBookIds.toList())
            .get();

        print('BookRepository: Fetched ${booksSnapshot.docs.length} books from global collection');

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
          print('BookRepository: Error fetching favorites: $e');
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
                  ? BookLanguage.fromCode(userBookData['currentLanguage'] as String)
                  : book.defaultLanguage,
              isFavorite: isFavorite,
            ));
          } catch (e) {
            print('BookRepository: Error processing book ${bookDoc.id}: $e');
            continue;
          }
        }

        // Sort by lastUpdated to ensure most recent books appear first
        inProgressBooks.sort((a, b) {
          final aDate = a.lastReadAt ?? a.createdAt;
          final bDate = b.lastReadAt ?? b.createdAt;
          return bDate.compareTo(aDate);
        });

        print('BookRepository: In-progress books sorted by last update');

        print('BookRepository: Yielding ${inProgressBooks.length} in-progress books');
        yield inProgressBooks;
      }
    } catch (e) {
      print('BookRepository: Error in getInProgressBooks: $e');
      yield [];
    }
  }

  // Get all books
  Stream<List<Book>> getAllBooks() async* {
    print('BookRepository: Starting getAllBooks');
    
    try {
      // Ensure cache service is initialized
      await _initCacheService();
      
      // First, check and return cached books if available
      if (_cacheService.hasCache) {
        print('BookRepository: Returning cached books');
        yield _cacheService.getCachedBooks();
      }
    } catch (e) {
      print('BookRepository: Error accessing cache: $e');
      // Continue without cache
    }

    final user = _auth.currentUser;
    print('BookRepository: User authentication status - ${user != null ? 'Logged in' : 'Not logged in'}');

    try {
      // Listen to Firestore updates
      await for (final snapshot in _firestore.collection('books').snapshots()) {
        print('BookRepository: Received Firestore update with ${snapshot.docs.length} books');
        
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
            favoriteBookIds = userFavoritesDoc.docs.map((doc) => doc.id).toSet();
            print('BookRepository: Fetched ${favoriteBookIds.length} favorites for user');

            // Get user's reading progress for all books
            final userBooksDoc = await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('books')
                .get();
            userBookDocs = {
              for (var doc in userBooksDoc.docs) doc.id: doc
            };
            print('BookRepository: Fetched reading progress for ${userBookDocs.length} books');
          } catch (e) {
            print('BookRepository: Error fetching user data: $e');
            // Continue with empty user data
          }
        }

        // Process each book document
        for (var doc in snapshot.docs) {
          try {
            print('BookRepository: Processing book ${doc.id}');
            final book = Book.fromMap(doc.data(), docId: doc.id);
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
                  ? BookLanguage.fromCode(userData!['currentLanguage'] as String)
                  : book.defaultLanguage,
              isFavorite: isFavorite,
            ));
          } catch (e) {
            print('BookRepository: Error processing book ${doc.id}: $e');
            // Continue processing other books
            continue;
          }
        }

        // Update cache with new books
        if (books.isNotEmpty) {
          print('BookRepository: Caching ${books.length} books');
          await _cacheService.cacheBooks(books);
        }

        // Yield the updated book list
        print('BookRepository: Yielding ${books.length} books');
        yield books;
      }
    } catch (e) {
      print('BookRepository: Error in getAllBooks: $e');
      // If we have cached books, return them as fallback
      if (_cacheService.hasCache) {
        print('BookRepository: Returning cached books as fallback');
        yield _cacheService.getCachedBooks();
      } else {
        print('BookRepository: No cached books available for fallback');
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
        print('BookRepository: Book $id not found in global collection');
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
        print('BookRepository: Initializing book progress for $id');
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
      print('BookRepository: Error fetching book $id: $e');
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

    // Split data between global and user-specific collections
    final globalBookData = {
      'id': updatedBook.id,
      'title': updatedBook.title,
      'coverImage': updatedBook.coverImage,
      'pages': updatedBook.pages.map((page) => page.toJson()).toList(),
      'defaultLanguage': updatedBook.defaultLanguage.code,
      'author': updatedBook.author,
      'fileUrl': updatedBook.fileUrl,
      'description': updatedBook.description,
      'categories': updatedBook.categories,
      'createdAt': Timestamp.fromDate(updatedBook.createdAt),
    };

    final userBookData = {
      'currentPage': 0,
      'lastReadAt': null,
      'isCompleted': false,
      'currentLanguage': updatedBook.defaultLanguage.code,
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    // Save to Firestore
    final docRef = await _firestore.collection('books').add(globalBookData);
    final bookId = docRef.id;

    // Initialize user's reading progress
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('books')
        .doc(bookId)
        .set(userBookData);

    return bookId;
  }

  // Update a book
  Future<void> updateBook(Book book) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Split the data between global and user-specific collections
    final globalBookData = {
      'id': book.id,
      'title': book.title,
      'coverImage': book.coverImage,
      'pages': book.pages.map((page) => page.toJson()).toList(),
      'defaultLanguage': book.defaultLanguage.code,
      'author': book.author,
      'fileUrl': book.fileUrl,
      'description': book.description,
      'categories': book.categories,
    };

    // Check if book is being completed
    final isCompleting = book.currentPage >= book.pages.length - 1;
    final wasCompleted = (await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('books')
        .doc(book.id)
        .get()).data()?['isCompleted'] ?? false;

    final userBookData = {
      'currentPage': book.currentPage,
      'lastReadAt': book.lastReadAt != null ? Timestamp.fromDate(book.lastReadAt!) : null,
      'isCompleted': isCompleting,
      'currentLanguage': book.currentLanguage.code ?? book.defaultLanguage.code,
      'lastUpdated': FieldValue.serverTimestamp(),
    };

    // Update user stats only if book is completed
    if (isCompleting && !wasCompleted) {
      print('BookRepository: Book completed, marking as read');
      await _userStatsRepository.markBookAsRead();
    }

      print('BookRepository: Saving user book data: $userBookData');
      
      // Update user-specific reading progress first
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('books')
          .doc(book.id)
          .set(userBookData, SetOptions(merge: true));
      
      print('BookRepository: User book data saved successfully');
      
      // Update global book data
      await _firestore.collection('books').doc(book.id).update(globalBookData);
      
      print('BookRepository: Global book data updated successfully');
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
      print('Got fresh ID token');
      
      // Verify user is properly authenticated
      print('User auth state:');
      print('- UID: ${user.uid}');
      print('- Email: ${user.email}');
      print('- Email verified: ${user.emailVerified}');
      print('- Anonymous: ${user.isAnonymous}');
      
      final bookDoc = await _firestore.collection('books').doc(book.id).get();
      if (!bookDoc.exists) {
        throw Exception('Book ${book.id} does not exist');
      }
      print('Book exists: ${book.id}');

      final userRef = _firestore.collection('users').doc(user.uid);
      final userDoc = await userRef.get();
      
      if (!userDoc.exists) {
        print('Creating user document for ${user.uid}');
        await userRef.set({
          'email': user.email,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      print('User document exists for ${user.uid}');

      final favoriteRef = userRef.collection('favorites').doc(book.id);

      if (book.isFavorite) {
        print('Adding book ${book.id} to favorites');
        await favoriteRef.set({
          'bookId': book.id,
          'timestamp': FieldValue.serverTimestamp(),
        });
        await _userStatsRepository.incrementFavoriteBooks();
      } else {
        print('Removing book ${book.id} from favorites');
        await favoriteRef.delete();
        await _userStatsRepository.decrementFavoriteBooks();
      }
      print('Successfully updated favorite status');
    } catch (e, stackTrace) {
      print('Error updating favorite status: $e');
      print('Stack trace: $stackTrace');
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
      print('BookRepository: Error deleting storage files: $e');
      // Continue with deletion even if storage files don't exist
    }

    // Delete from all collections in parallel
    try {
      await Future.wait([
        // Delete from global books collection
        _firestore.collection('books').doc(id).delete(),
        
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
      print('BookRepository: Error deleting book documents: $e');
      throw Exception('Failed to delete book: ${e.toString()}');
    }
  }
}
