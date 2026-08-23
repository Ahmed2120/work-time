## [2026-08-22] Hardware-Backed Encrypted License & Trial Storage (FlutterSecureStorage)
- **Encrypted Security Layer (`lib/core/utils/secure_storage_helper.dart`)**:
  - Implemented `SecureStorageHelper` utilizing `FlutterSecureStorage` with hardware-backed encryption (`AndroidKeyStore` with `encryptedSharedPreferences: true` and iOS `Keychain`).
  - Migrated sensitive licensing flags (`isExist`, `trial`) from plain unencrypted `SharedPreferences` to secure encrypted storage.
  - Automatically purged plaintext `isExist` and `trial` keys from `SharedPreferences` on app initialization to prevent local XML tampering or bypasses on rooted devices / backup extractors.
- **Licensing & Authentication Flow Integration (`SplashView`, `StartView`, `PurchaseData`, `main.dart`)**:
  - Seamless async validation and encrypted persistence during app startup, trial activation, and email verification.

## [2026-08-19] Workforce Management Enhancements & Weekly Cloud Sync
- **Job Role Filtering (`UserViewModel`, `UserRepository`, `JobFilterDropdown`)**:
  - Implemented dynamic job role extraction from SQLite via `retrieveJobs()`.
  - Added `JobFilterDropdown` in HomeView to filter workers seamlessly by profession alongside salary & status.
- **Weekly Auto Silent Cloud Sync (`BackupViewModel`, `GoogleDriveService`, `BackupView`)**:
  - Implemented silent 7-day cloud sync to Google Drive in the background.
  - Added Auto-Sync toggle switch and last sync date display in `BackupView`.
- **Flexible Overtime Multipliers & Custom Wage (`over_time.dart`, `AppConfig`)**:
  - Added multi-rate overtime support (1.0x, 1.25x, 1.5x, 1.75x, 2.0x) with quick chips.
  - Added modal bottom sheet allowing supervisors to enter custom overtime amounts on the fly.
- **Dynamic Workplace Management (`AttendanceWidget`, `AttendanceRepository`, `AttendanceViewModel`)**:
  - Added auto-suggestion chips for previously used project sites & workshop locations.
  - Made workplace optional with fallback default to support fixed workshops and multi-site contractors alike.

## [2026-08-19] Scheduled Alarm Receivers & Notification Fix
- **Android Manifest Scheduled Receivers (`android/app/src/main/AndroidManifest.xml`)**:
  - Registered `ScheduledNotificationReceiver`, `ScheduledNotificationBootReceiver`, and `ActionBroadcastReceiver` required by `flutter_local_notifications` for AlarmManager intents.
- **Daily Reminder Service Optimization (`lib/core/services/daily_reminder_service.dart`)**:
  - Explicitly created `AndroidNotificationChannel` (`attendance_reminder_channel_v2`) with `Importance.max`.
  - Added `requestExactAlarmsPermission()` for Android 12+ (API 31+).
  - Added `scheduleTestNotificationInSeconds()` helper for test verification.

## [2026-08-18] Android Adaptive Icons & Dedicated Notification Icon Integration
- **Notification Icon Configuration (`@drawable/ic_stat_notification`)**:
  - Integrated monochrome notification icon across all density buckets (`drawable-mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`).
  - Linked `ic_stat_notification` with `AppColors.primaryAmber` accent tint in `DailyReminderService` (`daily_reminder_service.dart`) and `NotificationApi` (`notification_api.dart`).
- **Android Resource Tree Audit**:
  - Verified and confirmed that all files under `android/app/src/main/res/` are required, standard, and zero-redundancy.

## [2026-08-18] New Identity "عُمَّالي | Ommali" & Color Palette (Industrial Amber & Slate Charcoal)
- **Amber & Slate Palette Refactoring (`lib/core/theme/app_colors.dart`, `lib/core/theme/theme.dart`)**:
  - Replaced green/blue tones with **Industrial Amber Rust** (`#EA580C`) and **Deep Slate Charcoal** (`#0F172A` / `#1E293B`).
  - Drawer header updated with a sleek charcoal gradient (`drawerHeaderGradient`) and amber badge.
  - Green (`#10B981`) is now exclusively dedicated to the semantic "حاضر" attendance status.
