# GC Optimization & Jank Elimination — Work Time Project Analysis

> **Purpose:** مرجع شخصي لمراجعته قبل أي Interview.
> يوثّق كل مشكلة حقيقية في المشروع مع الكود الأصلي، سبب المشكلة، والحل الصحيح.

---

## 📖 المفاهيم بإيجاز

| المصطلح | المعنى |
|---|---|
| **GC (Garbage Collector)** | الجزء من Dart VM المسؤول عن حذف الـ Objects من الـ Heap لما تبطل تُستخدم |
| **GC Pressure** | لما بنعمل Objects كتير بسرعة → الـ Heap بيمتلي → الـ GC بيشتغل كتير |
| **GC Pause** | لما الـ GC بيشتغل بيوقف الـ thread مؤقتاً → frames بتتأخر |
| **Jank** | أي frame بياخد أكتر من 16ms (60fps) — المستخدم بيحسه تقطيع |
| **Frame Budget** | كل frame لازم يتعمل في ≤ 16ms (60fps) أو ≤ 8ms (120fps) |

---

## 🔴 PROBLEM 1 — الأخطر: FutureBuilder بيعمل N DB Calls في كل Rebuild

**الملف:** `lib/views/home/home_view.dart` — السطر 86  
**الشدة:** 🔴 Critical  
**النوع:** GC Pressure + Jank

### الكود الأصلي (المشكلة)

```dart
Consumer<AttendanceViewModel>(
  builder: (context, attendProvider, _) {
    return FutureBuilder<List<int>>(
      // ❌ بيُستدعى في كل rebuild من Consumer أو setState
      future: _calculateAttendanceSummary(userViewModel, attendProvider),
      builder: (context, snapshot) { ... },
    );
  },
),

Future<List<int>> _calculateAttendanceSummary(...) async {
  // ❌ N DB calls — واحدة لكل User — في كل rebuild
  for (var user in userViewModel.users) {
    final Attendance? attend =
        await attendanceViewModel.getAttendByUserAndDate(userId: user.id!);
    ...
  }
}
```

### ليه ده مشكلة؟

```
كل rebuild (مثلاً لما يتغير الـ statusFilter)
    → FutureBuilder بيعمل Future جديد
    → _calculateAttendanceSummary بتشتغل من أول
    → لو عندك 50 موظف = 50 DB call
    → 50 Attendance object جديد في الـ Heap
    → GC يشتغل ويعمل pause
    → Frame يتجاوز الـ 16ms → JANK
```

### الحل الصحيح

**الخطوة 1:** أضف cache في `AttendanceViewModel`:

```dart
Map<String, int>? _dailySummaryCache;
DateTime? _summaryCacheDate;

Future<Map<String, int>> getDailySummary(List<User> users) async {
  final today = dateTimeAttendance;

  // ✅ رجّع الـ cache لو نفس اليوم — zero allocations
  if (_dailySummaryCache != null &&
      _summaryCacheDate?.day == today.day &&
      _summaryCacheDate?.month == today.month &&
      _summaryCacheDate?.year == today.year) {
    return _dailySummaryCache!;
  }

  int present = 0, absent = 0, pending = 0;
  for (var user in users) {
    final attend = await getAttendByUserAndDate(userId: user.id!);
    if (attend == null) pending++;
    else if (attend.status == 1) present++;
    else absent++;
  }

  _dailySummaryCache = {'present': present, 'absent': absent, 'pending': pending};
  _summaryCacheDate = today;
  return _dailySummaryCache!;
}

void changeDate(DateTime? dateTime) {
  if (dateTime == null) return;
  dateTimeAttendance = dateTime;
  _dailySummaryCache = null; // ← إعادة حساب بتاريخ جديد
  _summaryCacheDate = null;
  notifyListeners();
}
```

**الخطوة 2:** استخدمه في `home_view.dart`:

