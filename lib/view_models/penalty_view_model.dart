import 'package:flutter/foundation.dart';
import 'package:work_time/core/services/service_locator.dart';
import 'package:work_time/data/models/penalty.dart';
import 'package:work_time/data/repositories/i_penalty_repository.dart';

class PenaltyViewModel with ChangeNotifier {
  final IPenaltyRepository repository;

  PenaltyViewModel({IPenaltyRepository? repository})
      : repository = repository ?? sl<IPenaltyRepository>();

  List<Penalty> _penalties = [];
  List<Penalty> get penalties => _penalties;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getPenaltiesForUser(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _penalties = await repository.retrieveByUserId(userId);
    } catch (e) {
      debugPrint("Error fetching penalties for user $userId: $e");
      _penalties = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> addPenalty(Penalty penalty) async {
    final id = await repository.insert(penalty);
    if (id > 0) {
      await getPenaltiesForUser(penalty.userId);
    }
    return id;
  }

  Future<void> deletePenalty(int id, int userId) async {
    await repository.delete(id);
    await getPenaltiesForUser(userId);
  }

  double getTotalPenalties() {
    return _penalties.fold<double>(0.0, (sum, p) => sum + p.amount);
  }

  double getTotalPenaltiesForMonth(String monthFilter) {
    return _penalties
        .where((p) => p.date.contains(monthFilter))
        .fold<double>(0.0, (sum, p) => sum + p.amount);
  }
}