- **New App Branding "عُمَّالي | Ommali" (`lib/views/home/components/drawer/components/title_drawer.dart`)**:
  - Header updated to "عُمَّالي" with tagline "إدارة حضور وحسابات ويوميات العمال".
  - Generated dedicated app icon logo in warm amber & carbon slate.

## [2026-08-17] Dual Distribution Flavor Engine (Standalone APK vs Google Play Store)
- **Central AppConfig Flavor Control (`lib/core/config/app_config.dart`)**:
  - Implemented `AppFlavor` enum (`apkDirect` vs `playStore`) with compile-time environment override (`--dart-define=FLAVOR=playStore`) and fallback default.
  - Centralized trial thresholds: `maxTrialWorkers` (5), `maxTrialNotes` (5), `maxTrialAttendanceDays` (7).
- **Standalone Freelance APK Mode (`AppFlavor.apkDirect`)**:
  - First launch routes to `StartView` with email license verification against Firebase (`ApiService.getUser`).
  - Removed all hardcoded developer contact details and phone cards from `PurchaseApp` — activation is strictly done via email once the customer pays directly.
  - Full biometric unlock (`LoginView`) persists on subsequent opens once licensed or using trial.
- **Google Play Store Subscription Mode (`AppFlavor.playStore`)**:
  - Automatically begins in Trial mode on first launch without requiring email validation.
  - `PurchaseApp` & `PurchaseDrawer` dynamically display in-app subscription paywalls and Google Play Billing upgrade triggers.

## [2026-08-17] Universal In-Place Worker Search & Filter Decoupling
- **Decoupled Search Logic (`lib/view_models/user_view_model.dart`)**:
  - Implemented isolated search engine operating over `_allUsers` (searching name & job title) without mutating or overwriting the regular `_users` list or active status filter (`statusFilter`).
  - Added `searchQuery`, `isSearching`, `searchResults`, `setSearchQuery`, and `clearSearch`.
- **Search Header & In-Place Results Interface (`lib/views/home/components/custom_appbar.dart`, `lib/views/home/components/users_status_listview.dart`, `lib/views/home/home_view.dart`)**:
  - Modernized `customAppBar` with back-arrow toggle, clear query action button, and search input placeholder.
  - In search mode, `HomeView` presents full-screen search results with worker count (`نتائج البحث (X عامل)`) and live attendance status badge (`حاضر`, `غائب`, `لم يسجل`).
  - On closing or clearing search, the dashboard restores previous filters (`الكل`, `حاضر`, `غائب`, `لم يسجل` & category) seamlessly without reloading or state loss.

## [2026-08-16] Date-Based Saturday-to-Friday Week Grouping & Chronological Sorting
- **Date-Based Saturday-to-Friday Week Engine (`lib/core/utils/global_methods.dart`, `lib/view_models/attendance_view_model.dart`)**:
  - `GlobalMethods.getWeekEnd()` computes the exact closing Friday for any given date in a Saturday→Friday work cycle using `(DateTime.friday - date.weekday + 7) % 7`.
  - `setWeekId` matches calendar periods using year, month, and day comparisons rather than raw string representations.
  - Automatically associates retroactively recorded previous days with their correct chronological week group.
- **Chronological Week & Day Sorting**:
  - `AttendanceViewModel.weekAttendanceMap` sorts days within each week card in ascending order (`todayDate ASC`).
  - `AttendanceViewModel.sortedWeekGroups` sorts week cards by calendar end date (`weekEnd ASC`), ensuring older weeks always precede newer weeks even when inserted out of order.
  - `AttendanceRepository.retrieveWeeks` orders query results by `weekEnd ASC, weekId ASC`.
