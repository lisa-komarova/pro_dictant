import 'package:pro_dictant/core/error/exception.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract class WordLocalDatasource {
  Future<WordModel> readWord(String query);

  Future<List<WordModel>> readWordsInDict();

  Future<void> updateWord(WordModel word);

  Future<void> addWord(WordModel word);

  Future<List<WordModel>> filterWordsInDict(String query);

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

  ///gets an instance of a datebase
  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("words.db");
    return _database;
  }

  ///initializes datebase
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);
    //await deleteDatabase(path);
    //ByteData data = await rootBundle.load("assets/words.db");
    //List<int> bytes =
    //    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    //await File(path).writeAsBytes(bytes);
    return await openDatabase(path, version: 1);
  }

  ///gets taro card by id
  Future<WordModel> readWord(String query) async {
    final db = await instance.database;
    final maps = await db!.query(
      tableWords,
      columns: WordsFields.values,
      where: '${WordsFields.source} = ?',
      whereArgs: [query],
    );
    if (maps.isNotEmpty) {
      return WordModel.fromJson(maps.first);
    } else {
      throw ServerException();
    }
  }

  Future<List<WordModel>> readWordsInDict() async {
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
}
