import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';

class WordEntity extends Equatable {
  final String id;
  String source;
  String pos;
  String transcription;
  late final List<TranslationEntity> translationList = [];

  WordEntity({
    required this.id,
    required this.source,
    required this.pos,
    required this.transcription,
  });

  WordEntity copy({
    String? id,
    String? source,
    String? pos,
    String? transcription,
    List<TranslationEntity>? translationList,
  }) =>
      WordEntity(
        id: id ?? this.id,
        source: source ?? this.source,
        pos: pos ?? this.pos,
        transcription: transcription ?? this.transcription,
      )..translationList.addAll(this.translationList);

  @override
  List<Object?> get props => [
        id,
        source,
        pos,
        transcription,
        translationList,
      ];
}
