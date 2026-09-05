import 'package:flutter/material.dart';
import 'package:iconly_plus/iconly_plus.dart';
import 'package:provider/provider.dart';
import 'package:work_time/data/models/user.dart';
import 'package:work_time/view_models/attendance_view_model.dart';
import 'package:work_time/view_models/user_view_model.dart';
import 'package:work_time/views/components/constant.dart';
import 'package:work_time/views/users/user_detail.dart';

/// بطاقة العامل بتصميم بريميوم أنيق وقابل للنقر
class ProjectWorkerTile extends StatelessWidget {
  final User worker;
  final String projectName;

  const ProjectWorkerTile({
    super.key,
    required this.worker,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    final initialLetter = worker.name.trim().isNotEmpty
        ? worker.name.trim().substring(0, 1).toUpperCase()
        : 'ع';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x040F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (worker.id != null) {
              final userVm = Provider.of<UserViewModel>(context, listen: false);
              final attendVm = Provider.of<AttendanceViewModel>(context, listen: false);
              userVm.setUser(worker);
              attendVm.getWeeks(worker.id!);
              attendVm.getAttendanceUserToDay(userId: worker.id!);
              attendVm.getAttendanceUser(worker.id!);
              push(screen: UserDetail(), context: context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // صورة/حرف العامل في دائرة مربعة زواياها ناعمة
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFED7AA),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initialLetter,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Cairo',
                        color: Color(0xFFEA580C),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // اسم العامل والمهنة والموقع
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Cairo',
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            IconlyLight.work,
                            size: 13,
                            color: Color(0xFFEA580C),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${worker.job.isNotEmpty ? worker.job : "عامل"} • $projectName',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Cairo',
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // سهم الانتقال
                const Icon(
                  IconlyLight.arrowLeft2,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
