## [2026-11-07] Flutter Analyze & Code Quality Cleanup (0 Errors, 0 Warnings)
- **Scope**: Executed full project analysis via `flutter analyze` and resolved all compilation errors, syntax inconsistencies, and warnings across the codebase.
- **Key Issues Resolved**:
  - **`lib/views/feedback/feedback_view.dart`**: Fixed syntax breakdown caused by duplicate bracket/closure structure at the bottom of the file (resolved 24 cascading parsing errors).
  - **`lib/views/purchase/components/playstore_paywall.dart`**: Resolved `invalid_constant` errors where dynamic localized strings (`context.l10n...`) were used inside `const Text` and `const Row` widgets.
  - **`lib/core/utils/global_methods.dart`**: Unified `getDayName` parameter signature to optional positional argument and updated callers in `backup_view.dart` and `item_note.dart` accordingly; removed redundant `this.` qualifiers.
  - **`lib/core/utils/cache_helper.dart`**: Removed unused `material.dart` import, eliminated redundant null coalescing (`?? null`), and added explicit boolean typing to global flags (`trial`).
  - **`lib/data/models/attendance.dart`**: Removed unused import `attendance_view_model.dart`.
  - **`lib/main.dart`**: Removed unused import `flutter_localizations.dart`.
  - **`lib/views/home/components/drawer/components/title_drawer.dart`**: Cleaned up unused local variable `isArabic`.
  - **`lib/views/home/components/drawer/components/theme_drawer.dart`**: Migrated deprecated `activeColor` parameter on `Switch.adaptive` to modern `activeThumbColor`.
- **Status**: Verified clean analysis via `flutter analyze` with **0 errors and 0 warnings**.

## [2026-11-07] Complete App-Wide Localization & Static String Migration (Arabic & English)
- **Scope & Objective**: Complete extraction and localization of all remaining hardcoded static Arabic texts across every view, widget, modal sheet, drawer item, and utility dialog into both Arabic (`ar`) and English (`en`).
- **Files Modified**:
  - `lib/l10n/app_ar.arb` & `lib/l10n/app_en.arb` (Added 130+ comprehensive translation keys)
  - `lib/l10n/app_localizations.dart`, `lib/l10n/app_localizations_ar.dart`, `lib/l10n/app_localizations_en.dart`
  - `lib/views/purchase/components/purchase_data.dart` (License activation form, email field, validation, status feedback)
  - `lib/views/purchase/components/playstore_paywall.dart` (Full paywall UI, tier selection, feature checklist, legal links)
  - `lib/views/purchase/purchase_app.dart` (AppBar, security note, encrypted backup banner)
  - `lib/views/purchase/components/subscription_plan_card.dart` (Duration label, discount percentage badge)
  - `lib/views/users/components/attendance.dart` (Segmented status buttons, quick workplace suggestion chips, alert dialogs)
  - `lib/views/users/components/over_time.dart` (Custom overtime calculation sheet, multiplier chips, manual input, currency)
  - `lib/views/users/components/appbar.dart` (Title, actions, deletion notifications)
  - `lib/views/users/components/draw_money.dart` (Advance withdrawal form, expiration alert, confirmation toast)
  - `lib/views/users/components/user_data.dart` (Worker info rows, fallback labels)
  - `lib/views/users/components/slid_bottom_sheet/components/week_status.dart` (Settlement confirmation, expiration alert)
  - `lib/views/home/components/trial_expired_banner.dart` (Trial and subscription expiration banner, read-only mode warning)
  - `lib/views/home/components/drawer/components/purchase_drawer.dart` (Dynamic drawer status badge, remaining days, unlimited tier)
  - `lib/views/home/components/drawer/components/reminder_drawer.dart` (Daily reminder toggle, time picker dialog, time formatter)
  - `lib/views/home/components/drawer/components/title_drawer.dart` (App title and slogan via l10n)
  - `lib/views/home/components/drawer/components/whats_new_drawer.dart` (New badge indicator)
  - `lib/views/projects/project_detail_view.dart` (Project status, budget tracking, financial summary, deletion dialog, popup menu)
  - `lib/views/settings/manage_work_places_view.dart` (Add/edit/delete workplaces, confirmation dialogs, snackbar alerts, empty state)
  - `lib/views/whats_new/whats_new_view.dart` & `whats_new_modal_sheet.dart` (Latest version hint, update announcement modal)
  - `lib/views/reports/reports_view.dart` (Month navigation tooltips, PDF subscription paywall message)
  - `lib/views/components/functions.dart` (`showFlushBar` bilingual message handling and expiration notifications)
  - `lib/views/EmptyScreen/empty_screen.dart` (Empty state label via `context.l10n.noData`)
  - `lib/views/home/components/custom_appbar.dart` & `lib/views/home/home_view.dart` (Localized comma separator for date display)
  - `lib/views/home/bulk_attendance/bulk_attendance_view.dart` (Localized bulk attendance confirmation notification)
