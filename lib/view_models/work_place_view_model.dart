import 'package:flutter/material.dart';
import 'package:work_time/core/services/service_locator.dart';
import 'package:work_time/data/models/work_place.dart';
import 'package:work_time/data/repositories/i_work_place_repository.dart';

class WorkPlaceViewModel with ChangeNotifier {
  final IWorkPlaceRepository _repository;

  WorkPlaceViewModel({IWorkPlaceRepository? repository})
      : _repository = repository ?? sl<IWorkPlaceRepository>();

  List<WorkPlace> _workPlaces = [];
  List<WorkPlace> get workPlaces => _workPlaces;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadWorkPlaces() async {
    _isLoading = true;
    notifyListeners();
    await _repository.seedFromAttendance();
    _workPlaces = await _repository.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addWorkPlace(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;
    if (_workPlaces.any((w) => w.name.toLowerCase() == trimmed.toLowerCase())) {
      return false;
    }
    final id = await _repository.insert(trimmed);
    if (id > 0) {
      _workPlaces.insert(0, WorkPlace(id: id, name: trimmed));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateWorkPlace(WorkPlace wp, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty || wp.id == null || trimmed == wp.name) return false;
    if (_workPlaces.any((w) => w.id != wp.id && w.name.toLowerCase() == trimmed.toLowerCase())) {
      return false;
    }
    await _repository.update(wp.id!, wp.name, trimmed);
    final index = _workPlaces.indexWhere((w) => w.id == wp.id);
    if (index != -1) {
      _workPlaces[index] = WorkPlace(id: wp.id, name: trimmed);
      notifyListeners();
    }
    return true;
  }

  Future<void> deleteWorkPlace(WorkPlace wp) async {
    if (wp.id == null) return;
    await _repository.delete(wp.id!, wp.name);
    _workPlaces.removeWhere((w) => w.id == wp.id);
    notifyListeners();
  }

  List<String> get names => _workPlaces.map((w) => w.name).toList();
}
