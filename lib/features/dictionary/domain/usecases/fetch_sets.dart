import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_card_info_entity.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/set_repository.dart';

class FetchSets {
  final SetRepository setRepository;

  FetchSets({required this.setRepository});

  Future<Either<Failure, List<SetCardInfoEntity>>> call() async {
    return await setRepository.loadSets();
  }
}