- **Key Architecture & Design Standards**:
  - Maintained complete separation of concerns: UI views strictly consume localized strings via `context.l10n` or `context.isArabic`.
  - Preserved internal database and business logic keys (`'حاضر'`, `'غائب'`, `'لم يسجل'`, `'الكل'`) while displaying localized representations in the UI.
  - Directionality awareness: replaced hardcoded `TextDirection.rtl` with `context.textDirection` across text fields for seamless LTR/RTL support.

## [2026-11-06] Comprehensive Localization System (Arabic & English Support)
- **Files**:
  - `lib/view_models/locale_view_model.dart`
  - `lib/l10n/app_ar.arb`
  - `lib/l10n/app_en.arb`
  - `lib/l10n/app_localizations.dart`
  - `lib/l10n/app_localizations_ar.dart`
  - `lib/l10n/app_localizations_en.dart`
  - `lib/views/home/components/drawer/components/language_drawer.dart`
  - `lib/core/services/service_locator.dart`
  - `lib/core/utils/extensions/context_extension.dart`
  - `lib/core/utils/global_methods.dart`
  - `lib/main.dart`
- **Features & Architecture**:
  - **State Management & Persistence (`LocaleViewModel`)**:
    - Created `LocaleViewModel` implementing `ChangeNotifier` to manage the active `Locale` ('ar' or 'en').
    - Persistent language choice saved securely in `CacheHelper` under key `app_locale` with Arabic ('ar') as default.
    - Registered as a lazy singleton in `GetIt` and provided via `MultiProvider` at the root of the widget tree.
  - **Reactive Root Configuration (`main.dart`)**:
    - Connected `MaterialApp` to `Consumer2<ThemeViewModel, LocaleViewModel>` for instant, flicker-free language switching at runtime.
    - Configured delegates (`AppLocalizations.localizationsDelegates`) and supported locales (`['ar', 'en']`).
  - **In-App Language Switcher (`LanguageDrawer`)**:
    - Added a sleek `LanguageDrawer` widget inside the main navigation drawer with quick toggle between العربية and English.
  - **Date & Time Localization (`GlobalMethods`)**:
    - Enhanced `getDayName` and `getTimeFormat` to dynamically adapt to the active language code.
  - **UI Internationalization**:
    - Integrated `context.l10n` convenience getter in `context_extension.dart`.
    - Localized main screens and widgets including Home View, Custom AppBar, Summary Cards, Bulk Attendance, Status Pills, User Details, Projects, Reports, Notes, and Trash.

## [2026-11-06] Bulk Attendance: Skip Already-Attended Employees
- **Files**: `lib/views/home/bulk_attendance/bulk_attendance_view.dart`, `lib/views/home/bulk_attendance/components/employee_check_tile.dart`
- **Feature**: When opening the bulk attendance screen, employees that were already attended individually for today are automatically excluded:
  - Loaded via the existing `preloadTodayAttendance` + `getAttendanceFromCache` cache — no extra DB queries.
  - Already-attended employees appear greyed-out with a **"مسجّل مسبقاً"** label and a green ✓ icon instead of a checkbox.
  - They are locked (taps ignored) and cannot be selected or included in the bulk submit.
  - The selection counter shows only eligible (not-yet-attended) employees.
  - "تحديد الكل" only selects eligible employees; already-attended are never touched.

## [2026-11-05] Fix: Project Work Days Count Inflated (Duplicate-Day Deduplication)
- **File**: `lib/data/repositories/project_repository.dart`
- **The Bug**: "أيام العمل" (work days) in Projects view increased by 1 for each user attended in a project — even without new attendance — whenever the Projects page was opened.
- **Root Cause**: The SQL query used `COUNT(*)` which counted ALL attendance rows per user (including rows from past wage/advance updates that could share the same `todayDate`). Additionally, any scenario where the same calendar day produced more than one row (date format variations, etc.) would inflate the count.
- **Fix**: Split into two separate SQL queries:
  1. **Financial query** (wages + advances per user): Inner groups by `(userId, SUBSTR(todayDate, 1, 10))` using `MAX()` to deduplicate same-day rows; outer sums per user. Builds `workerIds` set for worker count.
  2. **Days query**: `COUNT(DISTINCT SUBSTR(todayDate, 1, 10))` across **all workers** — counts unique calendar days the project had any attendance, regardless of how many workers attended that day.
