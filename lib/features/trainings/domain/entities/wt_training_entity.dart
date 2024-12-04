import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';

class WTTrainingEntity extends Equatable {
  final String source;
  final String translation;
  final String id;
  final String wordId;
  late final List<TranslationEntity> suggestedTranslationList = [];

  WTTrainingEntity(
      {required this.id,
      required this.wordId,
      required this.source,
      required this.translation});

  @override
  List<Object?> get props => [id, wordId, source, translation];
}
