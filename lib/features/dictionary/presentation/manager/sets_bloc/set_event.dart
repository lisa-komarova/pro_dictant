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

class DeleteSet extends SetsEvent {
  final String setId;

  const DeleteSet({required this.setId});
}

class FetchWordsForSets extends SetsEvent {
  final List<SetEntity> sets;

  const FetchWordsForSets({required this.sets});
}

class FetchTranslationsForWordsInSets extends SetsEvent {
  final SetEntity set;

  const FetchTranslationsForWordsInSets({required this.set});
}

class FetchTranslationsForSearchedWordsInSets extends SetsEvent {
  final SetEntity set;

  const FetchTranslationsForSearchedWordsInSets({required this.set});
}
