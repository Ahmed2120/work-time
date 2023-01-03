class User {
  final int? id;
  final String name;
  final String status;
  final double salary;


  User(
      { this.id,
        required this.name,
        required this.status,
        required this.salary,
      });

  User.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        status = res["status"],
        salary = res["salary"];

  Map<String, Object?> toMap() {
    return {'id':id,'name': name, 'status': status, 'salary': salary};
  }
}