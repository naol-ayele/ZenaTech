# TechPulse - Project Assessment Summary

## Overview

TechPulse is a full-stack tech news aggregator/magazine application with a **Flutter** frontend, **Node.js/Express** backend, and **PostgreSQL** database. It follows **Clean Architecture** with **Riverpod** for state management. The MVP is functionally complete.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter 3.x (SDK ^3.10.4), Dart |
| **State Management** | Riverpod (flutter_riverpod ^2.4.0, riverpod_annotation ^2.3.0, riverpod_generator ^2.3.0) |
| **HTTP Client** | Dio (^5.4.0) |
| **Navigation** | GoRouter (^13.0.0) |
| **Local Storage** | Hive (^2.2.3) + Hive Flutter (^1.1.0) |
| **Image Caching** | cached_network_image (^3.3.0) |
| **HTML Rendering** | flutter_html (^3.0.0-beta.2) |
| **Ad Monetization** | google_mobile_ads (^3.0.0) |
| **Fonts** | google_fonts (^6.1.0) |
| **URL Launching** | url_launcher (^6.2.2) |
| **Connectivity** | connectivity_plus (^5.0.2) |
| **Code Generation** | build_runner, freezed, json_serializable, hive_generator |
| **Backend** | Node.js + Express (^4.18.2) |
| **Database** | PostgreSQL 15 (via Neon/serverless) |
| **Push Notifications** | Firebase Admin SDK + FCM |
| **Containers** | Docker + docker-compose |
| **Security** | helmet, cors, compression |
| **Logging** | morgan |

---

## Architecture

The app follows **Clean Architecture** with three layers:

### Domain Layer (6 files)
Business logic contracts with no external dependencies:
- **Entities:** Article (with ArticleType enum + AffiliateLink), Category, SearchQuery
- **Repository Interfaces:** ArticleRepository (6 methods), CategoryRepository (1 method), LocalRepository (6 methods)

### Data Layer (10 files)
Implements repository contracts:
- **Models:** ArticleModel, CategoryModel, SearchQueryModel (JSON serializable)
- **Remote Data Sources:** ArticleRemoteDatasource (5 API endpoints), CategoryRemoteDatasource (1 endpoint)
- **Local Data Sources:** FavoritesLocalDatasource (Hive, 4 methods), SearchHistoryLocalDatasource (Hive, 3 methods)
- **Repository Implementations:** ArticleRepositoryImpl, CategoryRepositoryImpl, LocalRepositoryImpl

### Presentation Layer (27 files)
Flutter UI and state management:
- **Providers (7):** Repository, article, category, favorites, search history, theme, ad-supported content providers
- **Screens (10):** MainScreen, HomeScreen, TrendingScreen, ExploreScreen, SearchScreen, FavoritesScreen, SettingsScreen, ArticleDetailScreen, CategoriesScreen, CategoryDetailScreen
- **Widgets (13):** TechPulseNewsCard, PremiumCard, TrendingCard, GlassCategoryTile, BannerAdWidget, NativeAdWidget, RewardedAdDialog, CategoryChipsStrip, CategoryChipsBar, LoadingIndicator, ErrorWidget, EmptyStateWidget, SliverErrorWidget

### Navigation
**GoRouter** with ShellRoute (5-tab bottom nav):
- / ? HomeScreen (landing + latest news)
- /trending ? TrendingScreen (ranked articles)
- /explore ? ExploreScreen (search hub + history)
- /favorites ? FavoritesScreen (bookmarks)
- /settings ? SettingsScreen (theme toggle, about)
- /search ? SearchScreen (full search interface)
- /article/:id ? ArticleDetailScreen (full reader with premium gating)
- /categories ? CategoriesScreen (grid)
- /categories/:categoryId ? CategoryDetailScreen

---

## Features Implemented

### Core Infrastructure
- Flutter project with all dependencies configured
- Dio HTTP client with interceptors (timeout, logging, error handling)
- Material Design 3 theme (light + dark) with custom color palette
- String, DateTime, BuildContext extensions
- Custom Failure/Exception classes (Server, Cache, Network)

### User Interface (10 Screens)
- **MainScreen:** Bottom NavigationBar with 5 destinations
- **HomeScreen:** SliverAppBar, trending strip (horizontal scrollable), category chips, latest news list with ad slots at indices 3 and 7, pull-to-refresh
- **TrendingScreen:** Ranked list with #1 gold/#2 silver/#3 bronze badges, hero cards with gradient overlays, interstitial ads every 4th item
- **ExploreScreen:** Search bar entry point, recent searches as horizontal chips
- **SearchScreen:** Text input with autofocus, search on submit with history saving, results list, empty/error states
- **FavoritesScreen:** Bookmarked articles list with delete per item, empty state
- **SettingsScreen:** Dark mode toggle (Switch), about section (version, developer, privacy policy)
- **ArticleDetailScreen:** SliverAppBar (300px) with hero image + gradient overlay, category badge + reading time + view count, premium content gating (rewarded ad watch), HTML content rendering, affiliate links section, favorite toggle, interstitial ad on back (every 3rd exit)
- **CategoriesScreen:** 2-column glassmorphic grid with icons and article counts
- **CategoryDetailScreen:** Articles filtered by category

