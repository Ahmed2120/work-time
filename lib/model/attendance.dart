class Attendance {
   final int? id;
  final int userId;
  final String todayDate;
  final int status;
  final String salaryReceived;

  Attendance({
    this.id,
    required this.userId,
    required this.todayDate,
    required this.status,
    required this.salaryReceived,
  });

  Attendance.fromMap(Map<String, dynamic> res)
      : id = res["Id"],
        userId = res["userId"],
        todayDate = res["todayDate"],
        status = res["status"],
        salaryReceived = res["salaryReceived"];

  Map<String, Object?> toMap() {
    return {'Id': id, 'userId': userId, 'todayDate': todayDate, 'status': status, 'salaryReceived': salaryReceived};
  }
}
