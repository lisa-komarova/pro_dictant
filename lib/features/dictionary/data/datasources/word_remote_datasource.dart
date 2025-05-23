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

    final queryParams = {
      'key':
          'dict.1.1.20240604T075331Z.10377594721cb484.05fe0e4b76923b5b6fd28ab5b8763ee6772f698c',
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
