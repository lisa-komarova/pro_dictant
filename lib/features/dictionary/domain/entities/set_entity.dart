import 'package:equatable/equatable.dart';

class SetEntity extends Equatable {
  final int id;
  String name;

  ///List<WordEntity> wordsInSet;

  SetEntity({
    required this.id,
    required this.name,
    //required this.wordsInSet,
  });

  SetEntity copy({
    int? id,
    String? name,
    // List<WordEntity>? wordsInSet,
  }) =>
      SetEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        //wordsInSet: wordsInSet ?? this.wordsInSet,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        // wordsInSet,
      ];
}
