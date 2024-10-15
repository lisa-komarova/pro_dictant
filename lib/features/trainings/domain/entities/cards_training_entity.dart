import 'package:equatable/equatable.dart';

class CardsTrainingEntity extends Equatable {
  final String source;
  final String translation;
  final String wrongTranslation;
  final String id;

  const CardsTrainingEntity(
      {required this.id,
      required this.source,
      required this.translation,
      required this.wrongTranslation});

  @override
  List<Object?> get props => [id, source, translation];
}
