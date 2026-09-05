import 'package:work_time/data/models/project.dart';
import 'package:work_time/data/models/project_stats.dart';

abstract class IProjectRepository {
  Future<int> insert(Project project);
  Future<List<Project>> retrieveAll();
  Future<int> update(Project project);
  Future<int> delete(int id);
  Future<ProjectStats> getProjectStats(String projectName);
}
