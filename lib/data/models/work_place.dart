class WorkPlace {
  final int? id;
  final String name;

  WorkPlace({this.id, required this.name});

  WorkPlace.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'];

  Map<String, Object?> toMap() => {'id': id, 'name': name};
}