```dart
FutureBuilder<Map<String, int>>(
  future: attendProvider.getDailySummary(userViewModel.users),
  builder: (context, snapshot) {
    final presentCount = snapshot.data?['present'] ?? 0;
    final absentCount  = snapshot.data?['absent']  ?? 0;
    final pendingCount = snapshot.data?['pending']  ?? 0;
    ...
  },
),
```

**النتيجة:** من N DB calls في كل rebuild → 0 calls (Cache hit) في الـ rebuild التالية ✅

---

## 🔴 PROBLEM 2 — FutureBuilder في كل Row داخل ListView

**الملف:** `lib/views/home/components/users_status_listview.dart` — السطر 206  
**الشدة:** 🔴 Critical  
**النوع:** GC Pressure + Jank أثناء Scroll

### الكود الأصلي (المشكلة)

```dart
// ❌ هنا في كل Card داخل ListView فيه FutureBuilder مستقل
FutureBuilder<Attendance?>(
  future: attendProvider.getAttendByUserAndDate(userId: user.id!),
  builder: (context, statusSnapshot) {
    final title = statusSnapshot.data == null
        ? 'لم يسجل'
        : statusSnapshot.data!.status == 1 ? 'حاضر' : 'غائب';
    return CustomStatusText(title);
  },
),
```

### ليه ده مشكلة؟

```
ListView.builder عنده 50 user
    → كل item فيه FutureBuilder
    → لما تـ scroll → بيعمل 50 DB call بالتوازي
    → 50 Future object + 50 Attendance? object في الـ Heap
    → GC pressure شديد أثناء الـ scroll
    → dropped frames → JANK واضح للمستخدم
```

### الحل الصحيح

```dart
// في attendance_view_model.dart
Map<int, Attendance?> _todayAttendanceMap = {};

Future<void> loadTodayAttendanceMap(List<int> userIds) async {
  // DB call واحدة بس لكل الـ users
  final allToday = await attendanceRepository.retrieveAllByDate(dateTimeAttendance);
  _todayAttendanceMap = {for (var a in allToday) a.userId: a};
  for (var id in userIds) {
    _todayAttendanceMap.putIfAbsent(id, () => null);
  }
  notifyListeners();
}

Attendance? getAttendanceFromCache(int userId) {
  return _todayAttendanceMap[userId]; // ← O(1) — بدون DB call
}

// في users_status_listview.dart
// ✅ بدل FutureBuilder → قراءة مباشرة
final attend = attendProvider.getAttendanceFromCache(user.id!);
final title = attend == null ? 'لم يسجل'
    : attend.status == 1 ? 'حاضر' : 'غائب';
return CustomStatusText(title);
```

**النتيجة:** من 50 DB call أثناء الـ scroll → DB call واحدة عند التحميل ✅

---

## 🟠 PROBLEM 3 — Computed Getters بيعملوا List جديدة في كل Call

**الملف:** `lib/view_models/project_view_model.dart` — السطر 16-20  
**الشدة:** 🟠 High  
**النوع:** GC Pressure عند الـ Rendering

### الكود الأصلي (المشكلة)

```dart
List<Project> get activeProjects =>
    _projects.where((p) => p.status == 'active').toList(); // ❌ List جديدة في كل call

List<Project> get completedProjects =>
    _projects.where((p) => p.status == 'completed').toList(); // ❌ List جديدة في كل call
```

### ليه ده مشكلة؟

```
projects_view.dart بيقرا activeProjects في الـ build method
    → كل build → getter call → .toList() بيعمل List جديدة في الـ Heap
    → الـ List القديمة مش بتُستخدم → GC يشيلها
    → لو الـ UI بيـ rebuild كتير = allocations متكررة
```

### الحل الصحيح

