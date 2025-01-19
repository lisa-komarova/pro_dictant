class WordSetModel {
  final String id;
  final String word_id;
  final String set_id;

  WordSetModel({
    required this.id,
    required this.word_id,
    required this.set_id,
  });

  Map<String, Object?> toJson() => {
        'id': id,
        'word_if': word_id,
        'set_id': set_id,
      };

  static WordSetModel fromJson(Map<String, Object?> json) => WordSetModel(
        id: json['id'] == null ? '' : json['id'] as String,
        word_id: json['word_id'] as String,
        set_id: json['set_id'] as String,
      );
}
