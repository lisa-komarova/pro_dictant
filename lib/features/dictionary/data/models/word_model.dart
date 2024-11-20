import '../../domain/entities/word_entity.dart';

const String tableWords = 'word';

class WordsFields {
  static final List<String> values = [
    id,
    source,
    pos,
    transcription,
  ];

  static const String id = 'id';
  static const String source = 'source';
  static const String pos = 'pos';
  static const String transcription = 'transcription';
}

class WordModel extends WordEntity {
  WordModel({
    required id,
    required source,
    required pos,
    required transcription,
  }) : super(
          id: id,
          source: source,
          pos: pos,
          transcription: transcription,
        );

  Map<String, Object?> toJson() => {
        WordsFields.id: id,
        WordsFields.source: source,
        WordsFields.pos: pos,
        WordsFields.transcription: transcription,
      };

  static WordModel fromJson(Map<String, Object?> json) => WordModel(
        id: json[WordsFields.id] as String,
        source: json[WordsFields.source] as String,
        pos: json[WordsFields.pos] as String,
        transcription: json[WordsFields.transcription] as String,
      );

  @override
  List<Object?> get props => [
        id,
        source,
        pos,
        transcription,
        translationList,
      ];
}
