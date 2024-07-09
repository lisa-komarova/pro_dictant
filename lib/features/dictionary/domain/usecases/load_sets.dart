import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/set_repository.dart';

class LoadSets {
  final SetRepository setRepository;

  LoadSets({required this.setRepository});

  Future<Either<Failure, List<SetEntity>>> call() async {
    return await setRepository.loadSets();
  }
}