- **Result**: "أيام العمل" = calendar days the project ran (e.g. 3 workers all attending on the same day = 1 work day, not 3). Financial totals are correctly deduplicated per user per day.

## [2026-11-05] Projects Financial & Attendance Real-Time Sync Fix
- **Live Sync & Invalidation (`ProjectsView`, `ProjectDetailView`, `ProjectViewModel`, `ProjectRepository`)**:
  - **The Issue**: When adding attendance, drawing an advance, or settling worker accounts on a project, navigating to `ProjectsView` still displayed stale stats until the app was completely restarted due to an uninvalidated in-memory cache (`_statsCache`) and `ProjectsView` being a static `StatelessWidget`.
  - **Resolution**:
    - Converted `ProjectsView` to a `StatefulWidget` with automatic `loadProjects()` on entry (`initState`) which clears `_statsCache` and re-aggregates project financials directly from SQLite.
    - Added `RefreshIndicator` (pull-to-refresh) and an AppBar manual refresh button (`Icons.refresh_rounded`) to `ProjectsView`.
    - Added `RefreshIndicator` and entry cache-invalidation to `ProjectDetailView` allowing instant refresh of project stats and worker lists.
    - Updated `ProjectDetailView` navigation return callback (`.then()`) in `ProjectsView` to refresh project list immediately when returning.
    - Safeguarded SQL aggregation in `ProjectRepository.getProjectStats` with `TRIM(workPlace) = TRIM(?)` to prevent whitespace mismatches.

## [2026-11-04] Subscription Date Tracking System (Database & Web Admin Dashboard)
- **Database & Telemetry Layer (`TelemetryService`, `SecureStorageHelper`, `InAppPurchaseService`, `ApiService`)**:
  - **Device Telemetry (`/devices/$uuid`)**:
    - Automatically synchronizes `subscriptionDate`, `subscriptionExpiryDate`, and `subscriptionPlan` to Firebase Realtime Database whenever an active subscription is detected.
    - Extended `SecureStorageHelper` with `getSubscriptionDate()` and `getActiveSubscriptionId()` to securely read hardware-encrypted subscription dates.
    - Updated `InAppPurchaseService`: instantly triggers immediate silent telemetry sync (`force: true`) upon subscription completion or restoration to update Firebase in real-time.
  - **Account Verification (`/users/$encodedEmail`)**:
    - Updated `ApiService.getUser`: synchronizes and reads `subscriptionDate` and `plan` from Firebase `/users` directly into local encrypted storage when validating direct accounts.
    - Updated existing user records in Firebase Realtime Database with realistic subscription dates and expiration terms.
- **Web Admin Dashboard Integration (`docs/index.html`, `docs/js/app.js`, `docs/js/firebase-config.js`, `docs/js/mock-data.js`)**:
  - **Users Management Tab (`#tab-users`)**:
    - Added dedicated table columns: **📅 تاريخ الاشتراك** (Subscription Date) and **⏳ انتهاء الاشتراك** (Expiry Date / Renewal).
    - Status badge indicators dynamically check if subscription has expired (`منتهي 🔴` vs `نشط 🟢`).
    - Added **User Subscription Modal (`#user-modal`)**:
      - ➕ Register new user or edit existing account with email, start date, expiry date, plan (`سنوي 👑`, `نصف سنوي 💎`, `ربع سنوي ⏳`, `شهري ⚡`, `ترخيص دائم ♾️`), and status.
      - Includes "فك الارتباط" button to clear linked device tokens for users migrating to new phones.
    - Added `saveUser()` method in `firebase-config.js` to persist changes directly to Firebase `/users`.
  - **Devices Tab (`#tab-devices`)**:
    - Updated column header to "حالة وتاريخ الاشتراك".
    - Active subscribed devices (`isSubscribed: true`) now explicitly display their exact subscription start and expiration dates directly under the subscription badge.

## [2026-11-04] "What's New" Updates System & Web Admin Dashboard Integration
- **100% Dynamic & Remote-Controlled (No Static Data)**:
  - Completely purged hardcoded/static default release items (`_defaultItems` removed). All content is controlled exclusively from Firebase Realtime Database at `/whats_new`.
  - **Dynamic Conditional Section Visibility (`MainDrawer`, `WhatsNewService`, `WhatsNewViewModel`)**:
    - When the admin removes/deletes all updates from the dashboard (or when `/whats_new` is empty/null), local cache is cleared and the "ما الجديد والتحديثات" section and divider in the side drawer are completely hidden (`Consumer<WhatsNewViewModel>` returns `SizedBox.shrink()`).
    - Startup popup sheet is completely suppressed when no active updates exist.
    - Added 1-click `حذف الكل (إخفاء القسم من التطبيق)` in the admin dashboard alongside individual delete buttons to purge `/whats_new` instantly.
