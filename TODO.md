# TechPulse - Implementation Tasks

## Project Overview
**TechPulse** is a cross-platform mobile application (Flutter) for tech content aggregation with offline capabilities and monetization features.

**Architecture:** Clean Architecture + Riverpod  
**Backend:** Node.js + PostgreSQL (Neon)  
**External Services:** Firebase (FCM), Google AdMob

---

## Phase 1: Project Setup

### 1.1 Initialize Flutter Project
- [x] Create Flutter project: `flutter create techpulse`
- [x] Verify Flutter SDK version compatibility

### 1.2 Dependencies (pubspec.yaml)
- [x] `flutter_riverpod` - State management
- [x] `dio` - HTTP client
- [x] `hive` + `hive_flutter` - Local storage
- [x] `cached_network_image` - Image caching
- [x] `flutter_html` - Render HTML content in articles
- [x] `go_router` - Navigation
- [x] `connectivity_plus` - Network status detection
- [x] `url_launcher` - Open affiliate links in browser

### 1.3 Platform Configuration
- [x] **Android** - Internet permission enabled
- [ ] **iOS** - Not configured (MVP)

---

## Phase 2: Core Layer

### 2.1 Constants
- [x] `api_constants.dart` - API base URL, endpoints, timeouts
- [x] `app_constants.dart` - App name, version, pagination limits

### 2.2 Error Handling
- [x] `failures.dart` - Abstract Failure class
- [x] `exceptions.dart` - Custom exceptions

### 2.3 Network Client
- [x] `dio_client.dart` - Dio instance with interceptors
- [ ] `api_interceptor.dart` - Enhanced logging (optional)

### 2.4 Theme
- [x] `app_theme.dart` - Material Design 3 Premium Tech Hub theme
- [x] Color palette: Deep Blue (#1A237E), Vibrant Cyan (#06B6D4), Peach (#FF6B6B)

### 2.5 Utilities
- [x] `extensions.dart` - String, DateTime extensions

---

## Phase 3: Domain Layer

### 3.1 Entities
- [x] `article.dart` - Article entity
- [x] `category.dart` - Category entity
- [x] `search_query.dart` - Search query entity

### 3.2 Repository Interfaces
- [x] `article_repository.dart`
- [x] `category_repository.dart`
- [x] `local_repository.dart`

---

## Phase 4: Data Layer

### 4.1 Models
- [x] `article_model.dart` - JSON serialization
- [x] `category_model.dart` - JSON serialization
- [x] `search_query_model.dart` - JSON serialization

### 4.2 Remote Datasources
- [x] `article_remote_datasource.dart`
- [x] `category_remote_datasource.dart`

### 4.3 Local Datasources
- [x] `favorites_local_datasource.dart` - Hive operations
- [x] `search_history_local_datasource.dart` - Hive operations

### 4.4 Repository Implementations
- [x] `article_repository_impl.dart`
- [x] `category_repository_impl.dart`
- [x] `local_repository_impl.dart`

---

## Phase 5: Presentation Layer

### 5.1 Riverpod Providers
- [x] `repository_providers.dart` - All repository providers
- [x] `article_providers.dart` - Articles, detail, search, category
- [x] `category_providers.dart` - Categories provider
- [x] `favorites_providers.dart` - Favorites with StateNotifier
- [x] `theme_provider.dart` - Light/dark mode toggle

### 5.2 Screens
- [x] `main_screen.dart` - Bottom navigation shell
- [x] `home/home_screen.dart` - Premium hero cards
- [x] `categories/categories_screen.dart` - Glassmorphic grid
- [x] `categories/category_detail_screen.dart` - Articles by category
- [x] `favorites/favorites_screen.dart` - Bookmarked articles
- [x] `settings/settings_screen.dart` - App settings
- [x] `article_detail/article_detail_screen.dart` - SliverAppBar view
- [x] `search/search_screen.dart` - Search interface

### 5.3 Widgets
- [x] `premium_card.dart` - Hero article cards
- [x] `glass_category_tile.dart` - Glassmorphic tiles
- [x] `loading_indicator.dart` - Reusable (using Material)
- [x] `error_widget.dart` - Reusable error display
- [x] `empty_state_widget.dart` - Reusable empty display

---

## Phase 6: Services

### 6.1 Ad Service
- [x] `ad_service.dart` - Ad service with banner & rewarded ads
- [x] `banner_ad_widget.dart` - Banner ad widget
- [x] `rewarded_ad_dialog.dart` - Premium content unlock dialog

### 6.2 Notification Service
- [x] `notification_service.dart` - Notification service (stub ready for FCM)

### 6.3 Connectivity Service
- [x] `connectivity_service.dart` - Network monitoring

---

## Phase 7: Navigation

- [x] `app_router.dart` - GoRouter with all routes:
  - `/` - Home
  - `/categories` - Categories
  - `/categories/:categoryId` - Category detail
  - `/favorites` - Favorites
  - `/settings` - Settings
  - `/article/:id` - Article detail
  - `/search` - Search

---

## Phase 8: Main Application

- [x] `main.dart` - Entry point with ProviderScope, Hive init
- [x] `app.dart` - MaterialApp with theme and router

---

## Phase 9: Error & Empty States

- [x] Network failure - Error widget with retry
- [x] Empty favorites - "No favorites yet"
- [x] Empty search - "No articles found"
- [x] Empty category - "No articles in this category"

---

## Phase 10: Performance & Polish

- [x] Image caching via cached_network_image
- [x] Lazy loading with ListView.builder
- [ ] Minimize rebuilds with `select()`
- [ ] Offline mode - Basic (favorites cached)

---

## Phase 11: Testing

- [ ] Unit tests for repositories
- [ ] Widget tests for key screens

---

## Verification Checklist

- [x] All FR (Functional Requirements) implemented
- [x] All APIs return valid responses
- [x] Favorites persist locally with Hive
- [x] Premium content gating (UI ready)
- [x] No critical crashes
- [x] Material Design 3 compliance
- [x] Bottom navigation with 4 tabs

---

## Build Output

**Debug APK:** `build/app/outputs/flutter-apk/app-debug.apk`

**Backend API:** `techpulse-api/server.js` (Node.js Express on port 3000)

---

## API Endpoints

```
GET /v1/articles           - List articles (paginated)
GET /v1/articles/:id       - Single article
GET /v1/categories        - List categories
GET /v1/categories/:id/articles - Articles by category
GET /v1/search?q=query    - Search articles
```

---

**Last Updated:** 2026-04-12  
**Version:** 1.0  
**Status:** MVP Complete ✅
