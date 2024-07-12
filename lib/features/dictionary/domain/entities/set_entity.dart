import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';

class SetEntity extends Equatable {
  final int id;
  final String name;
  late final List<WordEntity> wordsInSet = [];

  ///List<WordEntity> wordsInSet;

  SetEntity({
    required this.id,
    required this.name,
  });

  SetEntity copy({
    int? id,
    String? name,
    List<WordEntity>? wordsInSet,
  }) =>
      SetEntity(
        id: id ?? this.id,
        name: name ?? this.name,
      )..wordsInSet.addAll(this.wordsInSet);

  @override
  List<Object?> get props => [
        id,
        name,
        wordsInSet,
      ];
}