- **Modernized Attendance Bottom Sheet & Week Components (`lib/views/users/components/slid_bottom_sheet/`)**:
  - `WeekData` and `WeekStatus` accept parsed week groups directly and display date range subheadings (`YYYY-MM-DD — YYYY-MM-DD`).
  - Re-checks week settlement status dynamically (`weekStatus == 1`) across all grouped records.

## [2026-08-16] Dedicated Two-Tier Authentication Flow Redesign
- **Local Biometrics Lock Screen (`lib/views/login_view.dart`)**:
  - Exclusively dedicated to device biometrics/PIN unlock every time the app opens.
  - Removed email input field; provides direct biometric authentication prompt and fallback trial access.
- **First-Time Purchase License Activation Screen (`lib/views/start_view.dart`, `lib/views/purchase/components/purchase_data.dart`)**:
  - Dedicated first-run screen validating buyer's email against Firebase API (`ApiService.getUser`).
  - Card-based enterprise UI adhering to `AppColors` palette with input validation and license activation feedback.

## [2026-08-16] Monthly Reports & Arabic PDF Export + Daily Attendance Reminder
- **Monthly Reports & Statistics (`lib/views/reports/reports_view.dart`, `lib/view_models/reports_view_model.dart`)**:
  - Month & Year selector with quick navigation.
  - KPI Dashboard Summary: Total Active Workers, Total Work Days, Total Salary Earned, Total Amounts Withdrawn/Paid, and Net Remaining Balance.
  - Detailed Per-Worker Attendance Breakdown Cards (Days Present, Absent, Overtime, Earned, Drawn, Remaining).
- **Arabic PDF Report Generator (`lib/core/services/pdf_report_service.dart`)**:
  - Exports official Arabic PDF reports utilizing embedded `Cairo` font.
  - Formatted KPI summary headers, detailed workers table with totals row, and authorization signature placeholders.
  - Supports direct wireless printing, WhatsApp/email sharing, and file saving via `printing` package.
- **Daily Attendance Notification Reminder (`lib/core/services/daily_reminder_service.dart`, `lib/views/home/components/drawer/components/reminder_drawer.dart`)**:
  - Scheduled recurring local notifications to remind business owners/contractors to take daily attendance.
  - Interactive drawer tile with enable/disable switch and custom time picker (persisted in `SharedPreferences`).

## [2026-08-16] Weekly Attendance Auto-Grouping & Draggable BottomSheet
- **Weekly Attendance Auto-Grouping Logic**:
  - Corrected `setWeekId` in `AttendanceViewModel` to automatically group attendance days for the same weekly period (Saturday to Friday / unsettled week period) under the same active `weekId`.
  - New weeks only increment when the current week is settled (`weekStatus == 1`) or a new calendar week cycle begins.
- **Draggable Attendance BottomSheet**:
  - Replaced legacy `sliding_sheet2` with native `DraggableScrollableSheet` to eliminate viewport and nested scroll clipping.
  - Safe date parsing with `DateTime.tryParse` preventing `FormatException` crashes in attendance records table.

## [2026-08-10] WhatsApp-style Google Drive Automatic & Manual Cloud Backup
- **Google Drive Cloud Integration**:
  - Integrated `google_sign_in` with private `drive.appdata` scope (`https://www.googleapis.com/auth/drive.appdata`) for seamless, secure cloud backups.
  - Implemented `GoogleDriveService` (`lib/core/services/google_drive_service.dart`) to stream SQLite database (`dgi.db`) directly to/from Google Drive's hidden app storage.
  - Implemented `BackupViewModel` (`lib/view_models/backup_view_model.dart`) managing auth, cloud metadata (last backup date, size), and upload/restore progress.
  - Redesigned `BackupView` (`lib/views/backup/backup_view.dart`) with connected Google Account Card, Backup Status Card, and WhatsApp-style Cloud Backup & Restore buttons.

