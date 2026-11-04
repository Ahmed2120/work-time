class WhatsNewItem {
  final String id;
  final String version;
  final String title;
  final String description;
  final String date;
  final String tag;
  final List<String> features;
  final bool isHighlight;

  WhatsNewItem({
    required this.id,
    required this.version,
    required this.title,
    required this.description,
    required this.date,
    this.tag = 'ميزات جديدة',
    required this.features,
    this.isHighlight = false,
  });

  factory WhatsNewItem.fromMap(String id, Map<dynamic, dynamic> map) {
    List<String> parsedFeatures = [];
    if (map['features'] != null) {
      if (map['features'] is List) {
        parsedFeatures = (map['features'] as List)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (map['features'] is String) {
        parsedFeatures = (map['features'] as String)
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    return WhatsNewItem(
      id: id,
      version: map['version']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      tag: map['tag']?.toString() ?? 'ميزات جديدة',
      features: parsedFeatures,
      isHighlight: map['isHighlight'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'version': version,
      'title': title,
      'description': description,
      'date': date,
      'tag': tag,
      'features': features,
      'isHighlight': isHighlight,
    };
  }
}

