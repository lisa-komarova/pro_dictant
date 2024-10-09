import 'package:equatable/equatable.dart';
import 'package:pro_dictant/features/trainings/domain/entities/matching_training_entity.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';

import '../../../domain/entities/tw_training_entity.dart';

abstract class TrainingsEvent extends Equatable {
  const TrainingsEvent();

  @override
  List<Object> get props => [];
}

class FetchWordsForWtTRainings extends TrainingsEvent {
  const FetchWordsForWtTRainings();
}

class FetchWordsForMatchingTRainings extends TrainingsEvent {
  const FetchWordsForMatchingTRainings();
}

class FetchWordsForTwTRainings extends TrainingsEvent {
  const FetchWordsForTwTRainings();
}

class UpdateWordsForWtTRainings extends TrainingsEvent {
  final List<String> toUpdate;

  const UpdateWordsForWtTRainings(this.toUpdate);
}

class UpdateWordsForTwTRainings extends TrainingsEvent {
  final List<String> toUpdate;

  const UpdateWordsForTwTRainings(this.toUpdate);
}

class UpdateWordsForMatchingTRainings extends TrainingsEvent {
  final List<MatchingTrainingEntity> toUpdate;

  const UpdateWordsForMatchingTRainings(this.toUpdate);
}

class AddSuggestedTranslationsToWordsInWT extends TrainingsEvent {
  final List<WTTrainingEntity> words;

  const AddSuggestedTranslationsToWordsInWT(this.words);
}

class AddSuggestedSourcesToWordsInTW extends TrainingsEvent {
  final List<TWTrainingEntity> words;

  const AddSuggestedSourcesToWordsInTW(this.words);
}
