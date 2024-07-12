import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';

const String tableSets = 'set';

class SetFields {
  static final List<String> values = [
    setId,
    setName,
  ];

  static const String setId = 'id';
  static const String setName = 'name';
}

///tarot card model
class SetModel extends SetEntity {
  SetModel({
    required int id,
    required String name,
  }) : super(
          id: id,
          name: name,
        );

  Map<String, Object?> toJson() => {
        SetFields.setId: id,
        SetFields.setName: name,
      };

  static SetModel fromJson(Map<String, Object?> json) => SetModel(
        id: json[SetFields.setId] as int,
        name: json[SetFields.setName] as String,
        //wordsInSet: [] as List<WordEntity>,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        wordsInSet,
      ];
}
