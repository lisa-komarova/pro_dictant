import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';

import '../../domain/entities/word_entity.dart';

const String tableSets = 'set';

class SetFields {
  static final List<String> values = [
    setId,
    setName,
    isAddedToDictionary,
  ];

  static const String setId = 'id';
  static const String setName = 'name';
  static const String isAddedToDictionary = 'isAddedToDictionary';
}
class SetModel extends SetEntity {
  const SetModel({
    required super.id,
    required super.name,
    required super.isAddedToDictionary,
    required super.wordsInSet,
  });

  Map<String, Object?> toJson() => {
    SetFields.setId: id,
    SetFields.setName: name,
    SetFields.isAddedToDictionary: isAddedToDictionary,
  };

  static SetModel fromJson(Map<String, Object?> json) => SetModel(
    id: json[SetFields.setId] as String,
    name: json[SetFields.setName] as String,
    isAddedToDictionary: json[SetFields.isAddedToDictionary] as int,
    wordsInSet: const [],
  );

  SetModel copyWith({
    String? id,
    String? name,
    int? isAddedToDictionary,
    List<WordEntity>? wordsInSet,
  }) =>
      SetModel(
        id: id ?? this.id,
        name: name ?? this.name,
        isAddedToDictionary: isAddedToDictionary ?? this.isAddedToDictionary,
        wordsInSet: wordsInSet ?? this.wordsInSet,
      );

  @override
  List<Object?> get props => [id, name, wordsInSet, isAddedToDictionary];
}
