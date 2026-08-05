import 'package:pro_dictant/features/dictionary/data/models/translation_model.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';

import '../../domain/entities/combo_training_entity.dart';

///combo training model
class ComboTrainingModel extends ComboTrainingEntity {
  ComboTrainingModel({
    required id,
    required source,
    required partOfSpeech,
    required translation,
    required wordId,
  }) : super(
          id: id,
          source: source,
          partOfSpeech: partOfSpeech,
          translation: translation,
          wordId: wordId,
        );

  static ComboTrainingModel fromJson(Map<String, Object?> json) =>
      ComboTrainingModel(
          id: json[TranslationFields.id] as String,
          source: json[WordsFields.source] as String,
          partOfSpeech: json[WordsFields.pos] as String? ?? '',
          translation: json[TranslationFields.translation] as String,
          wordId: json['wordId'] as String);

  @override
  List<Object?> get props => [id, source, partOfSpeech, translation, wordId];
}