- **Zero-Waste Request Architecture & Local Caching (`WhatsNewService`, `WhatsNewViewModel`)**:
  - **12-Hour Request Throttling**: Eliminates useless polling and repetitive network calls; app only fetches updates from Firebase RTDB at most once every 12 hours or upon manual pull-to-refresh.
  - **Persistent Offline Cache**: Stores fetched release notes in local `CacheHelper` JSON, allowing instant 0ms rendering on app launch with zero network dependency.
  - **Unseen Indicator & Smart Highlight Sheet**:
    - Unseen release updates trigger a subtle `جديد ✨` badge on the `WhatsNewDrawer` item.
    - If a major highlight release has not been seen by the user, a non-intrusive welcoming bottom sheet (`WhatsNewModalSheet`) appears once upon startup and marks the release as seen immediately.
- **In-App "What's New" Experience (`WhatsNewView`, `WhatsNewCard`, `WhatsNewDrawer`)**:
  - Full-screen release history screen with tag badges (`ميزات جديدة 🚀`, `تحسينات ⚡`, `إصلاحات 🛠️`), version tags, dates, and bulleted feature breakdowns.
  - Pull-to-refresh integration for on-demand sync.
  - Dedicated side drawer entry (`WhatsNewDrawer`) with live badge indicator.
- **GitHub Pages Admin Dashboard Integration (`docs/index.html`, `docs/js/app.js`, `docs/js/firebase-config.js`)**:
  - Added new dedicated tab **"🚀 ما الجديد والتحديثات"** in the web admin portal with real-time release count badge.
  - Intuitive release publisher form: version, release title, tag selector, date, description, feature bullet points, and highlight toggle.
  - Instant live publishing directly to Firebase Realtime Database at `/whats_new`.
  - Management & deletion controls for all published announcements with instant state sync.
  - Added read/write access rules for `/whats_new` in `database.rules.json`.

## [2026-11-03] Work Place Management (Delete/Edit/Add) & Bulk Attendance Engine
- **Work Place Management Screen & Persistence Layer (`ManageWorkPlacesView`, `WorkPlaceViewModel`, `WorkPlaceRepository`)**:
  - **Dedicated Database Table & Migration v3**: Added `work_places` table (`id`, `name UNIQUE`) in SQLite schema with auto-migration from previous versions without affecting legacy attendance records.
  - **Seed & Reference Sync**: Implemented automatic seeding from legacy attendance strings (`seedFromAttendance()`), plus clean cascade logic: updating a workplace renames historical references in `attendance`, while deleting resets old references to `'الورشة / الموقع'` to eliminate ghost suggestions.
  - **Dedicated Management Screen (`lib/views/settings/manage_work_places_view.dart`)**:
    - Add new workplace with instant deduplication and feedback.
    - Inline dialog to edit/rename workplace name.
    - Confirmation dialog for permanent deletion.
    - Added direct navigation entry in `MainDrawer` (`WorkPlacesDrawer`).
  - **Unified Suggestion Chips Integration (`AttendanceWidget`, `attendance.dart`)**:
    - Integrated `WorkPlaceViewModel` alongside `ProjectViewModel` and legacy locations.
    - Any new workplace typed during single-employee attendance recording is auto-saved into `work_places`.

- **Bulk Attendance Recording Engine (`BulkAttendanceView`, `BulkAttendanceButton`, `AttendanceViewModel`)**:
  - **Contextual & Clear Trigger (`BulkAttendanceButton`, `home_view.dart`)**:
    - Replaced the ambiguous AppBar groups icon with a dedicated, explicitly labeled action button (`[ 📋 تسجيل جماعي ]`) placed directly beside the "الموظفون" section header.
    - Non-intrusive: Checkboxes do NOT clutter the main home screen on startup; they only appear upon opening the dedicated Bulk Attendance screen.
  - **All-at-Once or Custom Checklist Selection**:
    - Top interactive toggle between `حاضر` (Present) and `غائب` (Absent).
    - Quick "تحديد الكل" / "إلغاء تحديد الكل" action allowing 1-tap bulk attendance for the entire workforce.
    - Custom checklist with avatar initials, employee names, and roles for flexible partial selection.
  - **Workplace Picker Bottom Sheet (`WorkplacePickerSheet`)**:
    - When submitting attendance as `حاضر`, prompts with a bottom sheet allowing 1-tap selection from registered workplaces or quick entry of a new site.
    - Automatically skips location prompt when marking `غائب` (defaults cleanly to `'لا يوجد'`).
  - **Comprehensive Salary & Daily Record Protection**:
    - Accurately assigns each employee's daily wage (`user.salary`) when present, and `'0'` when absent.
    - Updates today's existing records or inserts new ones, followed by synchronous cache invalidation to immediately refresh Home summary cards and statuses.

