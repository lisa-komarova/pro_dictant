import 'package:shared_preferences/shared_preferences.dart';

class AutoSpeakPrefs {
  static const _twKey = 'auto_speak_tw';
  static const _wtKey = 'auto_speak_wt';
  static const _dictantKey = 'auto_speak_dictant';
  static const _cardsKey = 'auto_speak_cards';
  static const _repetitionKey = 'auto_speak_repetition';
  static const _comboInitKey = 'combo_init';
  static const _matchingKey = 'matching';

  Future<bool> getIsEnabled(String trainingType) async {
    final prefs = await SharedPreferences.getInstance();
    switch (trainingType) {
      case 'TW':
        return prefs.getBool(_twKey) ?? false;
      case 'WT':
        return prefs.getBool(_wtKey) ?? false;
      case 'Matching':
        return prefs.getBool(_matchingKey) ?? false;
      case 'Dictant':
        return prefs.getBool(_dictantKey) ?? false;
      case 'Cards':
        return prefs.getBool(_cardsKey) ?? false;
      case 'Repetition':
        return prefs.getBool(_repetitionKey) ?? false;
      case 'ComboInit':
        return prefs.getBool(_comboInitKey) ?? false;
      default:
        return false;
    }
  }

  Future<void> setIsEnabled(String trainingType, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (trainingType) {
      case 'TW':
        await prefs.setBool(_twKey, value);
        break;
      case 'WT':
        await prefs.setBool(_wtKey, value);
      case 'Matching':
        await prefs.setBool(_matchingKey, value);
        break;
      case 'Dictant':
        await prefs.setBool(_dictantKey, value);
        break;
      case 'Cards':
        await prefs.setBool(_cardsKey, value);
        break;
      case 'Repetition':
        await prefs.setBool(_repetitionKey, value);
      case 'ComboInit':
        await prefs.setBool(_comboInitKey, value);
        break;
    }
  }
}
