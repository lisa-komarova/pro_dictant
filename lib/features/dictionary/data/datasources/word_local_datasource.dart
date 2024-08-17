import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:pro_dictant/core/error/exception.dart';
import 'package:pro_dictant/features/dictionary/data/models/set_model.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class WordLocalDatasource {
  Future<List<WordModel>> fetchWordBySource(String query);

  Future<List<WordModel>> fetchWordsInDict();

  Future<List<SetModel>> fetchSets();

  Future<void> updateWord(WordModel word);

  Future<void> addWord(WordModel word);

  Future<void> addSet(SetModel set);

  Future<List<WordModel>> filterWordsInDict(String query);

  Future<List<WordModel>> searchWordForASet(String query);

  Future<void> deleteWordFromDictionary(WordModel word);

  Future<void> deleteWord(String id);

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
    await deleteDatabase(path);
    ByteData data = await rootBundle.load("assets/words.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
    return await openDatabase(path, version: 1);
  }

  ///gets taro card by id
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

  Future<List<WordModel>> fetchWordsInDict() async {
    final db = await instance.database;
    List<WordModel> words = [];
    final maps = await db!.query(
      tableWords,
      columns: WordsFields.values,
      where: '${WordsFields.isInDictionary} = ?',
      whereArgs: [1],
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
        addWordsToSet(sets, db);
        return sets;
      } else {
        throw ServerException();
      }
    } on Exception catch (_) {
      throw ServerException();
    }
  }

  void addWordsToSet(List<SetModel> sets, Database db) async {
    List<WordModel> words = [];
    sets.forEach((element) async {
      final wordsInSet =
          await db!.rawQuery('''SELECT word.id, source, pos, transcription,
              translations, isInDictionary, isTW, isWT,
               isMatching, isCards, isDictant, isRepeated
               from word INNER join word_set on word.id 
               == word_set.word_id WHERE word_set.set_id = \"${element.id}\"''');
      words = wordsInSet.map((map) => WordModel.fromJson(map)).toList();
      element.wordsInSet.addAll(words);
      await null;
    });
  }

  Future<void> updateWord(WordModel word) async {
// Get a reference to the database.
    final db = await database;
// Update the given word.
    await db!.update(
      tableWords,
      word.toJson(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<void> addWord(WordModel word) async {
// Get a reference to the database.
    final db = await database;
// Update the given word.
    await db!.insert(
      tableWords,
      word.toJson(),
    );
  }

  Future<void> addSet(SetModel set) async {
// Get a reference to the database.
    final db = await database;
// Update the given word.
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
          translations: set.wordsInSet[i].translations));
    }
    await addWordsInASet(wordsInASetModels, set.id);
  }

  Future<void> addWordsInASet(List<WordModel> wordsInASet, String setId) async {
    final db = await database;
    for (WordModel word in wordsInASet) {
      await db!.rawQuery('''INSERT INTO "main"."word_set"
            ("word_id", "set_id")
          VALUES ('${word.id}', '$setId');''');
    }
  }

  Future<void> deleteWordFromDictionary(WordModel word) async {
// Get a reference to the database.
    final db = await database;
// Update the given word.
    await db!.update(
      tableWords,
      word.toJson(),
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<void> deleteWord(String id) async {
// Get a reference to the database.
    final db = await database;

// Update the given word.
    await db!.delete(
      tableWords,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //
  Future<List<WordModel>> filterWordsInDict(String query) async {
    final db = await instance.database;
    List<WordModel> words = [];
    final maps = await db!.query(
      tableWords,
      columns: WordsFields.values,
      where:
          '${WordsFields.isInDictionary} = ? and ${WordsFields.source} LIKE ?',
      whereArgs: [1, '%$query%'],
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

//closes db
  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  @override
  Future<List<WordModel>> getLearningWords() async {
    final db = await instance.database;
    List<WordModel> words = [];
    final maps = await db!.rawQuery('''select * from word  where 
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
    final maps = await db!.query(
      tableWords,
      columns: WordsFields.values,
      where: ''' ${WordsFields.isInDictionary} = ? and ${WordsFields.isWT} = 1 
          and ${WordsFields.isTW} = 1 
          and ${WordsFields.isCards} = 1 
          and ${WordsFields.isMatching} = 1 
          and ${WordsFields.isDictant} = 1 
          and ${WordsFields.isRepeated} = 1 ''',
      whereArgs: [
        1,
      ],
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
  Future<List<WordModel>> getNewWords() async {
    final db = await instance.database;
    List<WordModel> words = [];
    final maps = await db!.query(
      tableWords,
      columns: WordsFields.values,
      where: ''' ${WordsFields.isInDictionary} = ? and ${WordsFields.isWT} = 0
          and ${WordsFields.isTW} = 0
          and ${WordsFields.isCards} = 0
          and ${WordsFields.isMatching} = 0 
          and ${WordsFields.isDictant} = 0
          and ${WordsFields.isRepeated} = 0 ''',
      whereArgs: [
        1,
      ],
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
  Future<List<WordModel>> searchWordForASet(String query) async {
    final db = await instance.database;
    List<WordModel> words = [];
    final maps = await db!.query(
      tableWords,
      columns: WordsFields.values,
      where: ' ${WordsFields.source} LIKE ?',
      whereArgs: ['%$query%'],
    );
    if (maps.isNotEmpty) {
      words = maps.map((map) => WordModel.fromJson(map)).toList();
      // if (words.length >= 3) {
      //   words = words.getRange(0, 3).toList();
      // }
      return words;
    } else if (maps.isEmpty) {
      return words;
    } else {
      throw ServerException();
    }
  }
}
