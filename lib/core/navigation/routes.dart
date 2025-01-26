class Routes {
  static const String home = '/';
  static const String book = '/book';
  static const String study = '/study';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String library = '/library';
  static const String chapter = '/chapter';
  static const String error = '/error';

  // Helper method to build book detail route
  static String bookDetails(String bookId) => '$book/$bookId';

  // Helper method to build chapter route
  static String chapterDetails(String bookId, String chapterId) => 
      '$book/$bookId$chapter/$chapterId';

  // Helper method to extract book ID from route
  static String? extractBookId(String route) {
    final bookRegex = RegExp(r'^\/book\/([^\/]+)');
    final match = bookRegex.firstMatch(route);
    return match?.group(1);
  }

  // Helper method to extract chapter ID from route
  static String? extractChapterId(String route) {
    final chapterRegex = RegExp(r'^\/book\/[^\/]+\/chapter\/([^\/]+)');
    final match = chapterRegex.firstMatch(route);
    return match?.group(1);
  }
}
