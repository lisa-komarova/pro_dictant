import 'package:dartz/dartz.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';

class UpdateWordsForComboTraining {
  final TrainingsRepository trainingsRepository;

  UpdateWordsForComboTraining({required this.trainingsRepository});

  Future<Either<Failure, void>> call(
      {required String wtIdstoUpdate,
      required String twIdstoUpdate,
      required String dictantIdstoUpdate}) async {
    return await trainingsRepository.updateWordsForComboTraining(
        wtIdstoUpdate: wtIdstoUpdate,
        twIdstoUpdate: twIdstoUpdate,
        dictantIdstoUpdate: dictantIdstoUpdate);
  }
}
