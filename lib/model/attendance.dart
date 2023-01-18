class Attendance {
   final int? id;
  final int userId;
  final String todayDate;
  final int weekId;
  final int weekStatus;
  final int status;
  final String salaryReceived;
  final String workPlace ;

  Attendance({
    this.id,
    required this.userId,
    required this.todayDate,
    required this.weekId,
    required this.weekStatus,
    required this.status,
    required this.salaryReceived,
    required this.workPlace
  });

  Attendance.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        userId = res["userId"],
        todayDate = res["todayDate"],
        weekId=res['weekId'],
  weekStatus=res['weekStatus'],
        status = res["status"],
        salaryReceived = res["salaryReceived"],
   workPlace=res['workPlace'];


  Map<String, Object?> toMap() {
    return {'id': id, 'userId': userId, 'todayDate': todayDate,'weekId':weekId,'weekStatus':weekStatus, 'status': status, 'salaryReceived': salaryReceived,'workPlace':workPlace};
  }
}