## [2026-08-09] Complete UI/UX Modernization & Design System
- **Enterprise SaaS HR Application Redesign**:
  - **Strict Color Rules**: Main brand set to Deep Indigo (`#3730A3` / `#EEF2FF`). Green/Amber/Red reserved strictly for semantic attendance status.
  - **Clean Header System**: Removed heavy dark navy blocks. Replaced with clean `#FFFFFF` / `#1E293B` background, `#0F172A` title (22px 700 bold), `#334155` icons, and subtle `#E2E8F0` divider.
  - **Home Dashboard & Interactive Filtering**:
    - Fixed attendance summary count calculations in `AttendanceViewModel` & `HomeView` so real-time counts (`إجمالي الموظفين`, `الحاضرون`, `الغائبون`, `غير المسجلين`) calculate accurately.
    - Added interactive tap filtering on summary cards: Tapping any card filters the employee list instantly (`الكل`, `حاضر`, `غائب`, `لم يسجل`) with active card border glow indicators.
  - **Employee List Rows**: Avatar `#EEF2FF` bg with `#3730A3` initial text, 16px 600 name, 13px 400 job title, and right-aligned status pill.
  - **Segmented Control**: Replaced aggressive green/red buttons with modern segmented toggle `[ حاضر | غائب ]` (Selected `#3730A3` bg + White text).
  - **Bottom Navigation**: Redesign with `#EEF2FF` selected pill background and clean slate inactive icons.
  - **Add Note Screen**: Redesigned `NoteEditor` with clean white header, centered title, Indigo save icon, 5 soft color selector circles (`SwitchColor`), structured title input, multiline content card, and full-width primary Save button.
  - **Add Employee Bottom Sheet**: Redesigned `AddingUserBottomSheet` with 24px top rounded corners, `#CBD5E1` drag handle, clean header (no purple header block), 3 modern inputs (~52px height, `#3730A3` focus border), and full-width primary button `[ + إضافة عامل ]`.
- **Color Palette Refactoring (Royal Indigo & Slate Navy)**:
  - Harmonized brand accent around Royal Indigo (`#6366F1` / `#4F46E5`), eliminating harsh clashing red/purple tones.
  - Softened status tints (Emerald Green `#10B981`, Soft Rose `#F43F5E`, Soft Amber `#F59E0B`) with custom dark/light background containers.
  - Standardized Drawer items, switches, headers, and app bar tones to strictly follow `AppColors`.
- **AppCard** (`lib/views/components/app_card.dart`): Reusable theme-aware card with 16px rounded borders, subtle ambient shadows, and touch ripple effects.
- **StatusChip** (`lib/views/components/status_chip.dart`): Pill-shaped badges for attendance status (`حاضر`, `غائب`, `لم يسجل`) with soft background tints and icons.
- **AppButton** (`lib/views/components/app_button.dart`): Standardized button component for primary, secondary, and danger action buttons.
- **Form Inputs & Bottom Sheets**:
  - `CustomTextField`: Refactored to be 100% theme-responsive (dynamic dark/light surface background, readable text color, accent border focus glow).
  - `HeaderSheet`: Modernized sheet header with `AppColors.primary` background, rounded top corners, and close icon button.
  - `FormSheet` & `AddingUserBottomSheet`: Updated with `AppButton` and refined padding.
  - `DrawFinance`: Modernized withdrawal bottom sheet.
  - `OverTime`: Modernized overtime checkbox row with `AppColors.accent`.
  - `BackupView`: Updated with responsive theme scaffold background and modern AppBar.
- **Home View Modernization**:
  - `UsersStatusListview`: Refactored to use `AppCard`, circular initial avatar badge with gradient background, and `StatusChip`.
  - `CustomAddButton`: Redesigned with accent gradient pill styling.
  - `DropDownMenuRow`: Modernized filter container with rounded border strokes.