```dart
List<Project> _activeProjects = [];
List<Project> _completedProjects = [];

// ✅ Getters بيرجعوا reference لنفس الـ List — zero allocation
List<Project> get activeProjects => _activeProjects;
List<Project> get completedProjects => _completedProjects;

void _updateCachedFilters() {
  _activeProjects    = _projects.where((p) => p.status == 'active').toList();
  _completedProjects = _projects.where((p) => p.status == 'completed').toList();
}

// نستدعي _updateCachedFilters بعد أي تغيير في _projects فقط
Future<void> loadProjects() async {
  _isLoading = true;
  notifyListeners();
  _projects = await _repository.retrieveAll();
  _statsCache.clear();
  _updateCachedFilters(); // ← هنا بس
  _isLoading = false;
  notifyListeners();
}
```

---

## 🟠 PROBLEM 4 — Nested FutureBuilders في الـ Trial Banner

**الملف:** `lib/views/home/components/trial_expired_banner.dart` — السطر 14-20  
**الشدة:** 🟠 High  
**النوع:** GC Pressure + Unnecessary Async Work في كل Rebuild

### الكود الأصلي (المشكلة)

```dart
// ❌ Async call في كل rebuild
return FutureBuilder<bool>(
  future: SecureStorageHelper.isTrialExpired(),
  builder: (context, snapshot) {
    return FutureBuilder<bool>(
      future: SecureStorageHelper.wasSubscribedBefore(), // ❌ Async call تاني!
      builder: (context, subSnapshot) { ... },
    );
  },
);
```

### ليه ده مشكلة؟

```
HomeView بتـ rebuild مثلاً لما يتغير الـ filter
    → TrialExpiredBanner بتـ rebuild
    → FutureBuilder بيعمل 2 Async calls لكل rebuild
    → SecureStorage read في كل rebuild = I/O overhead
    → Future objects في الـ Heap = GC pressure
```

### الحل الصحيح

```dart
// ✅ StatefulWidget — بتقرأ الـ values مرة واحدة في initState
class _TrialExpiredBannerState extends State<TrialExpiredBanner> {
  bool _isExpired = false;
  bool _wasSubscribed = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadStatus(); // ← Async call مرة واحدة بس
  }

  Future<void> _loadStatus() async {
    final expired    = await SecureStorageHelper.isTrialExpired();
    final subscribed = await SecureStorageHelper.wasSubscribedBefore();
    if (mounted) {
      setState(() {
        _isExpired     = expired;
        _wasSubscribed = subscribed;
        _loaded        = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ لا FutureBuilders — مجرد قراءة من الـ State
    if (!_loaded || !_isExpired) return const SizedBox.shrink();
    ...
  }
}
```

---

## 🟠 PROBLEM 5 — searchResults Getter بيعمل List + Strings جديدة في كل Call

**الملف:** `lib/view_models/user_view_model.dart` — السطر 99-107  
**الشدة:** 🟠 Medium-High  
**النوع:** GC Pressure أثناء البحث

### الكود الأصلي (المشكلة)

```dart
List<User> get searchResults {
  if (_searchQuery.trim().isEmpty) return _allUsers;
  final query = _searchQuery.trim().toLowerCase(); // ❌ String جديدة في كل call
  return _allUsers.where((element) {
    final nameMatch = element.name.toLowerCase().contains(query); // ❌ String × N
    final jobMatch  = element.job.toLowerCase().contains(query);  // ❌ String × N
    return nameMatch || jobMatch;
  }).toList(); // ❌ List جديدة في الـ Heap
}
```

### ليه ده مشكلة؟

```
المستخدم بيكتب في Search Bar
    → كل حرف → setSearchQuery → notifyListeners → rebuild
    → searchResults getter بيُستدعى في كل rebuild
    → بيعمل: 1 String (query) + N×2 Strings (lowercase) + 1 List
    → GC بيشتغل أثناء الكتابة → تأخر في الـ keyboard response
```

### الحل الصحيح

