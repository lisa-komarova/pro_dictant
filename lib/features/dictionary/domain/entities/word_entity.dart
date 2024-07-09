import 'package:equatable/equatable.dart';

class WordEntity extends Equatable {
  final String id;
  String source;
  String pos;
  String transcription;
  String translations;
  int isInDictionary;
  int isTW;
  int isWT;
  int isMatching;
  int isCards;
  int isDictant;
  int isRepeated;

  WordEntity({
    required this.id,
    required this.source,
    required this.pos,
    required this.transcription,
    required this.translations,
    this.isInDictionary = 0,
    this.isTW = 0,
    this.isWT = 0,
    this.isMatching = 0,
    this.isCards = 0,
    this.isDictant = 0,
    this.isRepeated = 0,
  });

  WordEntity copy({
    String? id,
    String? source,
    String? pos,
    String? transcription,
    String? translations,
    int? isInDictionary,
    int? isTW,
    int? isWT,
    int? isMatching,
    int? isCards,
    int? isDictant,
    int? isRepeated,
  }) =>
      WordEntity(
        id: id ?? this.id,
        source: source ?? this.source,
        pos: pos ?? this.pos,
        transcription: transcription ?? this.transcription,
        translations: translations ?? this.translations,
        isInDictionary: isInDictionary ?? this.isInDictionary,
        isTW: isTW ?? this.isTW,
        isWT: isWT ?? this.isWT,
        isMatching: isMatching ?? this.isMatching,
        isCards: isCards ?? this.isCards,
        isDictant: isDictant ?? this.isDictant,
        isRepeated: isRepeated ?? this.isRepeated,
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
