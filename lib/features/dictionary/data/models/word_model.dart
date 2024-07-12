import '../../domain/entities/word_entity.dart';

const String tableWords = 'word';

class WordsFields {
  static final List<String> values = [
    id,
    source,
    pos,
    transcription,
    translations,
    isInDictionary,
    isTW,
    isWT,
    isMatching,
    isCards,
    isDictant,
    isRepeated
  ];

  static const String id = 'id';
  static const String source = 'source';
  static const String pos = 'pos';
  static const String transcription = 'transcription';
  static const String translations = 'translations';
  static const String isInDictionary = 'isInDictionary';
  static const String isTW = 'isTW';
  static const String isWT = 'isWT';
  static const String isMatching = 'isMatching';
  static const String isCards = 'isCards';
  static const String isDictant = 'isDictant';
  static const String isRepeated = 'isRepeated';
}

///tarot card model
class WordModel extends WordEntity {
  WordModel({
    required id,
    required source,
    required pos,
    required transcription,
    required translations,
    isInDictionary = 0,
    isTW = 0,
    isWT = 0,
    isMatching = 0,
    isCards = 0,
    isDictant = 0,
    isRepeated = 0,
  }) : super(
          id: id,
          source: source,
          pos: pos,
          transcription: transcription,
          translations: translations,
          isInDictionary: isInDictionary,
          isTW: isTW,
          isWT: isWT,
          isMatching: isMatching,
          isCards: isCards,
          isDictant: isDictant,
          isRepeated: isRepeated,
        );

  Map<String, Object?> toJson() => {
        WordsFields.id: id,
        WordsFields.source: source,
        WordsFields.pos: pos,
        WordsFields.transcription: transcription,
        WordsFields.translations: translations,
        WordsFields.isInDictionary: isInDictionary,
        WordsFields.isTW: isTW,
        WordsFields.isWT: isWT,
        WordsFields.isMatching: isMatching,
        WordsFields.isCards: isCards,
        WordsFields.isDictant: isDictant,
        WordsFields.isRepeated: isRepeated,
      };

//TODO: redo parsinf according to yandex api docs
  static WordModel fromJson(Map<String, Object?> json) => WordModel(
        id: json[WordsFields.id] as String,
        source: json[WordsFields.source] as String,
        pos: json[WordsFields.pos] as String,
        transcription: json[WordsFields.transcription] as String,
        translations: json[WordsFields.translations] as String,
        isInDictionary: json[WordsFields.isInDictionary] as int,
        isTW: json[WordsFields.isTW] as int,
        isWT: json[WordsFields.isWT] as int,
        isMatching: json[WordsFields.isMatching] as int,
        isCards: json[WordsFields.isCards] as int,
        isDictant: json[WordsFields.isDictant] as int,
        isRepeated: json[WordsFields.isRepeated] as int,
      );

  @override
  List<Object?> get props => [
        id,
        source,
        pos,
        transcription,
        translations,
        isInDictionary,
        isTW,
        isWT,
        isMatching,
        isCards,
        isDictant,
        isRepeated
      ];
}