```dart
List<User> _searchResults = [];
List<User> get searchResults => _searchResults; // ✅ zero allocation

void setSearchQuery(String query) {
  _searchQuery = query;
  _updateSearchResults(); // ← بنحسب مرة وبنخزّن
  notifyListeners();
}

void _updateSearchResults() {
  if (_searchQuery.trim().isEmpty) {
    _searchResults = _allUsers;
    return;
  }
  final query = _searchQuery.trim().toLowerCase(); // ← مرة واحدة بس
  _searchResults = _allUsers.where((u) {
    return u.name.toLowerCase().contains(query) ||
           u.job.toLowerCase().contains(query);
  }).toList();
}
```

---

## 🟡 PROBLEM 6 — weekAttendanceMap + Sort في كل Getter Call

**الملف:** `lib/view_models/attendance_view_model.dart` — السطر 130-158  
**الشدة:** 🟡 Medium  
**النوع:** GC Pressure + CPU Waste

### الكود الأصلي (المشكلة)

```dart
// ❌ بيعمل Map جديدة + sort في كل getter call
Map<int, List<Attendance>> get weekAttendanceMap {
  final Map<int, List<Attendance>> map = {}; // ← Object جديد في كل call
  for (var attendance in _weeklyAttendance) {
    map.putIfAbsent(attendance.weekId, () => []); // ← List جديدة لكل week
    map[attendance.weekId]!.add(attendance);
  }
  for (final key in map.keys) {
    map[key]!.sort((a, b) { ... }); // ← Sort في كل call
  }
  return map;
}

// ❌ بيستدعي weekAttendanceMap (بيعمل Map جديدة) + sort تاني
List<List<Attendance>> get sortedWeekGroups {
  final map    = weekAttendanceMap;       // ← Map جديدة
  final groups = map.values.toList();     // ← List جديدة
  groups.sort((a, b) { ... });
  return groups;
}
```

### الحل الصحيح

```dart
Map<int, List<Attendance>>? _cachedWeekMap;
List<List<Attendance>>? _cachedSortedGroups;

Map<int, List<Attendance>> get weekAttendanceMap  => _cachedWeekMap ?? {};
List<List<Attendance>>     get sortedWeekGroups   => _cachedSortedGroups ?? [];

void _buildWeekCache() {
  final map = <int, List<Attendance>>{};
  for (var a in _weeklyAttendance) {
    map.putIfAbsent(a.weekId, () => []).add(a);
  }
  for (final key in map.keys) {
    map[key]!.sort((a, b) {
      final da = DateTime.tryParse(a.todayDate) ?? DateTime.now();
      final db = DateTime.tryParse(b.todayDate) ?? DateTime.now();
      return da.compareTo(db);
    });
  }
  _cachedWeekMap = map;

  final groups = map.values.toList();
  groups.sort((a, b) {
    final da = DateTime.tryParse(a.first.weekEnd) ?? DateTime.now();
    final db = DateTime.tryParse(b.first.weekEnd) ?? DateTime.now();
    return da.compareTo(db);
  });
  _cachedSortedGroups = groups;
}

Future<void> getWeeklyAttendance(int userId) async {
  _weeklyAttendance = await attendanceRepository.retrieveByUserId(userId);
  _buildWeekCache(); // ← بنبني الـ cache هنا بس
  notifyListeners();
}
```

---

## 🟡 PROBLEM 7 — String Micro-Allocations في ListView Items

**الملفات:** `users_status_listview.dart` S128 + `project_worker_tile.dart` S23  
**الشدة:** 🟡 Low-Medium  
**النوع:** Micro-allocations في ListView

### الكود الأصلي (المشكلة)

```dart
// users_status_listview.dart
final String firstLetter =
    user.name.isNotEmpty ? user.name.trim()[0].toUpperCase() : '?';
//                                ^^^^^^ String جديدة في كل بناء للـ card

// project_worker_tile.dart
final initialLetter = worker.name.trim().isNotEmpty // ← trim() مرة
    ? worker.name.trim().substring(0, 1).toUpperCase() // ← trim() مرة تانية
    : 'ع';
```

