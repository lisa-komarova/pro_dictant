import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pro_dictant/core/error/exception.dart';
import 'package:pro_dictant/features/dictionary/data/models/word_model.dart';

abstract class WordRemoteDatasource {
  Future<List<WordModel>> searchWord(String query);
}

class WordRemoteDatasourceImpl implements WordRemoteDatasource {
  final http.Client client;

  WordRemoteDatasourceImpl({required this.client});

  @override
  Future<List<WordModel>> searchWord(String query) => _getWordFromUrl(
      '''https://dictionary.yandex.net/api/v1/dicservice.json/lookup?
      key=dict.1.1.20240604T075331Z.10377594721cb484.
      05fe0e4b76923b5b6fd28ab5b8763ee6772f698c&
      lang=en-ru&text=$query''');

  Future<List<WordModel>> _getWordFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final persons = json.decode(response.body);
      return (persons['results'] as List)
          .map((person) => WordModel.fromJson(person))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
