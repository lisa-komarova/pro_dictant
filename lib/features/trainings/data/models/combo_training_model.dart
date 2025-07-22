import 'package:pro_dictant/features/dictionary/data/models/translation_model.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';

import '../../domain/entities/combo_training_entity.dart';

///tarot card model
class ComboTrainingModel extends ComboTrainingEntity {
  ComboTrainingModel({
    required id,
    required source,
    required translation,
    required wordId,
  }) : super(
          id: id,
          source: source,
          translation: translation,
          wordId: wordId,
        );

  static ComboTrainingModel fromJson(Map<String, Object?> json) =>
      ComboTrainingModel(
          id: json[TranslationFields.id] as String,
          source: json[WordsFields.source] as String,
          translation: json[TranslationFields.translation] as String,
          wordId: json['wordId'] as String);

  @override
  List<Object?> get props => [id, source, translation, wordId];
}
