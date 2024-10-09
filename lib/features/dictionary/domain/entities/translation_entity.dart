import 'package:equatable/equatable.dart';

class TranslationEntity extends Equatable {
  final String id;
  String wordId;
  String translation;
  String notes;
  int isInDictionary;
  int isTW;
  int isWT;
  int isMatching;
  int isCards;
  int isDictant;
  int isRepeated;
  String dateAddedToDictionary;

  TranslationEntity({
    required this.id,
    required this.wordId,
    required this.translation,
    required this.notes,
    this.isInDictionary = 0,
    this.isTW = 0,
    this.isWT = 0,
    this.isMatching = 0,
    this.isCards = 0,
    this.isDictant = 0,
    this.isRepeated = 0,
    this.dateAddedToDictionary = '',
  });

  TranslationEntity copy({
    String? id,
    String? wordId,
    String? translation,
    String? notes,
    int? isInDictionary,
    int? isTW,
    int? isWT,
    int? isMatching,
    int? isCards,
    int? isDictant,
    int? isRepeated,
    String? dateAddedToDictionary,
  }) =>
      TranslationEntity(
        id: id ?? this.id,
        wordId: wordId ?? this.wordId,
        translation: translation ?? this.translation,
        notes: notes ?? this.notes,
        isInDictionary: isInDictionary ?? this.isInDictionary,
        isTW: isTW ?? this.isTW,
        isWT: isWT ?? this.isWT,
        isMatching: isMatching ?? this.isMatching,
        isCards: isCards ?? this.isCards,
        isDictant: isDictant ?? this.isDictant,
        isRepeated: isRepeated ?? this.isRepeated,
        dateAddedToDictionary:
            dateAddedToDictionary ?? this.dateAddedToDictionary,
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