### Reusable Widgets (13)
- **TechPulseNewsCard:** 3 layouts (hero/full-bleed, standard/text-left-image-right, compact/image-left-text-right), live badge (animated pulsing dot), view tracking on tap, category chips, time ago
- **PremiumCard:** PremiumArticleCard (hero image with premium badge) + CompactArticleCard (side-by-side)
- **TrendingCard:** Image + gradient overlay, trending badge, compact variant
- **GlassCategoryTile:** Glassmorphic + high-contrast variants, mapped icons (code, phone_android, psychology, security, cloud)
- **BannerAdWidget:** Google AdMob banner with loading/error/loaded states (test ad unit)
- **NativeAdWidget:** "Sponsored" placeholder with shadow container
- **RewardedAdDialog:** Modal dialog for ad-based premium unlock
- **PremiumContentGate:** Inline premium content blocker
- **CategoryChipsStrip/CategoryChipsBar:** Horizontal scrollable filter chips
- **LoadingIndicator:** Centered spinner + shimmer skeleton
- **ErrorWidget:** Generic error + network error (offline-aware) with retry
- **EmptyStateWidget:** Factory constructors (.favorites(), .search(), .articles(), .category())
- **SliverErrorWidget:** Sliver-based error handling

### Services
- **AdService:** Banner + rewarded ad lifecycle (via google_mobile_ads)
- **AdManager:** Singleton managing all ad types with frequency capping (interstitial every 3rd exit)
- **ConnectivityService:** Network status stream, singleton + global instance
- **NotificationService:** FCM-ready stub with initialize/permission/topic methods
- **UserService:** Anonymous ID generation/persistence, category interest tracking

### Ad Monetization (4 formats)
1. **Banner Ads:** Top of home screen, in article lists (every 5th item), trending list (every 4th item)
2. **Interstitial Ads:** On article exit with frequency capping (every 3rd exit)
3. **Rewarded Ads:** Premium content unlock for featured/deep dive articles
4. **Native Ads:** Custom layout (`native_ad_layout.xml`) via `NativeAdFactory` with "Sponsored" branding, rendered at home screen indices 3 and 7

### Backend API (Node.js + Express, 453 lines)
**Middleware:** helmet ? cors ? compression ? morgan ? JSON body parser

**13 Endpoints:**
| Method | Path | Purpose |
|--------|------|---------|
| GET | /health | Health check |
| GET | /v1/articles | Paginated article list |
| GET | /v1/articles/trending | Trending by view count |
| GET | /v1/articles/:id | Single article (increments view) |
| PATCH | /v1/articles/:id/view | Increment view count |
| POST | /v1/articles/:id/like | Like article (anonymous, dedup) |
| GET | /v1/categories | Categories with article counts |
| GET | /v1/categories/:id/articles | Articles by category |
| GET | /v1/search | Full-text search (ILIKE) |
| POST | /v1/users/track-interest | Track category interest |
| POST | /v1/notifications/subscribe | FCM topic subscribe |
| POST | /v1/notifications/unsubscribe | FCM topic unsubscribe |
| POST | /v1/articles | Create article + FCM notification |

### Database (PostgreSQL)
**Tables:** categories, articles (UUID PK), affiliate_links, article_likes, user_interests
**Indexes (9):** Category, published_date, views (desc), premium, anonymous_id, combined
**Sample data:** 5 categories, 5 articles, 2 affiliate links

### Docker
- Dockerfile (Node 20-alpine, production npm install, port 3000)
- docker-compose.yml (API + PostgreSQL 15 with healthcheck, persistent volume, init SQL)

---

## Known Gaps / Incomplete Items

1. **iOS platform not configured** (Android only)
2. **Enhanced API logging interceptor** not implemented (optional)
3. **select() optimization** not applied (unnecessary rebuilds)
4. **Offline mode** limited to cached favorites only
5. **No unit or widget tests** (single placeholder, no mockito)
6. ~~**Native ads** return null (placeholder only)~~ ✅ Fixed
7. **NotificationServiceImpl** is stubbed (real FCM commented out)

---

## Recent Fixes (July 2026)

### 1. Native Ad Custom Factory Restored
- **`ad_manager.dart`:** Replaced `NativeTemplateStyle`/`NativeAdOptions` with `factoryId` pointing to the custom Kotlin `NativeAdFactory`. This fixes duplicate-native-warning and ensures one rendering pipeline.
- **`NativeAdFactory.kt`:** Removed `mediaView?.visibility = View.GONE` so the MediaView is visible when the SDK serves media content.
- Native ads now render correctly at the custom layout's intrinsic size (no "MediaView too small" warning).

### 2. Android Build Environment Fixed
- **NDK:** Overrode broken NDK 28.2.13676358 to 29.0.14206865 in `build.gradle.kts` and `gradle.properties`.
- **CMake:** Upgraded from 3.22.1 to 3.30.5 via SDK Manager; pinned in `local.properties`.
- **Signing:** Fixed keystore path in `key.properties` (`storeFile=upload-keystore.jks` instead of `storeFile=app/upload-keystore.jks`).
- Release APK builds and installs successfully on device.

### 3. Backend Connectivity
- Backend runs in Docker on LAN at `10.58.117.161:3000`.
- Windows Firewall blocks inbound port 3000 (no admin access to create rule).
- Workaround: `adb reverse tcp:3000 tcp:3000` + `http://localhost:3000/v1` for device testing.

## Project Stats

- **Total source files:** ~55 (48 Dart + 7 backend)
- **Estimated lines of code:** ~6,200+
- **MVP status:** Complete
- **Current phase:** Post-MVP optimization/testing
