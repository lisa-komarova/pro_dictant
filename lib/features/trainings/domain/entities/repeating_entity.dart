import 'package:equatable/equatable.dart';

class RepeatingTrainingEntity extends Equatable {
  final String source;
  final String id;

  RepeatingTrainingEntity({
    required this.id,
    required this.source,
  });

  @override
  List<Object?> get props => [id, source];
}
