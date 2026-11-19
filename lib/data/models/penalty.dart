class Penalty {
  final int? id;
  final int userId;
  final double amount;
  final String reason;
  final String date;

  Penalty({
    this.id,
    required this.userId,
    required this.amount,
    required this.reason,
    required this.date,
  });

  factory Penalty.fromMap(Map<String, dynamic> map) {
    return Penalty(
      id: map['id'] as int?,
      userId: map['userId'] as int? ?? 0,
      amount: (map['amount'] is num)
          ? (map['amount'] as num).toDouble()
          : (double.tryParse(map['amount']?.toString() ?? '0') ?? 0.0),
      reason: map['reason'] as String? ?? '',
      date: map['date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'amount': amount,
      'reason': reason,
      'date': date,
    };
  }
}
