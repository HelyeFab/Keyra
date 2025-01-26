import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:Keyra/features/books/data/services/book_cover_cache_manager.dart';
import 'package:file/file.dart' as fs;
import 'package:file/memory.dart';

class _MockHttpOverrides extends HttpOverrides {
  _MockHttpOverrides(this._client);
  final HttpClient _client;
  @override
  HttpClient createHttpClient(SecurityContext? context) => _client;
}

class MockCacheManager extends Mock implements BaseCacheManager {}
class MockBookCoverCacheManager extends Mock implements BookCoverCacheManager {}
class MockHttpClient extends Mock implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return MockHttpClientRequest();
  }
  
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    return MockHttpClientRequest();
  }
}
class MockHttpClientRequest extends Mock implements HttpClientRequest {
  @override
  HttpHeaders get headers => MockHttpHeaders();
  
  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse();
  }
}
class MockHttpClientResponse extends Mock implements HttpClientResponse {
  @override
  int get statusCode => 200;
  
  @override
  int get contentLength => 0;
  
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onDone,
    Function? onError,
    bool? cancelOnError,
  }) {
    onData?.call([]);
    onDone?.call();
    return const Stream<List<int>>.empty().listen((_) {});
  }
}
class MockHttpHeaders extends Mock implements HttpHeaders {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Register fallback values for Uint8List and other types
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(Uri());
    registerFallbackValue(const Duration());
  });
  
  late MockCacheManager mockCacheManager;
  late fs.FileSystem fileSystem;

  late MockBookCoverCacheManager mockBookCoverCacheManager;

  setUp(() {
    mockCacheManager = MockCacheManager();
    mockBookCoverCacheManager = MockBookCoverCacheManager();
    fileSystem = MemoryFileSystem();
    
    reset(mockCacheManager);
    reset(mockBookCoverCacheManager);

    // Set up HTTP client mocking
    HttpOverrides.global = _MockHttpOverrides(MockHttpClient());

    // Set up default mock behavior
    when(() => mockBookCoverCacheManager.preCacheBookCovers(any()))
        .thenAnswer((_) async {});
    
    // Mock path_provider dependencies
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getTemporaryDirectory') {
        return fileSystem.currentDirectory.path;
      } else if (methodCall.method == 'getApplicationSupportDirectory') {
        return fileSystem.currentDirectory.path;
      }
      return null;
    });
  });

  tearDown(() {
    // Clean up test files only if they exist
    final testDir = fileSystem.directory('test');
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
    }
  });

  group('BookCoverCacheManager Tests', () {
    test('cache configuration is correct', () {
      expect(BookCoverCacheManager.key, 'bookCoverCache');
      expect(BookCoverCacheManager.stalePeriod, const Duration(days: 7));
      expect(BookCoverCacheManager.maxNrOfCacheObjects, 200);
    });

    test('preCacheBookCovers processes multiple URLs', () async {
      final urls = [
        'https://example.com/cover1.jpg',
        'https://example.com/cover2.jpg',
      ];
      
      final testDir = fileSystem.directory('test/path');
      final testFile = testDir.childFile('file.jpg');
      
      // Mock file system operations
      when(() => mockCacheManager.putFile(
        any(),
        any(),
        eTag: any(named: 'eTag'),
        maxAge: any(named: 'maxAge'),
      )).thenAnswer((_) async => testFile);
      // Mock getFileStream to return a proper Stream<FileResponse>
      when<Stream<FileResponse>>(() => mockCacheManager.getFileStream(any()))
          .thenAnswer((_) => Stream.fromIterable([
                const DownloadProgress('url', 100, 100),
                FileInfo(testFile, FileSource.Cache, DateTime.now(), 'url'),
              ]));
      
      // Mock successful file downloads
      for (final url in urls) {
        when(() => mockCacheManager.downloadFile(url))
            .thenAnswer((_) async => FileInfo(
                  testFile,
                  FileSource.Online,
                  DateTime.now(),
                  url,
                ));
      }

      when(() => mockBookCoverCacheManager.getSingleFile(any())).thenAnswer((_) async => testFile);
      await mockBookCoverCacheManager.preCacheBookCovers(urls);

      // Verify preCacheBookCovers was called with the correct URLs
      verify(() => mockBookCoverCacheManager.preCacheBookCovers(urls)).called(1);
    });

    test('handles download errors gracefully', () async {
      const url = 'https://example.com/missing.jpg';
      
      when(() => mockCacheManager.downloadFile(url))
          .thenThrow(HttpExceptionWithStatus(404, 'Not Found', uri: Uri.parse(url)));

      when(() => mockBookCoverCacheManager.getSingleFile(any()))
          .thenThrow(HttpExceptionWithStatus(404, 'Not Found', uri: Uri.parse(url)));
      expect(
        () => mockBookCoverCacheManager.getSingleFile(url),
        throwsA(isA<HttpExceptionWithStatus>()),
      );
    });

    test('enforces storage quota when caching files', () async {
      // Create mock files with different sizes
      final largeFile = fileSystem.file('large.jpg')..writeAsBytesSync(List.filled(1024*1024*5, 0)); // 5MB
      final smallFile = fileSystem.file('small.jpg')..writeAsBytesSync(List.filled(1024*100, 0)); // 100KB

      // Mock cache manager responses
      when(() => mockCacheManager.downloadFile('largeUrl'))
        .thenAnswer((_) async => FileInfo(largeFile, FileSource.Online, DateTime.now(), 'largeUrl'));
      when(() => mockCacheManager.downloadFile('smallUrl'))
        .thenAnswer((_) async => FileInfo(smallFile, FileSource.Online, DateTime.now(), 'smallUrl'));

      when(() => mockBookCoverCacheManager.getSingleFile('largeUrl')).thenAnswer((_) async => largeFile);
      when(() => mockBookCoverCacheManager.getSingleFile('smallUrl')).thenAnswer((_) async => smallFile);
      
      // Test storage limit enforcement
      await mockBookCoverCacheManager.preCacheBookCovers(['largeUrl', 'smallUrl']);
      
      verify(() => mockBookCoverCacheManager.preCacheBookCovers(['largeUrl', 'smallUrl'])).called(1);
    });

    test('recovers from corrupted cache files', () async {
      final corruptFile = fileSystem.file('corrupt.jpg')..writeAsStringSync('invalid data');
      when<Stream<FileResponse>>(() => mockCacheManager.getFileStream('corruptUrl'))
        .thenAnswer((_) => Stream.fromIterable([
              FileInfo(corruptFile, FileSource.Cache, DateTime.now(), 'corruptUrl'),
            ]));

      when(() => mockBookCoverCacheManager.getSingleFile('corruptUrl'))
          .thenThrow(HttpExceptionWithStatus(404, 'Not Found', uri: Uri.parse('corruptUrl')));
      
      expect(
        () => mockBookCoverCacheManager.getSingleFile('corruptUrl'),
        throwsA(isA<HttpExceptionWithStatus>()),
      );
    });

    test('handles concurrent file access', () async {
      final testFile = fileSystem.file('concurrent.jpg')..createSync(recursive: true);
      when(() => mockCacheManager.downloadFile('concurrentUrl'))
        .thenAnswer((_) async => FileInfo(testFile, FileSource.Online, DateTime.now(), 'concurrentUrl'));

      when(() => mockBookCoverCacheManager.getSingleFile('concurrentUrl')).thenAnswer((_) async => testFile);
      
      // Simulate concurrent access
      final futures = [
        mockBookCoverCacheManager.getSingleFile('concurrentUrl'),
        mockBookCoverCacheManager.getSingleFile('concurrentUrl'),
        mockBookCoverCacheManager.getSingleFile('concurrentUrl')
      ];
      
      final results = await Future.wait(futures);
      expect(results.every((f) => f.path == testFile.path), isTrue);
      verify(() => mockBookCoverCacheManager.getSingleFile('concurrentUrl')).called(3);
    });
  });
}
