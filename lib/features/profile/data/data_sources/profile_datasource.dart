import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:pro_dictant/core/error/exception.dart';
import 'package:sqflite/sqflite.dart';

abstract class ProfileDatasource {
  Future<int> fetchNumberOfWordsInDictionary();

  Future<int> fetchNumberOfLearntWords();

  Future<int> fetchGoal();

  Future<List<Map<DateTime, int>>> fetchDatasets();

  Future<void> updateDayStatistics(DateTime date);

  Future<void> updateGoal(int goalInMinutes);

  Future<int> getTimeOnApp();
}

class ProfileDatasourceImpl extends ProfileDatasource {
  ProfileDatasourceImpl();

  static final ProfileDatasourceImpl instance = ProfileDatasourceImpl._init();
  static Database? _database;

  ProfileDatasourceImpl._init();

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

  ///gets taro card by id
  @override
  Future<int> fetchNumberOfWordsInDictionary() async {
    final db = await instance.database;
    final maps = await db!.rawQuery(
        'select count() as number from words_translations where isInDictionary = 1');
    if (maps.isNotEmpty) {
      var counts = maps.map((row) {
        return row['number'] as int;
      }).toList();
      return counts.first;
    } else if (maps.isEmpty) {
      return 0;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<int> fetchNumberOfLearntWords() async {
    final db = await instance.database;
    final maps = await db!.rawQuery(
        'select count() as number from words_translations where isInDictionary = 1 and isRepeated = 1');
    if (maps.isNotEmpty) {
      var counts = maps.map((row) {
        return row['number'] as int;
      }).toList();
      return counts.first;
    } else if (maps.isEmpty) {
      return 0;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Map<DateTime, int>>> fetchDatasets() async {
    final db = await instance.database;
    List<Map<DateTime, int>> dateSet = [];
    try {
      final maps = await db!.rawQuery(
          'SELECT date, isCompleted from statistics ORDER by id DESC limit 30');
      if (maps.isNotEmpty) {
        dateSet = maps.map((map) => fromJson(map)).toList();
        return dateSet;
      } else if (maps.isEmpty) {
        return dateSet;
      } else {
        throw ServerException();
      }
    } on Exception catch (_) {
      throw ServerException();
    }
  }

  Map<DateTime, int> fromJson(Map<String, Object?> json) {
    Map<DateTime, int> dateSet = {};
    dateSet[DateTime.parse(json['date'] as String)] =
        json['isCompleted'] as int;
    return dateSet;
  }

  @override
  Future<int> fetchGoal() async {
    final db = await instance.database;
    final maps = await db!.rawQuery('select goal from user');
    if (maps.isNotEmpty) {
      var counts = maps.map((row) {
        return row['goal'] as int;
      }).toList();
      return counts.first;
    } else if (maps.isEmpty) {
      return 0;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> updateDayStatistics(DateTime date) async {
    final db = await instance.database;
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(date);
    await db!.insert('statistics', {'date': formattedDate, 'isCompleted': 1});
  }

  @override
  Future<void> updateGoal(int goalInMinutes) async {
    final db = await instance.database;
    await db!.update('user', {'goal': goalInMinutes});
  }

  @override
  Future<int> getTimeOnApp() async {
    final db = await instance.database;
    final maps = await db!.rawQuery('select timeOnApp from user');
    if (maps.isNotEmpty) {
      var counts = maps.map((row) {
        return row['timeOnApp'] as int;
      }).toList();
      return counts.first;
    } else if (maps.isEmpty) {
      return 0;
    } else {
      throw ServerException();
    }
  }
}
