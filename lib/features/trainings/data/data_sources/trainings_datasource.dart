import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:pro_dictant/core/error/exception.dart';
import 'package:pro_dictant/features/dictionary/data/models/translation_model.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/translation_entity.dart';
import 'package:pro_dictant/features/trainings/data/models/wt_training_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../dictionary/data/models/word_model.dart';
import '../../../dictionary/domain/entities/word_entity.dart';
import '../models/matching_training_model.dart';
import '../models/tw_training_model.dart';

abstract class TrainingsDatasource {
  Future<List<WTTraningModel>> fetchWordsForWTTraining();

  Future<List<TWTraningModel>> fetchWordsForTWTraining();

  Future<List<MatchingTrainingModel>> fetchWordsForMatchingTraining();

  Future<List<WTTraningModel>> addSuggestedTranslationsToWordsInWT(
      List<WTTraningModel> words);

  Future<List<TWTraningModel>> addSuggestedSourcesToWordsInTW(
      List<TWTraningModel> words);

  Future<void> updateWordsForWTTraining(List<String> toUpdate);

  Future<void> updateWordsForTWTraining(List<String> toUpdate);

  Future<void> updateWordsForMatchingTraining(
      List<MatchingTrainingModel> toUpdate);
}

class TrainingsDatasourceImpl extends TrainingsDatasource {
  TrainingsDatasourceImpl();

  static final TrainingsDatasourceImpl instance =
      TrainingsDatasourceImpl._init();
  static Database? _database;

  TrainingsDatasourceImpl._init();

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

//closes db
  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  @override
  Future<List<WTTraningModel>> fetchWordsForWTTraining() async {
    final db = await database;
    List<WTTraningModel> words = [];
    try {
      final maps = await db!.rawQuery(
          '''select word.source, words_translations.translation, words_translations.id  from word join words_translations on word.id = words_translations.word_id where words_translations.isInDictionary =1 and words_translations.isWT =0 ORDER by random() limit 10''');

      words = maps.map((map) => WTTraningModel.fromJson(map)).toList();
      // String notIn = '';
      // for (var element in words) {
      //   if (element != words.last) {
      //     notIn += ' \'${element.id}\' , ';
      //   } else {
      //     notIn += ' \'${element.id}\' ';
      //   }
      // }
      return words;
    } on Exception catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateWordsForWTTraining(List<String> toUpdate) async {
    final db = await database;
    try {
      for (int i = 0; i < toUpdate.length; i++) {
        await db!.rawQuery(
            '''update words_translations set isWT = 1 where id = \'${toUpdate[i]}\'''');
      }
    } on Exception catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateWordsForTWTraining(List<String> toUpdate) async {
    final db = await database;
    try {
      for (int i = 0; i < toUpdate.length; i++) {
        await db!.rawQuery(
            '''update words_translations set isTW = 1 where id = \'${toUpdate[i]}\'''');
      }
    } on Exception catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<WTTraningModel>> addSuggestedTranslationsToWordsInWT(
      List<WTTraningModel> words) async {
    final db = await database;
    try {
      for (int i = 0; i < words.length; i++) {
        List<TranslationEntity> translation = [];
        final translationMap = await db!.rawQuery(
            '''select * FROM words_translations WHERE id not in (\'${words[i].id}\') ORDER by random() LIMIT 3''');
        translation =
            translationMap.map((e) => TranslationModel.fromJson(e)).toList();
        words[i].suggestedTranslationList.addAll(translation);
      }
      return words;
    } on Exception catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<TWTraningModel>> fetchWordsForTWTraining() async {
    final db = await database;
    List<TWTraningModel> words = [];
    try {
      final maps = await db!.rawQuery(
          '''select word.source, words_translations.translation, words_translations.id  from word join words_translations on word.id = words_translations.word_id where words_translations.isInDictionary =1 and words_translations.isTW =0 ORDER by random() limit 10''');

      words = maps.map((map) => TWTraningModel.fromJson(map)).toList();
      // String notIn = '';
      // for (var element in words) {
      //   if (element != words.last) {
      //     notIn += ' \'${element.id}\' , ';
      //   } else {
      //     notIn += ' \'${element.id}\' ';
      //   }
      // }
      return words;
    } on Exception catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<TWTraningModel>> addSuggestedSourcesToWordsInTW(
      List<TWTraningModel> words) async {
    final db = await database;
    try {
      for (int i = 0; i < words.length; i++) {
        List<WordEntity> sources = [];
        final sourcesMap = await db!.rawQuery(
            '''select * FROM word WHERE id not in (\'${words[i].id}\') ORDER by random() LIMIT 3''');
        sources = sourcesMap.map((e) => WordModel.fromJson(e)).toList();
        words[i].suggestedSourcesList.addAll(sources);
      }
      return words;
    } on Exception catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<MatchingTrainingModel>> fetchWordsForMatchingTraining() async {
    final db = await database;
    List<MatchingTrainingModel> words = [];
    try {
      final maps = await db!.rawQuery(
          '''select word.source, words_translations.translation, words_translations.id  from word join words_translations on word.id = words_translations.word_id where words_translations.isInDictionary =1 and words_translations.isMatching =0 ORDER by random() limit 30''');

      words = maps.map((map) => MatchingTrainingModel.fromJson(map)).toList();
      // String notIn = '';
      // for (var element in words) {
      //   if (element != words.last) {
      //     notIn += ' \'${element.id}\' , ';
      //   } else {
      //     notIn += ' \'${element.id}\' ';
      //   }
      // }
      return words;
    } on Exception catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateWordsForMatchingTraining(
      List<MatchingTrainingModel> toUpdate) async {
    final db = await database;
    try {
      for (int i = 0; i < toUpdate.length; i++) {
        await db!.rawQuery(
            '''update words_translations set isMatching = 1 where id = \'${toUpdate[i].id}\'''');
      }
    } on Exception catch (_) {
      throw ServerException();
    }
  }
}
