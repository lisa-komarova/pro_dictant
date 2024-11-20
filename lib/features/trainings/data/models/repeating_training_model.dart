import '../../../dictionary/data/models/translation_model.dart';
import '../../../dictionary/data/models/word_model.dart';
import '../../domain/entities/repeating_entity.dart';

class RepeatingTrainingModel extends RepeatingTrainingEntity {
  const RepeatingTrainingModel({
    required id,
    required source,
  }) : super(
          id: id,
          source: source,
        );

  static RepeatingTrainingModel fromJson(Map<String, Object?> json) =>
      RepeatingTrainingModel(
        id: json[TranslationFields.id] as String,
        source: json[WordsFields.source] as String,
      );

  @override
  List<Object?> get props => [
        id,
        source,
      ];
}
