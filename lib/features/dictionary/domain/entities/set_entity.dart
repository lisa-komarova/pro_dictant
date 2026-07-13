import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';

class SetEntity extends Equatable {
  final String id;
  final String name;
  final int isAddedToDictionary;
  final List<WordEntity> wordsInSet;

  const SetEntity({
    required this.id,
    required this.name,
    required this.isAddedToDictionary,
    required this.wordsInSet,
  });

  SetEntity copy({
    String? id,
    String? name,
    int? isAddedToDictionary,
    List<WordEntity>? wordsInSet,
  }) =>
      SetEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        isAddedToDictionary: isAddedToDictionary ?? this.isAddedToDictionary,
        wordsInSet: wordsInSet ?? this.wordsInSet,
      );

  @override
  List<Object?> get props => [id, name, wordsInSet, isAddedToDictionary];
}
