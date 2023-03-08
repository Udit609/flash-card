class CardFields {
  static final List<String> values = [
    id,
    title,
    body,
    color,
    isFavorite,
    creationDate,
    charLength
  ];

  static const String id = 'id';
  static const String title = 'title';
  static const String body = 'body';
  static const String color = 'color';
  static const String isFavorite = 'isFavorite';
  static const String creationDate = 'creationDate';
  static const String charLength = 'charLength';
}

class FlashCard {
  int? id;
  final String title;
  final String body;
  int color;
  int charLength;
  bool isFavorite;
  DateTime creationDate;
  FlashCard({
    this.id,
    required this.title,
    required this.body,
    required this.color,
    required this.charLength,
    required this.isFavorite,
    required this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'color': color,
      'charLength': charLength,
      'isFavorite': isFavorite ? 1 : 0,
      'creationDate': creationDate.toString(),
    };
  }

  static FlashCard fromJson(Map<String, Object?> json) => FlashCard(
        id: json[CardFields.id] as int?,
        title: json[CardFields.title] as String,
        body: json[CardFields.body] as String,
        color: json[CardFields.color] as int,
        charLength: json[CardFields.charLength] as int,
        isFavorite: json[CardFields.isFavorite] == 1,
        creationDate: DateTime.parse(json[CardFields.creationDate] as String),
      );
  Map<String, Object?> toJson() => {
        CardFields.id: id,
        CardFields.title: title,
        CardFields.isFavorite: isFavorite ? 1 : 0,
        CardFields.color: color,
        CardFields.body: body,
        CardFields.creationDate: creationDate.toIso8601String(),
        CardFields.charLength: charLength,
      };

  @override
  String toString() {
    return 'FCardModel(id: $id, title: $title, body: $body, color: $color,charLength: $charLength, $isFavorite,creationDate : $creationDate,)';
  }
}
