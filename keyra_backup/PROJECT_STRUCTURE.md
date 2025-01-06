# Project Structure

## Root Directory Structure
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   └── asset_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── color_schemes.dart
│   │   └── text_themes.dart
│   ├── utils/
│   │   ├── extensions/
│   │   ├── helpers/
│   │   └── validators/
│   └── widgets/
│       ├── buttons/
│       ├── cards/
│       └── dialogs/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│   │   └── application/
│   ├── books/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│   │   └── application/
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│   │   └── application/
│   └── premium/
│       ├── data/
│       ├── domain/
│       ├── presentation/
│       └── application/
├── data/
│   ├── models/
│   │   ├── book/
│   │   ├── user/
│   │   └── subscription/
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── book_repository.dart
│   │   └── user_repository.dart
│   └── services/
│       ├── api/
│       ├── storage/
│       └── analytics/
└── domain/
    ├── entities/
    │   ├── book.dart
    │   ├── user.dart
    │   └── subscription.dart
    └── repositories/
        ├── i_auth_repository.dart
        ├── i_book_repository.dart
        └── i_user_repository.dart

## Feature Structure (Example for books feature)
```
features/books/
├── data/
│   ├── datasources/
│   │   ├── book_remote_datasource.dart
│   │   └── book_local_datasource.dart
│   ├── models/
│   │   └── book_model.dart
│   └── repositories/
│       └── book_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── book.dart
│   ├── repositories/
│   │   └── i_book_repository.dart
│   └── usecases/
│       ├── get_books.dart
│       └── get_book_details.dart
├── presentation/
│   ├── pages/
│   │   ├── book_list_page.dart
│   │   └── book_detail_page.dart
│   ├── widgets/
│   │   ├── book_card.dart
│   │   └── book_grid.dart
│   └── controllers/
│       └── book_controller.dart
└── application/
    └── providers/
        └── book_providers.dart
```

## Key Architecture Decisions

### 1. State Management
- **Riverpod** for state management and dependency injection
- Provider organization by feature
- Separation of UI and business logic

### 2. Navigation
- **go_router** for declarative routing
- Deep linking support
- Nested navigation capability

### 3. Data Layer
- Repository pattern
- Clean separation of concerns
- Interface-driven development
- Proper error handling

### 4. UI Layer
- Material 3 design system
- Reusable widget components
- Responsive design principles
- Accessibility support

### 5. Testing Structure
```
test/
├── unit/
│   ├── features/
│   └── core/
├── widget/
└── integration/
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  # State Management
  flutter_riverpod: ^2.4.9
  
  # Navigation
  go_router: ^12.1.3
  
  # Network
  dio: ^5.4.0
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Code Generation
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  
  # Localization
  easy_localization: ^3.0.3
  
  # Utils
  logger: ^2.0.2+1
  flutter_gen: ^5.3.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  flutter_lints: ^3.0.1
  mockito: ^5.4.3
```
