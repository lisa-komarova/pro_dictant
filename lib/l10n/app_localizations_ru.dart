// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get profile => 'профиль';

  @override
  String get dictionary => 'словарь';

  @override
  String get trainings => 'тренажёры';

  @override
  String get wordSets => 'наборы слов';

  @override
  String get newSet => 'новый\nнабор';

  @override
  String get newSetTitle => 'новый набор';

  @override
  String get editSet => 'изменить набор';

  @override
  String get enterSetName => 'введите название набора';

  @override
  String get update => 'обновить';

  @override
  String get save => 'сохранить';

  @override
  String get newWord => 'новое\nслово';

  @override
  String get enterWord => 'введите слово';

  @override
  String get enterPartOfSpeech => 'введите часть речи';

  @override
  String get enterTranscription => 'введите транскрипцию';

  @override
  String get enterTranslation => 'введите перевод';

  @override
  String get add => 'добавить';

  @override
  String get cancel => 'отмена';

  @override
  String get newWords => 'новые';

  @override
  String get resetProgress => 'сброшен прогресс';

  @override
  String get learning => 'на\nизучении';

  @override
  String get leftLearning => 'на изучении';

  @override
  String get learnt => 'изучены';

  @override
  String get noWordsYet => 'пока наборов слов нет ˙◠˙';

  @override
  String get wordsAddedToDictionary => 'слова добавлены в словарь!';

  @override
  String get wordsREmeovedFromDictionary => 'слова удалены из словаря!';

  @override
  String get addToDictionary => 'добавить в словарь';

  @override
  String get removeFromDictionary => 'удалить из словаря';

  @override
  String get noWordYet => 'пока слов нет ˙◠˙';

  @override
  String get noSuchWords => 'таких слов нет ˙◠˙';

  @override
  String get addWordsFromDictioanry => 'добавить слова из наборов';

  @override
  String get learn => 'изучить';

  @override
  String get alreadyKnow => 'Уже знаю';

  @override
  String get changeWord => 'изменить';

  @override
  String get removeWordFromDict =>
      'хотите удалить это слово из своего словаря?';

  @override
  String get addWordToDict => 'хотите добавить это слово в свой словарь?';

  @override
  String get removeWord => 'удалить';

  @override
  String get addWord => 'добавить';

  @override
  String get removeWordPermanently =>
      'хотите удалить это слово из словаря навсегда?';

  @override
  String get markAsLearnt => 'хотите переместить это слово в изученные?';

  @override
  String get yes => 'да';

  @override
  String get markAsNew => 'хотите сбросить прогресс этого слова?';

  @override
  String goal(Object goal) {
    return 'цель: $goal мин';
  }

  @override
  String get changeGoal => 'изменить цель';

  @override
  String get tenMinutes => '10 минут';

  @override
  String get fifteenMinutes => '15 минут';

  @override
  String get thirtyMinutes => '30 минут';

  @override
  String addedWords(Object wordsInDictionary) {
    return 'в словаре слов: $wordsInDictionary';
  }

  @override
  String learntWords(Object learntWords) {
    return 'выучено слов:  $learntWords';
  }

  @override
  String get notEnoughWords => 'пока недостаточно слов для тренировки ˙◠˙';

  @override
  String get results => 'результаты';

  @override
  String get rightAnswers => 'верные ответы';

  @override
  String get mistakes => 'ошибки';

  @override
  String get continueTraining => 'продолжить тренировку';

  @override
  String get checkWord => 'проверить';

  @override
  String mistakesCount(Object mistakes) {
    return 'ошибок: $mistakes';
  }

  @override
  String correctAnswersCount(Object correctAnswersCount) {
    return 'ответов: $correctAnswersCount';
  }

  @override
  String get endTrainings => 'завершить тренировку';

  @override
  String get iKnowWontForget => 'знаю,\nне забуду';

  @override
  String get iKnowMightForget => 'знаю,\nмогу забыть';

  @override
  String get iDontRemember => 'не помню';

  @override
  String get sentToLearning => 'отправлено на изучение';

  @override
  String get onLearning => 'на повторении';

  @override
  String get sentToLearnt => 'изучено';

  @override
  String timeLeft(Object time) {
    return 'до выполнения цели осталось $time минут';
  }

  @override
  String get wordTranslation => 'слово-перевод';

  @override
  String get translationWord => 'перевод-слово';

  @override
  String get matchingWords => 'соответствие';

  @override
  String get wordCards => 'карточки';

  @override
  String get dictant => 'диктант';

  @override
  String get combo => 'комбо';

  @override
  String get repeatWords => 'повторение';

  @override
  String get myDictionary => 'мой словарь';

  @override
  String get shouldDeleteSet => 'вы уверены, что хотите удалить набор слов?';

  @override
  String get shouldExit => 'вы уверены, что хотите выйти?';

  @override
  String currentlyLearning(Object setName) {
    return 'сейчас на изучении : $setName';
  }

  @override
  String get sendSetToTrainings => 'отправить\nна изучение';

  @override
  String learntPercentage(Object learntPercentage) {
    return 'выучено $learntPercentage %';
  }

  @override
  String get addNotes => 'добавить примечание к переводу';

  @override
  String get noInternetConnection =>
      'пожалуйста, проверьте подключение к интернету ˙◠˙';

  @override
  String get translateOnline => 'перевести в Yandex';

  @override
  String get yandexSource => 'Powered by Yandex.Dictionary';

  @override
  String get couldntTranslate => 'извините, не получилось перевести ˙◠˙';

  @override
  String get pass => 'пропуск';
}
