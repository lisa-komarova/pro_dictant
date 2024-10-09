import 'package:pro_dictant/features/dictionary/data/models/translation_model.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';

import '../../../dictionary/domain/entities/translation_entity.dart';

///tarot card model
class WTTraningModel extends WTTrainingEntity {
  late final List<TranslationEntity> suggestedTranslationList = [];

  WTTraningModel({
    required id,
    required source,
    required translation,
  }) : super(
          id: id,
          source: source,
          translation: translation,
        );

  Map<String, Object?> toJson() => {
        TranslationFields.id: id,
        WordsFields.source: source,
        TranslationFields.translation: translation,
      };

  static WTTraningModel fromJson(Map<String, Object?> json) => WTTraningModel(
        id: json[TranslationFields.id] as String,
        source: json[WordsFields.source] as String,
        translation: json[TranslationFields.translation] as String,
      );

  @override
  List<Object?> get props => [
        id,
        source,
        translation,
        suggestedTranslationList,
      ];
}