## [2026-10-07] GitHub Pages Web Admin Analytics Dashboard (`docs/`)
- **Interactive Multi-Filter Admin Dashboard for GitHub Pages Deployment**:
  - Built a zero-cost, static admin analytics web app hosted directly in `/docs` for 1-click GitHub Pages deployment (`username.github.io/work_time`).
  - **Modular Architecture**:
    - `docs/index.html`: Semantic HTML5 portal with tabs (Overview, Devices, Feedbacks, Accounts, Settings), responsive layouts, and modal authentication.
    - `docs/css/style.css` & `docs/css/components.css`: Modern design system featuring dark/light themes, glassmorphism, responsive grid, status pulses, and KPI cards.
    - `docs/js/firebase-config.js`: Web client integration with Firebase Realtime Database and Firebase Auth.
    - `docs/js/state.js` & `docs/js/mock-data.js`: Central reactive state manager with seamless Demo Mode fallback.
    - `docs/js/charts.js`: Interactive Chart.js visualizations for activity timelines, subscription ratios, top device brands, and workforce group scales.
    - `docs/js/filters.js`: Multi-criteria filtering engine supporting subscription status, activity timeframes, OS versions, team scales, feedback message types, contact info, and dynamic sorting.
    - `docs/js/app.js`: Application lifecycle, live refresh, WhatsApp/Email direct actions, and 1-click CSV report exports.
  - **Branding & Official "ع" Logo**:
    - Replaced branding assets with the official new "ع" transparent logo (`transparent-logo.png`) across the navbar and browser tab favicon (`docs/assets/logo.png`, `docs/assets/favicon.png`).
  - **Real Employer & Activity Engagement Detection**:
    - Implemented smart engagement categorization (`getEngagementStatus()`): identifies real employers (`employeeCount > 0` or `projectsCount > 0`), active users (last 7d), trial testers, and dormant visitors.
    - Added dedicated Overview KPI card: "👑 أصحاب العمل الفعليين" displaying the exact count of real active contractors/employers.
    - Added multi-criteria engagement filters and quick chips in the Devices tab (`👑 أصحاب عمل حقيقيين`, `🟢 النشطون مؤخراً`, `💤 الخاملون`).
  - **Direct Firebase Deletion Support**:
    - Implemented 1-click user deletion (`handleDeleteUser()`) from `/users` with confirmation modal and state sync.
    - Implemented 1-click test/device deletion (`handleDeleteDevice()`) from `/devices` with confirmation modal and state sync.
  - **Live Database Connection & Security Rules (`database.rules.json`)**:
    - Released and deployed Firebase rules allowing dashboard to read and delete live telemetry, feedbacks, and users.
    - Configured automatic live data loading on startup with real-time listeners for instant updates.

## [2026-10-07] GC Optimization & Jank Elimination Implementation (Performance Audit & Fixes)
- **Resolved All 7 GC & Jank Issues Across the Codebase**:
  - **Problem 1 (Fixed)** (`home_view.dart` & `attendance_view_model.dart`): Replaced N asynchronous DB queries in `_calculateAttendanceSummary` with `getDailySummary(userIds)`, backed by a daily-scoped `_dailySummaryCache`.
  - **Problem 2 (Fixed)** (`users_status_listview.dart` & `attendance_view_model.dart`): Replaced per-cell `FutureBuilder<Attendance?>` DB queries in `ListView.builder` with preloaded `_todayAttendanceMap` accessed synchronously at O(1) in memory via `getAttendanceFromCache()`.
  - **Problem 3 (Fixed)** (`project_view_model.dart`): Removed runtime `.where().toList()` filter allocations inside `activeProjects` and `completedProjects` getters; replaced with cached `_activeProjects` and `_completedProjects` lists computed only upon project mutations.
  - **Problem 4 (Fixed)** (`trial_expired_banner.dart`): Converted `TrialExpiredBanner` from `StatelessWidget` to `StatefulWidget`, initializing the asynchronous `SecureStorageHelper` query once in `initState()` and eliminating duplicate KeyStore I/O calls on every rebuild.
  - **Problem 5 (Fixed)** (`user_view_model.dart`): Replaced dynamic `.where().toList()` on every `searchResults` getter access with an in-memory cached `_searchResults` list updated only when search query or user list changes.
  - **Problem 6 (Fixed)** (`attendance_view_model.dart`): Replaced repeated `Map + sort` calculations inside `weekAttendanceMap` and `sortedWeekGroups` getters with a dedicated `_buildWeekCache()` executed once when weekly data arrives.
  - **Problem 7 (Fixed)** (`users_status_listview.dart`, `project_worker_tile.dart`): Replaced duplicate `.trim()` allocations in `ListView` and tile cards with a single local cached variable per build.
