import 'package:equatable/equatable.dart';

class ComboTrainingEntity extends Equatable {
  final String translation;
  final String source;
  final String id;
  final String wordId;
  ComboTrainingEntity({
    required this.id,
    required this.source,
    required this.translation,
    required this.wordId,
  });

  @override
  List<Object?> get props => [id, source, translation];
}
