import 'package:flutter/material.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';

import '../../../domain/entities/dictant_training_entity.dart';
import '../../../domain/entities/tw_training_entity.dart';

class ComboTrainingSession extends ChangeNotifier {
  final Map<String, Set<(String source, String translation, String id)>>
      correctAnswers = {
    "wtTraining": {},
    "twTraining": {},
    "dictantTraining": {},
  };
  final Set<WTTrainingEntity> wtWrongAnswers = {};
  final Set<TWTrainingEntity> twWrongAnswers = {};
  final Set<DictantTrainingEntity> dictantWrongAnswers = {};
  final Set<WTTrainingEntity> wtInitialWrongAnswers = {};
  final Set<TWTrainingEntity> twInitialWrongAnswers = {};
  final Set<DictantTrainingEntity> dictantInitialWrongAnswers = {};

  void addCorrect(String training, (String, String, String) answer) {
    correctAnswers[training]?.add(answer);
    notifyListeners();
  }

  void addWtWrong(WTTrainingEntity answer) {
    wtWrongAnswers.add(answer);
    wtInitialWrongAnswers.add(answer);
    notifyListeners();
  }

  void addTwWrong(TWTrainingEntity answer) {
    twWrongAnswers.add(answer);
    twInitialWrongAnswers.add(answer);
    notifyListeners();
  }

  void addDictantWrong(DictantTrainingEntity answer) {
    dictantWrongAnswers.add(answer);
    dictantInitialWrongAnswers.add(answer);
    notifyListeners();
  }

  void removeWtWrong(WTTrainingEntity answer) {
    wtWrongAnswers.remove(answer);
    notifyListeners();
  }

  void removeTwWrong(TWTrainingEntity answer) {
    twWrongAnswers.remove(answer);
    notifyListeners();
  }

  void removeDictantWrong(DictantTrainingEntity answer) {
    dictantWrongAnswers.remove(answer);
    notifyListeners();
  }

  void resetWtWrongAnswers() {
    wtWrongAnswers.clear();
    notifyListeners();
  }

  void resetTwWrongAnswers() {
    twWrongAnswers.clear();
    notifyListeners();
  }

  void resetDictantWrongAnswers() {
    dictantWrongAnswers.clear();
    notifyListeners();
  }

  void reset() {
    correctAnswers["wtTraining"]?.clear();
    correctAnswers["twTraining"]?.clear();
    correctAnswers["dictantTraining"]?.clear();
    wtWrongAnswers.clear();
    twWrongAnswers.clear();
    dictantWrongAnswers.clear();
    wtInitialWrongAnswers.clear();
    twInitialWrongAnswers.clear();
    dictantInitialWrongAnswers.clear();
    notifyListeners();
  }
}