- **Reference & Interview Guide**: Full analysis with technical reasoning and interview scripts documented in [`GC_JANK_ANALYSIS.md`](file:///c:/my_projects/work_time/GC_JANK_ANALYSIS.md).

## [2026-09-25] Anonymous Telemetry Sync & User Feedback with In-App Review
- **24-Hour Silent Telemetry Engine (`TelemetryService`, `lib/core/services/telemetry_service.dart`)**:
  - Implemented persistent device UUID generation (RFC 4122 v4) stored in local cache.
  - Automatically queries local SQLite database for aggregate metrics (`employeeCount`, `projectsCount`) and device info (`brand`, `model`, `osVersion`, `isSubscribed`, `firstSeen`, `lastSeen`).
  - Sends a silent background PATCH request to Firebase Realtime Database (`/devices/{uuid}.json`) throttled to once every 24 hours without interrupting UI or requesting user permissions.
- **In-App Feedback & Suggestions System (`FeedbackService`, `FeedbackView`, `FeedbackDrawer`)**:
  - Created standalone `FeedbackView` with clean light brand styling, message type chips (`اقتراح ميزة 💡`, `مشكلة أو عطل ⚠️`, `رأي عام 💬`), message input, and optional contact field.
  - Posts feedback payloads to Firebase Realtime Database (`/feedbacks.json`) tagged with device UUID and device model.
  - Automatically prompts the native Google Play In-App Review sheet upon successful submission as requested.
  - Integrated `FeedbackDrawer` entry in `MainDrawer` for easy accessibility.

## [2026-09-25] Direct 1-Step In-App Review Integration (تقييم التطبيق بخطوة واحدة)
- **RateService Engine (`RateService`, `lib/core/services/rate_service.dart`)**:
  - Integrated official `in_app_review: ^2.0.12` package utilizing Google Play In-App Review API.
  - Implemented background silent guards: verifies launch count (`launchCount >= 3`), 30-day throttle interval (`lastPromptDate`), and single-evaluation flag (`hasRated`).
  - Added direct fallback to Play Store listing via `openStoreListing()` with external application launcher URL.
- **Smart Golden Moment Trigger (`WeekStatus`, `week_status.dart`)**:
  - Automatically invokes 1-step review prompt upon successful weekly account settlement (`تصفية الحساب`) when employer reaches a high-satisfaction milestone.
  - Displays Google Play native review sheet seamlessly over current screen without disrupting application workflow or navigating away.
- **Side Drawer Entry (`RateDrawer`, `lib/views/home/components/drawer/components/rate_drawer.dart`, `MainDrawer`)**:
  - Added dedicated, non-intrusive "قيّم التطبيق" item in the main drawer styled with warm amber star icon.
  - One-tap direct action opening Google Play Store listing on-demand.

## [2026-09-05] Project / Site Cost Tracking & Budget Management (المشاريع ومواقع العمل)
- **Project Data & Migration Layer (`Project`, `ProjectStats`, `DatabaseHandler`)**:
  - Added `Project` model with fields (`id`, `name`, `budgetAmount`, `status`, `createdAt`).
  - Added `ProjectStats` model aggregating `totalWages`, `totalAdvances`, `totalDays`, and `workerCount`.
  - Upgraded SQLite schema to version 2 with automated migration creating `projects` table for existing installations without touching legacy attendance tables.
- **Repository & Reactive State Architecture (`IProjectRepository`, `ProjectRepository`, `ProjectViewModel`)**:
  - Implemented CRUD methods for managing projects (`insertProject`, `updateProject`, `deleteProject`, `retrieveAll`).
  - Implemented dynamic aggregation (`getProjectStats(projectName)`) extracting real-time labor costs, withdrawals, and working days by querying the existing `attendance` table filtered by `workPlace`.
  - Registered repository & view model in `ServiceLocator` and added lazy loaded provider in `main.dart`.
- **Zero-Friction Design for Single-Location Users**:
  - No required project association during daily attendance recording; existing flows and single-shop/workshop setups continue working with zero friction.
  - Workplace names used in attendance seamlessly link with project records of the same name.
- **Modern UI Suite (`ProjectsView`, `ProjectDetailView`, `BudgetProgressBar`, `ProjectCard`, `AddProjectSheet`, `ProjectsDrawer`)**:
  - Modularized widgets into separate files to keep code clean, readable, and compliant with user guidelines.
  - `ProjectsView`: Filterable list distinguishing active vs completed projects, empty state illustrations, and floating add action.
  - `ProjectCard`: Responsive financial card with status chip, live wage & advance metrics, and visual budget progress.
  - `ProjectDetailView`: Comprehensive project breakdown with KPI grid, budget consumption meter, and worker attendance stats.
  - `AddProjectSheet`: Bottom sheet form with name validation and optional estimated budget input.
  - `ProjectsDrawer`: Added entry in `MainDrawer` styled with industrial amber aesthetics and theme awareness.
- **Attendance Suggestion Chips Integration (`AttendanceWidget`, `attendance.dart`)**:
  - Connected `ProjectViewModel.activeProjects` directly into worker daily attendance.
  - Active projects appear prominently as instant suggestion chips with project icon (`Icons.construction_rounded`) right under "مكان / موقع العمل".
  - One-tap selection fills the workplace field precisely, eliminating manual typing errors and instantly associating wages/advances with the project.
- **Project Detail Screen Modern Light Redesign (`project_detail_view.dart`, `ProjectSummaryGrid`, `ProjectFinancialCard`, `ProjectWorkerTile`, `ProjectEmptyWorkersHint`)**:
  - Implemented crisp, professional light SaaS theme (#F8FAFC, white cards, #E2E8F0 borders, #0F172A typography).
  - Integrated custom Top App Bar with RTL back navigation, centered project name, and left 3-dot management menu.
  - Formatted 2x2 statistics grid with Iconly icons, color-coded icon badges, and bold metrics.
  - Built interactive, clickable worker tiles with avatar initials, role & site subtext, and navigation to worker profile.
  - Added subtle empty-state and single-worker guidance banner encouraging user to track additional workers.

## [2026-09-01] Google Play Subscription Auto-Sync & Expiration Lifecycle Management
- **Subscription Expiration Calculation & Timestamp Tracking (`SecureStorageHelper`)**:
  - Implemented tier duration calculation (`getSubscriptionDuration`): 30 days (Monthly), 90 days (Quarterly), 180 days (Biannual), 365 days (Yearly).
  - Saved encrypted expiration timestamp (`sec_subscription_expiry_date`) upon purchase or verification.
  - Automatically compares `DateTime.now()` with `expiryDate` in `isUserExist()`: when expiration passes, instantly revokes active license (`setUserExist(false)`).
- **Restored Purchase Expiration Validation (`InAppPurchaseService`)**:
  - Updated `_verifyPurchase` to validate transaction timestamp of restored history items against tier duration. Expired historical purchases from Google Play history are filtered out and denied re-activation.
- **Silent Background Subscription Verification (`InAppPurchaseService`)**:
  - Implemented `syncSubscriptionStatusSilently()` called on service initialization in Google Play flavor.
  - Automatically queries Google Play Billing for active subscriptions for existing/past subscribers.
  - If an active subscription has expired or was cancelled without renewal, automatically updates encrypted local license state (`setUserExist(false)`).
- **Subscription History Tracking (`SecureStorageHelper`)**:
  - Added `wasSubscribedBefore()` and `keyActiveSubscriptionId` to differentiate between new users whose 14-day free trial expired vs paid users whose recurring subscription expired.
- **Context-Aware Expiration Messages (`functions.dart`, `showFlushBar`)**:
  - Dynamically switches title, description, and action button text between `"انتهت الفترة التجريبية"` (ترقية الحساب) for trial users and `"انتهت فترة الاشتراك"` (تجديد الاشتراك) for expired paid subscribers.
- **Attendance Expiration Gatekeeper Fix (`attendance.dart`)**:
  - Protected the absent (`غائب`) action with `isTrialExpired()` gating matching the present (`حاضر`) button, ensuring robust read-only protection when access expires.
- **Premium Feature Gatekeeping (PDF & Cloud Backup & Financial Settlements)**:
  - Protected PDF Export (`reports_view.dart`) so that generating report PDFs prompts non-subscribers to subscribe.
  - Protected manual Google Drive Backup and Auto-Sync toggle (`backup_view.dart`) while keeping backup restoration open so users never lose previously backed up data.
  - Protected Cash Advance (`draw_money.dart`) and Weekly Account Settlement (`week_status.dart`) to enforce read-only historical viewing mode upon expiration.
- **Smart Expiration Banner on Home View (`TrialExpiredBanner`, `home_view.dart`)**:
  - Created standalone `TrialExpiredBanner` component displayed at the top of `HomeView` when trial/subscription expires.
  - Reassures the user that their data is safely preserved in read-only mode and provides a direct one-tap renewal button.

## [2026-08-27] 14-Day Full Unlimited Free Trial Model (Play Store)
- **Time-Based Free Trial Architecture (`SecureStorageHelper`, `AppConfig`)**:
  - Implemented 14-day full unrestricted trial model (`trialDurationDays = 14`).
  - Recorded encrypted first launch timestamp (`sec_trial_start_date`) in hardware-backed `FlutterSecureStorage`.
  - Added real-time remaining trial days calculator (`getRemainingTrialDays()`) and expiration detection (`isTrialExpired()`).
  - Removed artificial limits during trial: users enjoy **unlimited workers, unlimited attendance records, unlimited notes, and full PDF export** during their first 14 days.
- **Trial Expiration & Soft-Gating Protection**:
  - After day 14 (if not subscribed): adding new workers, attendance, or notes triggers an elegant paywall Flushbar prompting subscription upgrade.
  - Existing worker records, attendance history, notes, and PDF exports remain **100% accessible (Read-Only)** to protect user data.
- **Dynamic Trial Countdown in Drawer (`PurchaseDrawer`, `main_drawer.dart`)**:
  - Added live countdown badge in Drawer menu displaying `"متبقي X يوم"` in Amber or `"انتهت التجربة 🔒"` / `"نشط ⭐"`.

## [2026-08-27] Google Play In-App Purchases & Subscriptions Integration
- **Google Play Billing Service (`InAppPurchaseService`, `lib/core/services/in_app_purchase_service.dart`)**:
  - Integrated `in_app_purchase: ^3.3.0` for full Google Play Billing subscription lifecycle management.
  - Implemented continuous listening to `purchaseStream`, purchase verification, and auto-completion (`completePurchase`).
  - Added full restore purchases support (`restorePurchases()`) with 4-second timeout protection and availability checks to prevent infinite spinner when no previous purchases exist.
  - Secured subscription persistence in `SecureStorageHelper` (`sec_active_subscription_id`, `sec_is_exist`, `sec_is_trial`).
- **Legal Compliance & Privacy Assets (`privacy_policy.html`, `terms_of_service.html`)**:
  - Created standalone `terms_of_service.html` covering 14-day trial, auto-renewing subscriptions, cancellation rules, and offline data storage.
  - Connected live Google Sites URLs (`https://sites.google.com/view/ommali-privacy/home` & `terms`) inside `PlayStorePaywall`.
- **Subscription State Management (`PurchaseViewModel`, `lib/view_models/purchase_view_model.dart`)**:
  - Added multi-tier plan management (Monthly, 3-Month, 6-Month, 1-Year).
  - Implemented live price resolution with currency localization from Google Play with offline fallback.
- **Paywall Presentation Layer (`PlayStorePaywall`, `SubscriptionPlanCard`, `PurchaseApp`)**:
  - Created brand-aligned paywall with feature benefits checklist, tier cards, discount badges, and Google Play purchase button.
  - Added required Google Play legal links (Privacy Policy & Terms of Service).
  - Configured Android BILLING permission in `AndroidManifest.xml`.

## [2026-08-24] Fixed Responsive Attendance Table Layout (No Horizontal Scroll)
- **Fixed Responsive Table Architecture (`lib/views/users/components/slid_bottom_sheet/table/`)**:
  - Implemented exact proportional column distribution using `FlexColumnWidth` for all 7 columns (`اليوم`, `التاريخ`, `التمام`, `السهرة`, `اليومية`, `مكان العمل`, `المسحوب`).
  - Wrapped header titles and row values with `FittedBox(fit: BoxFit.scaleDown)` to ensure typography auto-scales cleanly on narrow mobile viewports without horizontal scrolling or text clipping.
  - Eliminated `InteractiveViewer` and horizontal scrollbars, keeping the card fully fixed, aligned, and clean.

## [2026-08-24] Keyboard Inset Spacing Fix in Worker Edit / Add Sheet
- **Bottom Sheet Inset Optimization (`lib/views/home/components/bottom_sheet/addingUser_bottomSheet.dart`)**:
  - Removed redundant `MediaQuery.of(context).viewInsets.bottom` padding inside `AddingUserBottomSheet`.
  - Resolved double-padding issue when opening the soft keyboard inside worker add/edit bottom sheets where the Scaffold was already handling `resizeToAvoidBottomInset`.

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
