import 'package:equatable/equatable.dart';

class SetCardInfoEntity extends Equatable {
  final String id;
  final String name;
  final int numberOfWords;

  SetCardInfoEntity(
      {required this.id, required this.name, required this.numberOfWords});

  SetCardInfoEntity copy({
    String? id,
    String? name,
    int? numberOfWords,
  }) =>
      SetCardInfoEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        numberOfWords: numberOfWords ?? this.numberOfWords,
      );

  @override
  List<Object?> get props => [id, name, numberOfWords];
}
