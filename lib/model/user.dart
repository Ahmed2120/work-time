class User {
  int? id;
  final String name;
  final String job;
  final String salary;


  User(
      { this.id,
        required this.name,
        required this.job,
        required this.salary,
      });

  User.fromMap(Map<String, dynamic> res)
      : id = res["Id"],
        name = res["name"],
        job = res["job"],
        salary = res["salary"];

  Map<String, Object?> toMap() {
    return {'Id':id,'name': name, 'job': job, 'salary': salary};
  }
}
