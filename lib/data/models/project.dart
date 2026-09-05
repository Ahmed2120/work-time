class Project {
  final int? id;
  final String name;
  final double? budgetAmount; // ميزانية تقديرية اختيارية
  final String status; // 'active' | 'completed'
  final String createdAt;

  Project({
    this.id,
    required this.name,
    this.budgetAmount,
    this.status = 'active',
    required this.createdAt,
  });

  Project.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        budgetAmount = res['budgetAmount'] != null
            ? (res['budgetAmount'] as num).toDouble()
            : null,
        status = res['status'] ?? 'active',
        createdAt = res['createdAt'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'budgetAmount': budgetAmount,
      'status': status,
      'createdAt': createdAt,
    };
  }

  Project copyWith({
    int? id,
    String? name,
    double? budgetAmount,
    String? status,
    String? createdAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
