import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/set_repository.dart';

class FetchWordsForSets {
  final SetRepository setRepository;

  FetchWordsForSets({required this.setRepository});

  Future<Either<Failure, List<SetEntity>>> call(List<SetEntity> sets) async {
    return await setRepository.fetchWordsForSets(sets);
  }
}