- **Worker Details & Cards**:
  - `UserData`: Redesigned worker profile card with avatar header and metadata rows.
  - `BuildCard`: Refactored to delegate to `AppCard`.
  - `ButtonAttendance`: Updated with modern rounded elevated button styling.
- **Notes & Trash Modernization**:
  - `ItemNote`: Updated with `AppCard`, vertical accent indicator strip, and formatted date tag.
  - `CustomCardTrash`: Modernized with `AppCard` and clean action icons.

## [2026-08-08] Local Authentication Fallback Handling
- **LocalAuthApi** (`lib/data/services/local_auth_service.dart`):
  - Added safety checks for `isDeviceSupported()` and `canCheckBiometrics`.
  - Adjusted `authenticate()` signature for `local_auth` ^3.0.1 compatibility (`localizedReason`).
  - Added comprehensive `try-catch` blocks around `authenticate()` to prevent `noCredentialsSet` or `PlatformException` runtime crashes.
- **LoginView** (`lib/views/login_view.dart`):
  - Implemented Option 3 fallback behavior: if a device has no fingerprint or screen lock enrolled, a user-friendly SnackBar (`لا يوجد قفل شاشة أو بصمة مسجلة، سيتم الدخول مباشرة`) is displayed, and the app proceeds seamlessly to `BottomNavView`.

## [2026-08-08] Dark Mode & Theme Persistence
- **ThemeViewModel** (`lib/view_models/theme_view_model.dart`):
  - Created `ThemeViewModel` extending `ChangeNotifier` for managing `ThemeMode` (light/dark).
  - Persists theme preference via `CacheHelper` using key `'isDarkMode'`, auto-loaded on launch.
- **Dark Theme Data** (`lib/core/theme/theme.dart`):
  - Added `darkThemeData` with a dark blue/slate palette (`0xFF1A1A2E` background, `0xFF16213E` surface/cards, `0xFFE94560` accent).
  - Refined light theme with explicit `AppBarTheme.backgroundColor` for consistency.
- **GetIt Registration** (`lib/core/services/service_locator.dart`):
  - Registered `ThemeViewModel` as a lazy singleton.
- **main.dart**:
  - Added `ChangeNotifierProvider<ThemeViewModel>` to `MultiProvider`.
  - Wrapped `MaterialApp` in a `Consumer<ThemeViewModel>` to reactively apply `darkTheme` and `themeMode`.
- **ThemeDrawer** (`lib/views/home/components/drawer/components/theme_drawer.dart`):
  - Created new drawer item with animated icon switch (`Icons.light_mode_rounded` / `Icons.dark_mode_rounded`) and `SwitchListTile`.
- **MainDrawer** (`lib/views/home/components/drawer/main_drawer.dart`):
  - Integrated `ThemeDrawer` between the backup item and purchase item.

## [2026-08-08] Localization (Arabic Default) & GetIt Service Locator Refactoring
- **GetIt Service Locator Integration**:
  - Integrated `get_it` package (`^8.0.3`) for centralized dependency injection.
  - Created `lib/core/services/service_locator.dart` to register `DatabaseHandler`, Repositories (`IUserRepository`, `IAttendanceRepository`, `INoteRepository`), and ViewModels.
  - Refactored `main.dart` to use `await setupServiceLocator()` and simplified `MyApp` constructor.
  - Updated ViewModels (`UserViewModel`, `AttendanceViewModel`, `NoteViewModel`) to fallback to `sl<...>()` service locator instances.
- **Arabic-First Localization**:
  - Configured Flutter standard localization with `l10n.yaml` and `pubspec.yaml` (`generate: true`).
  - Added Arabic (`app_ar.arb`) as the primary default locale and English (`app_en.arb`) as secondary locale in `lib/l10n/`.
  - Configured `MaterialApp` in `lib/main.dart` with `locale: const Locale('ar')` and `AppLocalizations` delegates.

