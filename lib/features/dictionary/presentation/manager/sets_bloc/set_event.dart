import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';

abstract class SetsEvent extends Equatable {
  const SetsEvent();

  @override
  List<Object> get props => [];
}

class LoadSets extends SetsEvent {
  const LoadSets();
}

class AddSet extends SetsEvent {
  final SetEntity set;

  const AddSet({required this.set});
}
