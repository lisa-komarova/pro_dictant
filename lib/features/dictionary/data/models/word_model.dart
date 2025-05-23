import 'package:pro_dictant/features/dictionary/data/models/translation_model.dart';
import 'package:uuid/uuid.dart';

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

  static WordModel fromRemoteJson(Map<String, Object?> json) {
    String wordId = const Uuid().v4();
    var translationsJson = json['tr'] as List<dynamic>? ?? [];
    var translations = translationsJson
        .map((t) => TranslationModel.fromRemoteJson(t, wordId))
        .toList();

    final word = WordModel(
      id: wordId,
      source: json['text'] as String? ?? '',
      pos: json['pos'] as String? ?? '',
      transcription: json['ts'] as String? ?? '',
    );
    word.translationList.addAll(translations);
    return word;
  }

  @override
  List<Object?> get props => [
        id,
        source,
        pos,
        transcription,
        translationList,
      ];
}
