import '../../../dictionary/data/models/translation_model.dart';
import '../../../dictionary/data/models/word_model.dart';
import '../../domain/entities/cards_training_entity.dart';

class CardsTrainingModel extends CardsTrainingEntity {
  const CardsTrainingModel(
      {required id,
      required source,
      required translation,
      required wrongTranslation})
      : super(
            id: id,
            source: source,
            translation: translation,
            wrongTranslation: wrongTranslation);

  static CardsTrainingModel fromJson(Map<String, Object?> json) =>
      CardsTrainingModel(
        id: json[TranslationFields.id] as String,
        source: json[WordsFields.source] as String,
        translation: json[TranslationFields.translation] as String,
        wrongTranslation: json['wrong_translation'] as String,
      );

  @override
  List<Object?> get props => [id, source, translation, wrongTranslation];
}
