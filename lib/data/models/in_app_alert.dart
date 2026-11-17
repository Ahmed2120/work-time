/// Model representing an In-App Alert or Message sent from the Admin Dashboard / Firebase.
class InAppAlert {
  final String id;
  final String title;
  final String message;
  final String type; // 'info', 'success', 'warning', 'feature'
  final String? actionText;
  final String? actionUrl;
  final bool isRead;
  final String? readAt;
  final String? createdAt;
  final bool isBroadcast;

  const InAppAlert({
    required this.id,
    required this.title,
    required this.message,
    this.type = 'info',
    this.actionText,
    this.actionUrl,
    this.isRead = false,
    this.readAt,
    this.createdAt,
    this.isBroadcast = false,
  });

  factory InAppAlert.fromMap(String id, Map<dynamic, dynamic> map, {bool isBroadcast = false}) {
    return InAppAlert(
      id: id,
      title: (map['title'] ?? '').toString().trim(),
      message: (map['message'] ?? '').toString().trim(),
      type: (map['type'] ?? 'info').toString().toLowerCase().trim(),
      actionText: map['actionText']?.toString().trim(),
      actionUrl: map['actionUrl']?.toString().trim(),
      isRead: map['isRead'] == true,
      readAt: map['readAt']?.toString(),
      createdAt: map['createdAt']?.toString(),
      isBroadcast: isBroadcast,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      if (actionText != null) 'actionText': actionText,
      if (actionUrl != null) 'actionUrl': actionUrl,
      'isRead': isRead,
      if (readAt != null) 'readAt': readAt,
      if (createdAt != null) 'createdAt': createdAt,
      'isBroadcast': isBroadcast,
    };
  }
}
