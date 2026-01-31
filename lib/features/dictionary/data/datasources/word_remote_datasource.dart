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
  Future<List<WordModel>> searchWord(String query) async {
    final baseUrl =
        'https://dictionary.yandex.net/api/v1/dicservice.json/lookup';
    const yandexApiKey = String.fromEnvironment('YANDEX_API_KEY');
    final queryParams = {
      'key':
      yandexApiKey,
      'lang': 'en-ru',
      'text': query
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final words = json.decode(response.body);
      return (words['def'] as List)
          .map((word) => WordModel.fromRemoteJson(word))
          .toList();
    }
    if (response.statusCode == 413) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }
}
