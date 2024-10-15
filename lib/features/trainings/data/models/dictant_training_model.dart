import 'package:pro_dictant/features/trainings/domain/entities/dictant_training_entity.dart';

import '../../../dictionary/data/models/translation_model.dart';
import '../../../dictionary/data/models/word_model.dart';

class DictantTrainingModel extends DictantTrainingEntity {
  DictantTrainingModel({
    required id,
    required source,
    required translation,
  }) : super(
          id: id,
          source: source,
          translation: translation,
        );

  static DictantTrainingModel fromJson(Map<String, Object?> json) =>
      DictantTrainingModel(
        id: json[TranslationFields.id] as String,
        source: json[WordsFields.source] as String,
        translation: json[TranslationFields.translation] as String,
      );

  @override
  List<Object?> get props => [
        id,
        source,
        translation,
      ];
}
