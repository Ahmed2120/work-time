/// إحصاءات مالية مجمّعة لمشروع/موقع عمل واحد
/// مستخرجة من جدول attendance عبر workPlace
class ProjectStats {
  final String projectName;
  final double totalWages;     // إجمالي اليوميات (salary)
  final double totalAdvances;  // إجمالي السلف (salaryReceived)
  final int totalDays;         // عدد أيام الحضور
  final Set<int> workerIds;    // معرّفات العمال الذين عملوا في هذا الموقع

  const ProjectStats({
    required this.projectName,
    required this.totalWages,
    required this.totalAdvances,
    required this.totalDays,
    required this.workerIds,
  });

  double get totalSpent => totalWages + totalAdvances;

  int get uniqueWorkersCount => workerIds.length;

  double budgetUsagePercent(double budget) {
    if (budget <= 0) return 0;
    return (totalSpent / budget).clamp(0.0, 1.0);
  }
}
