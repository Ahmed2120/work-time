import 'package:flutter/material.dart';
import 'package:work_time/core/services/service_locator.dart';
import 'package:work_time/data/models/project.dart';
import 'package:work_time/data/models/project_stats.dart';
import 'package:work_time/data/repositories/i_project_repository.dart';

class ProjectViewModel with ChangeNotifier {
  final IProjectRepository _repository;

  ProjectViewModel({IProjectRepository? repository})
      : _repository = repository ?? sl<IProjectRepository>();

  List<Project> _projects = [];
  List<Project> get projects => _projects;

  List<Project> get activeProjects =>
      _projects.where((p) => p.status == 'active').toList();

  List<Project> get completedProjects =>
      _projects.where((p) => p.status == 'completed').toList();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Cache of stats per project name
  final Map<String, ProjectStats> _statsCache = {};

  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();
    _projects = await _repository.retrieveAll();
    _statsCache.clear();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProject(Project project) async {
    final id = await _repository.insert(project);
    _projects.insert(0, project.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateProject(Project project) async {
    await _repository.update(project);
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      _statsCache.remove(project.name);
      notifyListeners();
    }
  }

  Future<void> deleteProject(int id) async {
    await _repository.delete(id);
    _projects.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  /// Returns cached stats or fetches from DB
  Future<ProjectStats> getStats(String projectName) async {
    if (_statsCache.containsKey(projectName)) {
      return _statsCache[projectName]!;
    }
    final stats = await _repository.getProjectStats(projectName);
    _statsCache[projectName] = stats;
    return stats;
  }

  void clearStatsCache() => _statsCache.clear();
}
