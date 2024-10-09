import 'package:pro_dictant/features/dictionary/data/models/translation_model.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';

import '../../domain/entities/tw_training_entity.dart';

///tarot card model
class TWTraningModel extends TWTrainingEntity {
  late final List<WordEntity> suggestedSourcesList = [];

  TWTraningModel({
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

  static TWTraningModel fromJson(Map<String, Object?> json) => TWTraningModel(
        id: json[TranslationFields.id] as String,
        source: json[WordsFields.source] as String,
        translation: json[TranslationFields.translation] as String,
      );

  @override
  List<Object?> get props => [
        id,
        source,
        translation,
        suggestedSourcesList,
      ];
}
