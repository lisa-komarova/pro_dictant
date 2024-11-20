import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:pro_dictant/core/error/exception.dart';
import 'package:pro_dictant/features/dictionary/data/models/set_model.dart';
import 'package:pro_dictant/features/dictionary/data/models/translation_model.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/word_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_bm25/sqlite_bm25.dart';

abstract class WordLocalDatasource {
  Future<List<WordModel>> fetchWordBySource(String query);

  Future<List<WordModel>> fetchWordsInDict();

  Future<List<SetModel>> fetchSets();

  Future<void> updateWord(WordModel word);

  Future<void> updateSet(
      SetModel set, List<WordModel> toAdd, List<WordModel> toDelete);

  Future<void> updateTranslation(TranslationModel translation);

  Future<void> addWord(WordModel word);

  Future<void> addWordsInSetToDictionary(List<TranslationModel> words);

  Future<void> removeWordsInSetFromDictionary(List<TranslationModel> words);

  Future<void> addSet(SetModel set);

  Future<void> addTranslation(TranslationModel translation);

  Future<List<WordModel>> filterWordsInDict(String query);

  Future<List<SetModel>> fetchWordsForSets(List<SetModel> sets);

  Future<List<WordModel>> fetchTranslationsForWords(List<WordModel> words);

  Future<List<WordModel>> fetchTranslationsForWordsInSet(
      List<WordModel> words, String setId);

  Future<List<WordModel>> fetchTranslationsForSearchedWordsInSet(
      List<WordModel> words);

  Future<void> deleteWordFromDictionary(TranslationModel translation);

  Future<void> deleteTranslation(TranslationModel translation);

  Future<void> deleteWord(WordModel word);

  Future<void> deleteSet(String setId);

  Future<List<WordModel>> getNewWords();

  Future<List<WordModel>> getLearningWords();

  Future<List<WordModel>> getLearntWords();
}

class WordsLocalDatasourceImpl extends WordLocalDatasource {
  WordsLocalDatasourceImpl();

  static final WordsLocalDatasourceImpl instance =
      WordsLocalDatasourceImpl._init();
  static Database? _database;

  WordsLocalDatasourceImpl._init();

