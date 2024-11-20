import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';

const String tableTranslations = 'words_translations';

class TranslationFields {
  static final List<String> values = [
    id,
    wordId,
    translation,
    notes,
    isInDictionary,
    isTW,
    isWT,
    isMatching,
    isCards,
    isDictant,
    isRepeated,
    dateAddedToDictionary,
  ];

  static const String id = 'id';
  static const String wordId = 'word_id';
  static const String translation = 'translation';
  static const String notes = 'notes';
  static const String isInDictionary = 'isInDictionary';
  static const String isTW = 'isTW';
  static const String isWT = 'isWT';
  static const String isMatching = 'isMatching';
  static const String isCards = 'isCards';
  static const String isDictant = 'isDictant';
  static const String isRepeated = 'isRepeated';
  static const String dateAddedToDictionary = 'dateAddedToDictionary';
}

class TranslationModel extends TranslationEntity {
  TranslationModel(
      {required id,
      required wordId,
      required translation,
      required notes,
      isInDictionary = 0,
      isTW = 0,
      isWT = 0,
      isMatching = 0,
      isCards = 0,
      isDictant = 0,
      isRepeated = 0,
      dateAddedToDictionary = ''})
      : super(
          id: id,
          wordId: wordId,
          translation: translation,
          notes: notes,
          isInDictionary: isInDictionary,
          isTW: isTW,
          isWT: isWT,
          isMatching: isMatching,
          isCards: isCards,
          isDictant: isDictant,
          isRepeated: isRepeated,
          dateAddedToDictionary: dateAddedToDictionary,
        );

  Map<String, Object?> toJson() => {
        TranslationFields.id: id,
        TranslationFields.wordId: wordId,
        TranslationFields.translation: translation,
        TranslationFields.notes: notes,
        TranslationFields.isInDictionary: isInDictionary,
        TranslationFields.isTW: isTW,
        TranslationFields.isWT: isWT,
        TranslationFields.isMatching: isMatching,
        TranslationFields.isCards: isCards,
        TranslationFields.isDictant: isDictant,
        TranslationFields.isRepeated: isRepeated,
        TranslationFields.dateAddedToDictionary: dateAddedToDictionary,
      };

  static TranslationModel fromJson(Map<String, Object?> json) =>
      TranslationModel(
        id: json[TranslationFields.id] as String,
        wordId: json[TranslationFields.wordId] as String,
        translation: json[TranslationFields.translation] as String,
        notes: json[TranslationFields.notes] as String,
        isInDictionary: json[TranslationFields.isInDictionary] as int,
        isTW: json[TranslationFields.isTW] as int,
        isWT: json[TranslationFields.isWT] as int,
        isMatching: json[TranslationFields.isMatching] as int,
        isCards: json[TranslationFields.isCards] as int,
        isDictant: json[TranslationFields.isDictant] as int,
        isRepeated: json[TranslationFields.isRepeated] as int,
        dateAddedToDictionary:
            json[TranslationFields.dateAddedToDictionary] == null
                ? ''
                : json[TranslationFields.dateAddedToDictionary] as String,
      );

  @override
  List<Object?> get props => [
        id,
        wordId,
        translation,
        notes,
        isInDictionary,
        isTW,
        isWT,
        isMatching,
        isCards,
        isDictant,
        isRepeated,
        dateAddedToDictionary,
      ];
}
