import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pro_dictant/core/platform/network_info.dart';
import 'package:pro_dictant/features/dictionary/data/datasources/word_local_datasource.dart';
import 'package:pro_dictant/features/dictionary/data/datasources/word_remote_datasource.dart';
import 'package:pro_dictant/features/dictionary/data/repositories/set_repository_impl.dart';
import 'package:pro_dictant/features/dictionary/data/repositories/word_repository_impl.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/set_repository.dart';
import 'package:pro_dictant/features/dictionary/domain/repositories/word_repository.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/delete_word_from_dictionary.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_word_by_source.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/load_all_words_in_dict.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/load_sets.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/update_word.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';

import 'features/dictionary/domain/usecases/add_word.dart';
import 'features/dictionary/domain/usecases/filter_words.dart';
import 'features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC / Cubit

  sl.registerFactory(
    () => WordsBloc(
        loadWords: sl(),
        filterWords: sl(),
        deleteWordFromDictionary: sl(),
        updateWord: sl(),
        addWord: sl(),
        fetchWordBySource: sl()),
  );
  sl.registerFactory(() => SetBloc(
        loadSets: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => LoadAllWordsInDict(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchWordBySource(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => LoadSets(
        setRepository: sl(),
      ));
  sl.registerLazySingleton(() => FilterWords(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => DeleteWordFromDictionary(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => UpdateWord(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => AddWord(
        wordRepository: sl(),
      ));
  // Repository
  sl.registerLazySingleton<WordRepository>(
    () => WordRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<SetRepository>(
    () => SetRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<WordRemoteDatasource>(
    () => WordRemoteDatasourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<WordLocalDatasource>(
    () => WordsLocalDatasourceImpl(),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(sl()),
  );

  // External
  //final sharedPreferences = await SharedPreferences.getInstance();
  //sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
