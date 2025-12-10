// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get profile => 'profile';

  @override
  String get dictionary => 'dictionary';

  @override
  String get trainings => 'training';

  @override
  String get wordSets => 'word sets';

  @override
  String get newSet => 'new set';

  @override
  String get newSetTitle => 'new set';

  @override
  String get editSet => 'edit set';

  @override
  String get enterSetName => 'enter name';

  @override
  String get update => 'update';

  @override
  String get save => 'save';

  @override
  String get newWord => 'new word';

  @override
  String get enterWord => 'enter word';

  @override
  String get enterPartOfSpeech => 'enter part of speech';

  @override
  String get enterTranscription => 'enter transcription';

  @override
  String get enterTranslation => 'enter translation';

  @override
  String get add => 'add';

  @override
  String get cancel => 'cancel';

  @override
  String get newWords => 'new';

  @override
  String get resetProgress => 'reset progree';

  @override
  String get learning => 'learning';

  @override
  String get leftLearning => 'in progress';

  @override
  String get learnt => 'learnt';

  @override
  String get noWordsYet => 'there are no word sets yet ˙◠˙';

  @override
  String get wordsAddedToDictionary => 'words are added to the dictionary!';

  @override
  String get wordsREmeovedFromDictionary =>
      'words are removed from the dictionary!';

  @override
  String get addToDictionary => 'add to dictionary';

  @override
  String get removeFromDictionary => 'remove from dictionary';

  @override
  String get noWordYet => 'no words yet ˙◠˙';

  @override
  String get noSuchWords => 'there are no such words ˙◠˙';

  @override
  String get addWordsFromDictioanry => 'add words from sets';

  @override
  String get learn => 'learn';

  @override
  String get alreadyKnow => 'already know';

  @override
  String get changeWord => 'change';

  @override
  String get removeWordFromDict =>
      'do you want to remove this word from your dictionary?';

  @override
  String get addWordToDict =>
      'would you like to add this word to your dictionary?';

  @override
  String get removeWord => 'remove';

  @override
  String get addWord => 'add';

  @override
  String get removeWordPermanently =>
      'do you want to remove this word from the dictionary permanently?';

  @override
  String get markAsLearnt => 'mark this word as learnt?';

  @override
  String get yes => 'yes';

  @override
  String get markAsNew => 'mark this word as new?';

  @override
  String goal(Object goal) {
    return 'goal: $goal min';
  }

  @override
  String get changeGoal => 'change goal';

  @override
  String get tenMinutes => '10 minutes';

  @override
  String get fifteenMinutes => '15 minutes';

  @override
  String get thirtyMinutes => '30 minutes';

  @override
  String addedWords(Object wordsInDictionary) {
    return 'added words: $wordsInDictionary';
  }

  @override
  String learntWords(Object learntWords) {
    return 'learnt words:  $learntWords';
  }

  @override
  String get notEnoughWords => 'not enough words for the training ˙◠˙';

  @override
  String get results => 'results';

  @override
  String get rightAnswers => 'right answers';

  @override
  String get mistakes => 'mistakes';

  @override
  String get continueTraining => 'continue training';

  @override
  String get checkWord => 'check my answer';

  @override
  String mistakesCount(Object mistakes) {
    return 'mistakes: $mistakes';
  }

  @override
  String correctAnswersCount(Object correctAnswersCount) {
    return 'right answers: $correctAnswersCount';
  }

  @override
  String get endTrainings => 'end training';

  @override
  String get iKnowWontForget => 'i know won\'t forget';

  @override
  String get iKnowMightForget => 'i know might forget';

  @override
  String get iDontRemember => 'i don\'t remember';

  @override
  String get sentToLearning => 'sent to learning';

  @override
  String get onLearning => 'still learning';

  @override
  String get sentToLearnt => 'sent to learnt';

  @override
  String timeLeft(Object time) {
    return 'time left to complete the goal $time minutes';
  }

  @override
  String get wordTranslation => 'word-translation';

  @override
  String get translationWord => 'translation-word';

  @override
  String get matchingWords => 'match the words';

  @override
  String get wordCards => 'word cards';

  @override
  String get dictant => 'dictation';

  @override
  String get combo => 'combo';

  @override
  String get repeatWords => 'repeat words';

  @override
  String get myDictionary => 'my dictionary';

  @override
  String get shouldDeleteSet =>
      'are you sure you want to delete this set of words?';

  @override
  String get shouldExit => 'are you sure you want to leave?';

  @override
  String currentlyLearning(Object setName) {
    return 'currently learning : $setName';
  }

  @override
  String get sendSetToTrainings => 'send to training';

  @override
  String learntPercentage(Object learntPercentage) {
    return '$learntPercentage % learned';
  }

  @override
  String get addNotes => 'add notes to translation';

  @override
  String get noInternetConnection => 'please check internet connection ˙◠˙';

  @override
  String get translateOnline => 'translate in Yandex';

  @override
  String get yandexSource => 'Powered by Yandex.Dictionary';

  @override
  String get couldntTranslate => 'sorry, couldn\'t translate this word ˙◠˙';

  @override
  String get pass => 'pass';

  @override
  String filterButton(Object filter) {
    return 'filter button $filter';
  }

  @override
  String get selected => 'selected';

  @override
  String get notSelected => 'not selected';

  @override
  String get searchButton => 'search';

  @override
  String get clearButton => 'clear';

  @override
  String progress(Object learnt) {
    return '$learnt trainings passed';
  }

  @override
  String get speakButton => 'pronounce';

  @override
  String get deleteWordFromDictionaryButton =>
      'delete this word from the dictionary';

  @override
  String get addWordToDictionaryButton => 'add this word to my dictionary';

  @override
  String get deleteWordFromDBButton => 'delete this word permanently';

  @override
  String get exitButton => 'exit';

  @override
  String addNotesToTranslation(Object translation) {
    return 'add notes to $translation translation';
  }

  @override
  String get addAnotherTranslation => 'add another translation';

  @override
  String removeThisTranslation(Object translation) {
    return 'remove $translation translation';
  }

  @override
  String wordsRemaining(num count) {
    return '$count words remaining';
  }

  @override
  String get rightAnswer => 'right answer';

  @override
  String get wrongAnswer => 'wrong answer';

  @override
  String wordRightInWTandTWResult(Object word) {
    return '$word no mistake';
  }

  @override
  String wordWrongInWTandTWResult(Object word) {
    return '$word mistake';
  }

  @override
  String get hintButton => 'hint';

  @override
  String get notChosen => 'not chosen';

  @override
  String get chosen => 'сhosen';

  @override
  String get chosenRight => 'right choice';

  @override
  String get chosenWrong => 'wrong choice';

  @override
  String get currentDictantAnswer => 'current answer';

  @override
  String get wordNotEntered => 'empty field';

  @override
  String get goalCompleted => 'goal сompleted';

  @override
  String get goalUncompleted => 'goal unсompleted';

  @override
  String wrongAnswerNAttemptsLeft(num count) {
    return 'wrong answer, $count attempts left';
  }

  @override
  String wrongChoiceNAttemptsLeft(num count) {
    return 'wrong choice, $count attempts left';
  }

  @override
  String get wordTranslationDesc =>
      'word-translation: choose the correct translation into Russian';

  @override
  String get translationWordDesc =>
      'translation-word: choose the correct translation into English';

  @override
  String get matchingWordsDesc =>
      'math the words: pair the word with its translation';

  @override
  String get wordCardsDesc =>
      'word cards: choose the correct translation from two options';

  @override
  String get dictantDesc =>
      'dictation: write down the translation of the word in English';

  @override
  String get comboDesc =>
      'combo: a combination of word-translation, translation-word, and dictation trainings';

  @override
  String get repeatWordsDesc =>
      'repeat words: track the progress of learned words';

  @override
  String get turnAutoSpeakOn => 'turn on auto-speak';

  @override
  String get turnAutoSpeakOff => 'turn off auto-speak';
}
