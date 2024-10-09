import 'package:equatable/equatable.dart';

class MatchingTrainingEntity extends Equatable {
  final String translation;
  final String source;
  final String id;

  MatchingTrainingEntity(
      {required this.id, required this.source, required this.translation});

  @override
  List<Object?> get props => [id, source, translation];
}