### الحل الصحيح

```dart
// ✅ trim() مرة واحدة بس
final trimmedName = user.name.trim();
final String firstLetter = trimmedName.isNotEmpty ? trimmedName[0].toUpperCase() : '?';

// ✅ أحسن: computed property في Model
// في user.dart:
String get firstLetter {
  final t = name.trim();
  return t.isNotEmpty ? t[0].toUpperCase() : '?';
}
```

---

## ✅ ما هو صح في المشروع (نقاطك القوية)

| الممارسة | الملف | ليه صح |
|---|---|---|
| `const` Widgets في كل مكان | `project_worker_tile.dart`, `users_status_listview.dart` | مش بتعمل Objects جديدة في كل rebuild |
| Stats Cache في ProjectViewModel | `project_view_model.dart` L26 | بيعيد استخدام نفس `ProjectStats` بدل ما يعملها من جديد |
| `dispose()` صحيح للـ Controllers | `add_project_sheet.dart` L43 | بيحرر الـ Heap من الـ Controllers اللي مش محتاجهم |
| `SliverChildBuilderDelegate` | `projects_view.dart` L210 | Lazy building — بيبني اللي على الشاشة بس |
| `addPostFrameCallback` | `reports_view.dart` L22 | بيحمي الـ first frame من الـ async load |
| `BouncingScrollPhysics` | في كل الـ Lists | أخف وأسلس من `ClampingScrollPhysics` |

---

## 📊 ملخص المشاكل بالأولوية

| # | الملف | المشكلة | الشدة |
|---|---|---|---|
| 1 | `home_view.dart` | N DB calls في كل rebuild | 🔴 Critical |
| 2 | `users_status_listview.dart` | FutureBuilder في كل ListView item | 🔴 Critical |
| 3 | `project_view_model.dart` | Computed getters تعمل List في كل call | 🟠 High |
| 4 | `trial_expired_banner.dart` | Nested FutureBuilders في كل rebuild | 🟠 High |
| 5 | `user_view_model.dart` | searchResults getter يعمل list+strings | 🟠 Medium |
| 6 | `attendance_view_model.dart` | weekAttendanceMap + Sort في كل getter | 🟡 Medium |
| 7 | `users_status_listview.dart` | String micro-allocations في كل item | 🟡 Low |

---

## 🗣️ جُمَل جاهزة للـ Interview

**سؤال: "إيه هو GC Optimization؟"**
> "GC Optimization معناها إني بقلل عدد الـ Objects اللي بتتعمل وبتتشال من الـ Memory أثناء الـ rendering. ده بعمله بـ Caching النتائج بدل إعادة حسابها، واستخدام `const` للـ Widgets الثابتة، وتجنب الـ allocations في الـ build methods."

**سؤال: "إيه هو Jank وإزاي بتحله؟"**
> "Jank هو لما frame بياخد أكتر من 16ms — المستخدم بيحسه تقطيع. السبب الشائع عندي كان وجود `FutureBuilder` داخل `ListView.builder` بيعمل DB call لكل item أثناء الـ scroll. حليته بتحميل كل البيانات مرة واحدة في ViewModel وتخزينها في Map، وبعدين الـ UI بيقرأ منها مباشرة."

**سؤال: "إديني مثال من مشروعك؟"**
> "في `UsersStatusListview`، كل Card كان فيها `FutureBuilder` بيعمل DB call لجيب حالة حضور الموظف. لو عندي 50 موظف، كل scroll كان بيعمل 50 DB call متوازية — ده كان بيعمل GC pressure وجانك واضح. الحل إني خليت الـ ViewModel يجيب حضور كل الموظفين في call واحدة ويخزّنها في `Map<int, Attendance?>`. بعدين كل Card بتقرأ من الـ Map بـ O(1) بدون أي Async."
