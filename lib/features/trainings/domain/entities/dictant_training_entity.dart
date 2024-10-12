import 'package:equatable/equatable.dart';

class DictantTrainingEntity extends Equatable {
  final String source;
  final String translation;
  final String id;

  DictantTrainingEntity(
      {required this.id, required this.source, required this.translation});

  @override
  List<Object?> get props => [id, source, translation];
}
