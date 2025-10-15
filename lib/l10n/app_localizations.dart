import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// Bottom navigation dictionary
  ///
  /// In en, this message translates to:
  /// **'profile'**
  String get profile;

  /// No description provided for @dictionary.
  ///
  /// In en, this message translates to:
  /// **'dictionary'**
  String get dictionary;

  /// Bottom navigation training
  ///
  /// In en, this message translates to:
  /// **'training'**
  String get trainings;

  /// No description provided for @wordSets.
  ///
  /// In en, this message translates to:
  /// **'word sets'**
  String get wordSets;

  /// No description provided for @newSet.
  ///
  /// In en, this message translates to:
  /// **'new set'**
  String get newSet;

  /// No description provided for @newSetTitle.
  ///
  /// In en, this message translates to:
  /// **'new set'**
  String get newSetTitle;

  /// No description provided for @editSet.
  ///
  /// In en, this message translates to:
  /// **'edit set'**
  String get editSet;

  /// No description provided for @enterSetName.
  ///
  /// In en, this message translates to:
  /// **'enter name'**
  String get enterSetName;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'update'**
  String get update;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'save'**
  String get save;

  /// No description provided for @newWord.
  ///
  /// In en, this message translates to:
  /// **'new word'**
  String get newWord;

  /// No description provided for @enterWord.
  ///
  /// In en, this message translates to:
  /// **'enter word'**
  String get enterWord;

  /// No description provided for @enterPartOfSpeech.
  ///
  /// In en, this message translates to:
  /// **'enter part of speech'**
  String get enterPartOfSpeech;

  /// No description provided for @enterTranscription.
  ///
  /// In en, this message translates to:
  /// **'enter transcription'**
  String get enterTranscription;

  /// No description provided for @enterTranslation.
  ///
  /// In en, this message translates to:
  /// **'enter translation'**
  String get enterTranslation;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'add'**
  String get add;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @newWords.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get newWords;

  /// No description provided for @resetProgress.
  ///
  /// In en, this message translates to:
  /// **'reset progree'**
  String get resetProgress;

  /// No description provided for @learning.
  ///
  /// In en, this message translates to:
  /// **'learning'**
  String get learning;

  /// No description provided for @leftLearning.
  ///
  /// In en, this message translates to:
  /// **'in progress'**
  String get leftLearning;

  /// No description provided for @learnt.
  ///
  /// In en, this message translates to:
  /// **'learnt'**
  String get learnt;

  /// No description provided for @noWordsYet.
  ///
  /// In en, this message translates to:
  /// **'there are no word sets yet ˙◠˙'**
  String get noWordsYet;

  /// No description provided for @wordsAddedToDictionary.
  ///
  /// In en, this message translates to:
  /// **'words are added to the dictionary!'**
  String get wordsAddedToDictionary;

  /// No description provided for @wordsREmeovedFromDictionary.
  ///
  /// In en, this message translates to:
  /// **'words are removed from the dictionary!'**
  String get wordsREmeovedFromDictionary;

  /// No description provided for @addToDictionary.
  ///
  /// In en, this message translates to:
  /// **'add to dictionary'**
  String get addToDictionary;

  /// No description provided for @removeFromDictionary.
  ///
  /// In en, this message translates to:
  /// **'remove from dictionary'**
  String get removeFromDictionary;

  /// No description provided for @noWordYet.
  ///
  /// In en, this message translates to:
  /// **'no words yet ˙◠˙'**
  String get noWordYet;

  /// No description provided for @noSuchWords.
  ///
  /// In en, this message translates to:
  /// **'there are no such words ˙◠˙'**
  String get noSuchWords;

  /// No description provided for @addWordsFromDictioanry.
  ///
  /// In en, this message translates to:
  /// **'add words from sets'**
  String get addWordsFromDictioanry;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'learn'**
  String get learn;

  /// No description provided for @alreadyKnow.
  ///
  /// In en, this message translates to:
  /// **'already know'**
  String get alreadyKnow;

  /// No description provided for @changeWord.
  ///
  /// In en, this message translates to:
  /// **'change'**
  String get changeWord;

  /// No description provided for @removeWordFromDict.
  ///
  /// In en, this message translates to:
  /// **'do you want to remove this word from your dictionary?'**
  String get removeWordFromDict;

  /// No description provided for @addWordToDict.
  ///
  /// In en, this message translates to:
  /// **'would you like to add this word to your dictionary?'**
  String get addWordToDict;

  /// No description provided for @removeWord.
  ///
  /// In en, this message translates to:
  /// **'remove'**
  String get removeWord;

  /// No description provided for @addWord.
  ///
  /// In en, this message translates to:
  /// **'add'**
  String get addWord;

  /// No description provided for @removeWordPermanently.
  ///
  /// In en, this message translates to:
  /// **'do you want to remove this word from the dictionary permanently?'**
  String get removeWordPermanently;

  /// No description provided for @markAsLearnt.
  ///
  /// In en, this message translates to:
  /// **'mark this word as learnt?'**
  String get markAsLearnt;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;

  /// No description provided for @markAsNew.
  ///
  /// In en, this message translates to:
  /// **'mark this word as new?'**
  String get markAsNew;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'goal: {goal} min'**
  String goal(Object goal);

  /// No description provided for @changeGoal.
  ///
  /// In en, this message translates to:
  /// **'change goal'**
  String get changeGoal;

  /// No description provided for @tenMinutes.
  ///
  /// In en, this message translates to:
  /// **'10 minutes'**
  String get tenMinutes;

  /// No description provided for @fifteenMinutes.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get fifteenMinutes;

  /// No description provided for @thirtyMinutes.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get thirtyMinutes;

  /// No description provided for @addedWords.
  ///
  /// In en, this message translates to:
  /// **'added words: {wordsInDictionary}'**
  String addedWords(Object wordsInDictionary);

  /// No description provided for @learntWords.
  ///
  /// In en, this message translates to:
  /// **'learnt words:  {learntWords}'**
  String learntWords(Object learntWords);

  /// No description provided for @notEnoughWords.
  ///
  /// In en, this message translates to:
  /// **'not enough words for the training ˙◠˙'**
  String get notEnoughWords;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'results'**
  String get results;

  /// No description provided for @rightAnswers.
  ///
  /// In en, this message translates to:
  /// **'right answers'**
  String get rightAnswers;

  /// No description provided for @mistakes.
  ///
  /// In en, this message translates to:
  /// **'mistakes'**
  String get mistakes;

  /// No description provided for @continueTraining.
  ///
  /// In en, this message translates to:
  /// **'continue training'**
  String get continueTraining;

  /// No description provided for @checkWord.
  ///
  /// In en, this message translates to:
  /// **'check my answer'**
  String get checkWord;

  /// No description provided for @mistakesCount.
  ///
  /// In en, this message translates to:
  /// **'mistakes: {mistakes}'**
  String mistakesCount(Object mistakes);

  /// No description provided for @correctAnswersCount.
  ///
  /// In en, this message translates to:
  /// **'right answers: {correctAnswersCount}'**
  String correctAnswersCount(Object correctAnswersCount);

  /// No description provided for @endTrainings.
  ///
  /// In en, this message translates to:
  /// **'end training'**
  String get endTrainings;

  /// No description provided for @iKnowWontForget.
  ///
  /// In en, this message translates to:
  /// **'i know \nwon\'t forget'**
  String get iKnowWontForget;

  /// No description provided for @iKnowMightForget.
  ///
  /// In en, this message translates to:
  /// **'i know\nmight forget'**
  String get iKnowMightForget;

  /// No description provided for @iDontRemember.
  ///
  /// In en, this message translates to:
  /// **'i don\'t\nremember'**
  String get iDontRemember;

  /// No description provided for @sentToLearning.
  ///
  /// In en, this message translates to:
  /// **'sent to learning'**
  String get sentToLearning;

  /// No description provided for @onLearning.
  ///
  /// In en, this message translates to:
  /// **'still learning'**
  String get onLearning;

  /// No description provided for @sentToLearnt.
  ///
  /// In en, this message translates to:
  /// **'sent to learnt'**
  String get sentToLearnt;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'time left to complete the goal {time} minutes'**
  String timeLeft(Object time);

  /// No description provided for @wordTranslation.
  ///
  /// In en, this message translates to:
  /// **'word-translation'**
  String get wordTranslation;

  /// No description provided for @translationWord.
  ///
  /// In en, this message translates to:
  /// **'translation-word'**
  String get translationWord;

  /// No description provided for @matchingWords.
  ///
  /// In en, this message translates to:
  /// **'match the words'**
  String get matchingWords;

  /// No description provided for @wordCards.
  ///
  /// In en, this message translates to:
  /// **'word cards'**
  String get wordCards;

  /// No description provided for @dictant.
  ///
  /// In en, this message translates to:
  /// **'dictation'**
  String get dictant;

  /// No description provided for @combo.
  ///
  /// In en, this message translates to:
  /// **'combo'**
  String get combo;

  /// No description provided for @repeatWords.
  ///
  /// In en, this message translates to:
  /// **'repeat words'**
  String get repeatWords;

  /// No description provided for @myDictionary.
  ///
  /// In en, this message translates to:
  /// **'my dictionary'**
  String get myDictionary;

  /// No description provided for @shouldDeleteSet.
  ///
  /// In en, this message translates to:
  /// **'are you sure you want to delete this set of words?'**
  String get shouldDeleteSet;

  /// No description provided for @shouldExit.
  ///
  /// In en, this message translates to:
  /// **'are you sure you want to leave?'**
  String get shouldExit;

  /// No description provided for @currentlyLearning.
  ///
  /// In en, this message translates to:
  /// **'currently learning : {setName}'**
  String currentlyLearning(Object setName);

  /// No description provided for @sendSetToTrainings.
  ///
  /// In en, this message translates to:
  /// **'send to training'**
  String get sendSetToTrainings;

  /// No description provided for @learntPercentage.
  ///
  /// In en, this message translates to:
  /// **'{learntPercentage} % learned'**
  String learntPercentage(Object learntPercentage);

  /// No description provided for @addNotes.
  ///
  /// In en, this message translates to:
  /// **'add notes to translation'**
  String get addNotes;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'please check internet connection ˙◠˙'**
  String get noInternetConnection;

  /// No description provided for @translateOnline.
  ///
  /// In en, this message translates to:
  /// **'translate in Yandex'**
  String get translateOnline;

  /// No description provided for @yandexSource.
  ///
  /// In en, this message translates to:
  /// **'Powered by Yandex.Dictionary'**
  String get yandexSource;

  /// No description provided for @couldntTranslate.
  ///
  /// In en, this message translates to:
  /// **'sorry, couldn\'t translate this word ˙◠˙'**
  String get couldntTranslate;

  /// No description provided for @pass.
  ///
  /// In en, this message translates to:
  /// **'pass'**
  String get pass;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
