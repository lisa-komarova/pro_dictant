import 'package:equatable/equatable.dart';

abstract class SetsEvent extends Equatable {
  const SetsEvent();

  @override
  List<Object> get props => [];
}

class LoadSets extends SetsEvent {
  const LoadSets();
}
