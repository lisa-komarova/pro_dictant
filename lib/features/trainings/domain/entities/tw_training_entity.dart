import 'package:equatable/equatable.dart';

import '../../../dictionary/domain/entities/word_entity.dart';

class TWTrainingEntity extends Equatable {
  final String translation;
  final String source;
  final String id;
  late final List<WordEntity> suggestedSourcesList = [];

  TWTrainingEntity(
      {required this.id, required this.source, required this.translation});

  @override
  List<Object?> get props => [id, source, translation];
}
