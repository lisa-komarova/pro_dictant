import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';

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
  SetModel({
    required String id,
    required String name,
    required int isAddedToDictionary,
  }) : super(
          id: id,
          name: name,
          isAddedToDictionary: isAddedToDictionary,
        );

  Map<String, Object?> toJson() => {
        SetFields.setId: id,
        SetFields.setName: name,
        SetFields.isAddedToDictionary: isAddedToDictionary,
      };

  static SetModel fromJson(Map<String, Object?> json) => SetModel(
        id: json[SetFields.setId] as String,
        name: json[SetFields.setName] as String,
        isAddedToDictionary: json[SetFields.isAddedToDictionary] as int,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        wordsInSet,
        isAddedToDictionary,
      ];
}