  ///gets an instance of a database
  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("words.db");
    return _database;
  }

  ///initializes datebase
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);
    bool ifDatabaseExists = await databaseExists(path);
    if (ifDatabaseExists) return await openDatabase(path, version: 1);
    ByteData data = await rootBundle.load("assets/words.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
    return await openDatabase(path, version: 1);
  }

  @override
  Future<List<WordModel>> fetchWordBySource(String query) async {
    final db = await instance.database;
    List<WordModel> words = [];
    final maps = await db!.query(
      tableWords,
      columns: WordsFields.values,
      where: '${WordsFields.source} LIKE ?',
      whereArgs: ['%$query%'],
    );
    if (maps.isNotEmpty) {
      words = maps.map((map) => WordModel.fromJson(map)).toList();
      return words;
    } else if (maps.isEmpty) {
      return words;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<WordModel>> fetchWordsInDict() async {
    final db = await instance.database;
    List<WordModel> words = [];
    final maps = await db!.rawQuery(
        'select word.id,source, pos, transcription from word JOIN words_translations on word.id = words_translations.word_id where isInDictionary = 1  order by words_translations.dateAddedToDictionary');
    if (maps.isNotEmpty) {
      words = maps.map((map) => WordModel.fromJson(map)).toList();
      return words;
    } else if (maps.isEmpty) {
      return words;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SetModel>> fetchSets() async {
    final db = await instance.database;
    List<SetModel> sets = [];
    try {
      final maps = await db!.query(
        tableSets,
        columns: SetFields.values,
      );
      if (maps.isNotEmpty) {
        sets = maps.map((map) => SetModel.fromJson(map)).toList();
        return sets;
      } else {
        throw ServerException();
      }
    } on Exception catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<SetModel>> fetchWordsForSets(List<SetModel> sets) async {
    final db = await instance.database;
    List<WordModel> words = [];
    for (int i = 0; i < sets.length; i++) {
      final wordsInSet = await db!.rawQuery(
          '''SELECT word.id,  word.pos, word.source, word.transcription from words_translations INNER join word_set on words_translations.id == word_set.word_id INNER join word on words_translations.word_id
               == word.id WHERE word_set.set_id = "${sets[i].id}"''');
      words = wordsInSet.map((map) => WordModel.fromJson(map)).toList();
      sets[i].wordsInSet.addAll(words);
    }
    return sets;
  }

  @override
  Future<void> updateWord(WordModel word) async {
    final db = await database;
    await db!.update(
      tableWords,
      word.toJson(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  @override
  Future<void> addWord(WordModel word) async {
    final db = await database;
    await db!.insert(
      tableWords,
      word.toJson(),
    );
    List<TranslationModel> trl = word.translationList
        .map((e) => TranslationModel(
            id: e.id,
            wordId: e.wordId,
            translation: e.translation,
            notes: e.notes,
            isInDictionary: 1,
            dateAddedToDictionary: e.dateAddedToDictionary))
        .toList();
    for (var tr in trl) {
      await db.insert(
        tableTranslations,
        tr.toJson(),
      );
    }
  }

  @override
  Future<void> addWordsInSetToDictionary(List<TranslationModel> words) async {
    final db = await database;
    for (int i = 0; i < words.length; i++) {
      words[i].isInDictionary = 1;
      words[i].dateAddedToDictionary = DateTime.now().toString();
      await db!.update(
        tableTranslations,
        words[i].toJson(),
        where: 'id = ?',
        whereArgs: [words[i].id],
      );
    }
  }

  @override
  Future<void> removeWordsInSetFromDictionary(
      List<TranslationModel> words) async {
    final db = await database;
    for (int i = 0; i < words.length; i++) {
      words[i].isInDictionary = 0;
      words[i].dateAddedToDictionary = '';
      await db!.update(
        tableTranslations,
        words[i].toJson(),
        where: 'id = ?',
        whereArgs: [words[i].id],
      );
    }
  }

  @override
  Future<void> addSet(SetModel set) async {
    final db = await database;
    await db!.insert(
      tableSets,
      set.toJson(),
    );
    List<WordModel> wordsInASetModels = [];
    for (var i = 0; i < set.wordsInSet.length; i++) {
      wordsInASetModels.add(WordModel(
        id: set.wordsInSet[i].id,
        source: set.wordsInSet[i].source,
        pos: set.wordsInSet[i].pos,
        transcription: set.wordsInSet[i].transcription,
      ));
      wordsInASetModels[i]
          .translationList
          .addAll(set.wordsInSet[i].translationList);
    }
    await addWordsInASet(wordsInASetModels, set.id);
  }

  Future<void> addWordsInASet(List<WordModel> wordsInASet, String setId) async {
    final db = await database;
    for (WordModel word in wordsInASet) {
      await db!.rawQuery('''INSERT INTO "main"."word_set"
            ("word_id", "set_id")
          VALUES ('${word.translationList.first.id}', '$setId');''');
    }
  }

  Future<void> deleteWordsInASet(List<WordModel> toDelete) async {
    final db = await database;
    for (WordModel word in toDelete) {
      await db!.delete('word_set',
          where: 'word_id = ?', whereArgs: [word.translationList.first.id]);
    }
  }

  @override
  Future<void> deleteWordFromDictionary(TranslationModel translation) async {
    final db = await database;
    translation.isInDictionary = 0;
    await db!.update(
      tableTranslations,
      translation.toJson(),
      where: 'id = ?',
      whereArgs: [translation.id],
    );
  }

  @override
  Future<void> deleteWord(WordEntity word) async {
    final db = await database;
    for (int i = 0; i < word.translationList.length; i++) {
      await db!.delete(
        tableTranslations,
        where: 'id = ?',
        whereArgs: [word.translationList[i].id],
      );
    }
    await db!.delete(
      tableWords,
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  @override
  Future<List<WordModel>> filterWordsInDict(String query) async {
    final db = await instance.database;
    List<WordModel> words = [];
    var maps = await db!.query(
      'source_fts',
      columns: [
        'source_id',
        'source',
        'pos',
        'transcription',
        'matchinfo( source_fts, \'$bm25FormatString\') as info'
      ],
      where: 'source_fts MATCH ?',
      whereArgs: [query],
    );
    if (maps.isNotEmpty) {
      maps = maps.map((row) {
        return {
          'id': row['source_id'],
          'source': row['source'],
          'pos': row['pos'],
          'transcription': row['transcription'],
          'rank': bm25(row['info'] as Uint8List),
        };
      }).toList();
      maps.sort(
          (a, b) => (a['rank'] as double).compareTo((b['rank'] as double)));
      words = maps.map((map) => WordModel.fromJson(map)).toList();
      return words;
    } else if (maps.isEmpty) {
      return words;
    } else {
      throw ServerException();
    }
  }

//closes db
  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  @override
  Future<List<WordModel>> getLearningWords() async {
    final db = await instance.database;
    List<WordModel> words = [];
    final maps = await db!.rawQuery(
        '''select word.id,source, pos, transcription from word JOIN words_translations on word.id = words_translations.word_id where 
    isInDictionary= 1 and ( isTW=1 or isWT=1 or isCards=1 
    or isMatching=1 or  isDictant=1 or  isRepeated=1)
       and (isTW=0 or isWT=0 or isCards=0 
       or  isMatching=0 or  isDictant=0 
       or  isRepeated=0)''');
    if (maps.isNotEmpty) {
      words = maps.map((map) => WordModel.fromJson(map)).toList();
      return words;
    } else if (maps.isEmpty) {
      return words;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<WordModel>> getLearntWords() async {
    final db = await instance.database;
    List<WordModel> words = [];
    final maps = await db!.rawQuery(
        '''select word.id,source, pos, transcription from word JOIN words_translations on word.id = words_translations.word_id where 
    isInDictionary= 1 and  isTW=1 and isWT=1 and isCards=1 
    and isMatching=1 and  isDictant=1 and  isRepeated=1''');
    if (maps.isNotEmpty) {
      words = maps.map((map) => WordModel.fromJson(map)).toList();
      return words;
    } else if (maps.isEmpty) {
      return words;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<WordModel>> getNewWords() async {
    final db = await instance.database;
    List<WordModel> words = [];
    final maps = await db!.rawQuery(
        '''select word.id,source, pos, transcription from word JOIN words_translations on word.id = words_translations.word_id where 
    isInDictionary= 1 and  isTW=0 and isWT=0 and isCards=0 
    and isMatching=0 and  isDictant=0 and  isRepeated=0''');
    if (maps.isNotEmpty) {
      words = maps.map((map) => WordModel.fromJson(map)).toList();
      return words;
    } else if (maps.isEmpty) {
      return words;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateTranslation(TranslationModel translation) async {
    final db = await database;
    await db!.update(
      tableTranslations,
      translation.toJson(),
      where: 'id = ?',
      whereArgs: [translation.id],
    );
  }

  @override
  Future<List<WordModel>> fetchTranslationsForWords(
      List<WordModel> words) async {
    final db = await database;
    List<TranslationModel> translations = [];
    for (int i = 0; i < words.length; i++) {
      final translationsMap = await db!.rawQuery(
          '''SELECT words_translations.id, word_id, translation, notes, isInDictionary, isTW, isWT,
               isMatching, isCards, isDictant, isRepeated, dateAddedToDictionary
               from word INNER join words_translations on word.id 
               == words_translations.word_id WHERE words_translations.word_id = "${words[i].id}"''');
      translations =
          translationsMap.map((map) => TranslationModel.fromJson(map)).toList();
      words[i].translationList.addAll(translations);
    }
    return words;
  }

  @override
  Future<void> deleteTranslation(TranslationModel translation) async {
    final db = await database;

    await db!.delete(
      tableTranslations,
      where: 'id = ?',
      whereArgs: [translation.id],
    );
  }

  @override
  Future<void> addTranslation(TranslationModel translation) async {
    final db = await database;

    await db!.insert(
      tableTranslations,
      translation.toJson(),
    );
  }

  @override
  Future<List<WordModel>> fetchTranslationsForWordsInSet(
      List<WordModel> words, String setId) async {
    final db = await database;
    List<TranslationModel> translations = [];
    final translationsMap = await db!.rawQuery(
        '''SELECT words_translations.id,  words_translations.word_id, translation, notes, isInDictionary, isTW, isWT,
               isMatching, isCards, isDictant, isRepeated, dateAddedToDictionary from words_translations INNER join word_set on words_translations.id 
               == word_set.word_id WHERE word_set.set_id =  "$setId"''');
    translations =
        translationsMap.map((map) => TranslationModel.fromJson(map)).toList();
    for (int i = 0; i < words.length; i++) {
      words[i].translationList.add(translations[i]);
    }
    return words;
  }

  @override
  Future<List<WordModel>> fetchTranslationsForSearchedWordsInSet(
      List<WordModel> words) async {
    final db = await database;
    List<TranslationModel> translations = [];
    List<WordModel> updatedWords = [];
    for (int i = 0; i < words.length; i++) {
      List<WordModel> wordsListToAdd = [];
      final translationsMap = await db!.rawQuery(
          '''SELECT words_translations.id,  words_translations.word_id, translation, notes, isInDictionary, isTW, isWT,
               isMatching, isCards, isDictant, isRepeated, dateAddedToDictionary from words_translations where words_translations.word_id 
               == "${words[i].id}" ''');
      translations =
          translationsMap.map((map) => TranslationModel.fromJson(map)).toList();
      for (int y = 0; y < translations.length; y++) {
        final newWord = WordModel(
          id: words[i].id,
          source: words[i].source,
          pos: words[i].pos,
          transcription: words[i].transcription,
        );
        newWord.translationList.add(translations[y]);
        wordsListToAdd.add(newWord);
      }
      updatedWords.addAll(wordsListToAdd);
    }
    return updatedWords;
  }

  @override
  Future<void> deleteSet(String setId) async {
    final db = await database;
    await db!.delete(
      tableSets,
      where: 'id = ?',
      whereArgs: [setId],
    );
  }

  @override
  Future<void> updateSet(
      SetModel set, List<WordModel> toAdd, List<WordModel> toDelete) async {
    final db = await database;
    await db!.update(
      tableSets,
      set.toJson(),
      where: 'id = ?',
      whereArgs: [set.id],
    );
    await addWordsInASet(toAdd, set.id);
    await deleteWordsInASet(toDelete);
  }
}