## [2026-05-18] SOLID and Dependency Injection Refactoring
- **DatabaseHandler**: Refactored to implement the Singleton pattern to ensure only a single database connection is created and shared across the app.
- **Repository Interfaces**: Extracted abstract interfaces (`IUserRepository`, `IAttendanceRepository`, `INoteRepository`) to decouple the ViewModels from concrete SQLite implementations (OCP).
- **Repository Refactoring**:
  - Implemented the interfaces in `UserRepository`, `AttendanceRepository`, and `NoteRepository`.
  - Added constructor injection to accept a `DatabaseHandler` instance (DIP).
  - Centralized table names into private constants (`_tableName`) (SRP).
  - Added comprehensive `try-catch` blocks across all database operations to prevent app crashes on DB failures.
- **ViewModel Refactoring**:
  - Updated `UserViewModel`, `AttendanceViewModel`, and `NoteViewModel` to use Dependency Injection.
  - Removed all local instantiations (e.g., `final repository = UserRepository()`) from inside the methods.
- **main.dart**:
  - Wired up dependencies at the root of the application by initializing the `DatabaseHandler` and Repositories once, then injecting them into the ViewModels via `ChangeNotifierProvider`.

## [2026-05-11] Flutter Version Upgrade
- Updated Dart SDK constraint to `>=3.11.5 <4.0.0` (matching local environment).
- Performed major version upgrade for all dependencies.
- Updated core libraries:
    - `firebase_core`: ^4.7.0
    - `flutter_local_notifications`: ^21.0.0 (Fixed major breaking changes in API)
    - `local_auth`: ^3.0.1 (Fixed API compatibility)
    - `device_info_plus`: ^12.4.0
    - `http`: ^1.6.0
    - `intl`: ^0.20.2
    - `font_awesome_flutter`: ^11.0.0 (Switched to `FaIcon` for compatibility)
- Fixed `pubspec.yaml` structural issues:
    - Moved `flutter_lints` to `dev_dependencies`.
    - Updated `flutter_lints` to `^5.0.0`.
- Resolved code-level breaking changes and deprecations:
    - Replaced `withOpacity` with `withValues`.
    - Fixed `flutter_local_notifications` initialization and scheduling logic.
    - Updated `FaIconData` usage.
    - Fixed validator return types.

## [2026-05-11] Major MVVM Refactoring
- Refactored project structure to **MVVM (Model-View-ViewModel)**.
- Organized folders:
    - `lib/data/`: Models and Repositories.
    - `lib/view_models/`: Business logic and state (renamed from `providers`).
    - `lib/views/`: UI Screens and components (renamed from `pages`).
    - `lib/core/`: Utilities, theme, and notifications.
- Standardized file naming to **snake_case** and class naming to **PascalCase**.
- Renamed key classes and files:
    - `UserProvider` -> `UserViewModel`
    - `AttendanceProvider` -> `AttendanceViewModel`
    - `NoteProvider` -> `NoteViewModel`
    - `CashHelper` -> `CacheHelper`
    - `BottomBarScreen` -> `BottomNavView`
    - `HomePage` -> `HomeView`
    - `NotePage` -> `NoteView`
    - `TrashPage` -> `TrashView`
    - `SplashPage` -> `SplashView`
    - `StartPage` -> `StartView`
    - `LoginPage` -> `LoginView`
    - `BackupPage` -> `BackupView`
- Updated all imports globally to use the new package structure.

## [2026-05-11] Android Build Fix
- Fixed multidex dependency error:
    - Changed `com.android.support:multidex:2.0.1` to `androidx.multidex:multidex:2.0.1` in `android/app/build.gradle`.
    - This resolves the `Could not find com.android.support:multidex:2.0.1` build failure.
## [2026-05-16] Firebase User Verification Fix
- Improved `ApiService.getUser` to handle case sensitivity and extra whitespace by adding `.trim().toLowerCase()` to the email.
- Enhanced logging in `ApiService` to provide more detailed feedback on database requests and responses.
- Fixed a bug where `setDeviceToken` was not being awaited correctly.
- Added null check for `deviceToken` in user data validation.
