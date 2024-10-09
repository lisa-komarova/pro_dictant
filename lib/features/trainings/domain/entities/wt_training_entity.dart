import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';

class WTTrainingEntity extends Equatable {
  final String source;
  final String translation;
  final String id;
  late final List<TranslationEntity> suggestedTranslationList = [];

  WTTrainingEntity(
      {required this.id, required this.source, required this.translation});

  @override
  List<Object?> get props => [id, source, translation];
}
