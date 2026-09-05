import 'package:flutter/foundation.dart';
import 'package:work_time/data/models/project.dart';
import 'package:work_time/data/models/project_stats.dart';
import 'package:work_time/data/repositories/database_handler.dart';
import 'package:work_time/data/repositories/i_project_repository.dart';

class ProjectRepository implements IProjectRepository {
  static const String _table = 'projects';
  static const String _attendanceTable = 'attendance';
  final DatabaseHandler databaseHandler;

  ProjectRepository({DatabaseHandler? handler})
      : databaseHandler = handler ?? DatabaseHandler();

  @override
  Future<int> insert(Project project) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.insert(_table, project.toMap());
    } catch (e) {
      debugPrint('Error inserting project: $e');
      return 0;
    }
  }

  @override
  Future<List<Project>> retrieveAll() async {
    try {
      final db = await databaseHandler.initializeDB();
      final results = await db.query(_table, orderBy: 'createdAt DESC');
      return results.map((e) => Project.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Error retrieving projects: $e');
      return [];
    }
  }

  @override
  Future<int> update(Project project) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.update(_table, project.toMap(),
          where: 'id = ?', whereArgs: [project.id!]);
    } catch (e) {
      debugPrint('Error updating project: $e');
      return 0;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error deleting project: $e');
      return 0;
    }
  }

  /// Aggregates wages, advances, and worker count from attendance table
  /// using the workPlace field — no schema changes needed.
  @override
  Future<ProjectStats> getProjectStats(String projectName) async {
    try {
      final db = await databaseHandler.initializeDB();

      final results = await db.rawQuery(
        '''
        SELECT 
          SUM(CAST(salary AS REAL)) AS totalWages,
          SUM(CAST(salaryReceived AS REAL)) AS totalAdvances,
          COUNT(*) AS totalDays,
          userId
        FROM $_attendanceTable
        WHERE workPlace = ? AND status = 1
        GROUP BY userId
        ''',
        [projectName],
      );

      double totalWages = 0;
      double totalAdvances = 0;
      int totalDays = 0;
      final Set<int> workerIds = {};

      for (final row in results) {
        totalWages += (row['totalWages'] as num? ?? 0).toDouble();
        totalAdvances += (row['totalAdvances'] as num? ?? 0).toDouble();
        totalDays += (row['totalDays'] as int? ?? 0);
        if (row['userId'] != null) {
          workerIds.add(row['userId'] as int);
        }
      }

      return ProjectStats(
        projectName: projectName,
        totalWages: totalWages,
        totalAdvances: totalAdvances,
        totalDays: totalDays,
        workerIds: workerIds,
      );
    } catch (e) {
      debugPrint('Error getting project stats: $e');
      return ProjectStats(
        projectName: projectName,
        totalWages: 0,
        totalAdvances: 0,
        totalDays: 0,
        workerIds: {},
      );
    }
  }
}
