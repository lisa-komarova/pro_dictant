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
import 'package:pro_dictant/features/dictionary/domain/usecases/add_set.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/add_translation.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/add_words_from_set_to_dictionary.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/delete_translation.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/delete_word_from_dictionary.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_all_words_in_dict.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_sets.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_translations_for_searched_words_in_set.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_translations_for_words_in_set.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_word_by_source.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/fetch_words_for_sets.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/searchWordsForASet.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/update_translation.dart';
import 'package:pro_dictant/features/dictionary/domain/usecases/update_word.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/trainings/data/data_sources/trainings_datasource.dart';
import 'package:pro_dictant/features/trainings/data/repositories/trainings_repository_impl.dart';
import 'package:pro_dictant/features/trainings/domain/repositories/trainings_repository.dart';
import 'package:pro_dictant/features/trainings/domain/use_cases/add_suggested_sources_to_words_in_tw.dart';
import 'package:pro_dictant/features/trainings/domain/use_cases/add_suggested_translations_to_words_in_wt.dart';
import 'package:pro_dictant/features/trainings/domain/use_cases/fetch_words_for_dictant_training.dart';
import 'package:pro_dictant/features/trainings/domain/use_cases/fetch_words_for_matching_training.dart';
import 'package:pro_dictant/features/trainings/domain/use_cases/fetch_words_for_wt_training.dart';
import 'package:pro_dictant/features/trainings/domain/use_cases/update_words_for_tw_trainings.dart';
import 'package:pro_dictant/features/trainings/domain/use_cases/update_words_for_wt_trainings.dart';

import 'features/dictionary/domain/usecases/add_word.dart';
import 'features/dictionary/domain/usecases/delete_set.dart';
import 'features/dictionary/domain/usecases/fetch_translations_for_words.dart';
import 'features/dictionary/domain/usecases/filter_words.dart';
import 'features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';
import 'features/trainings/domain/use_cases/fetch_words_for_cards_training.dart';
import 'features/trainings/domain/use_cases/fetch_words_for_tw_training.dart';
import 'features/trainings/domain/use_cases/update_words_for_cards_training.dart';
import 'features/trainings/domain/use_cases/update_words_for_dictant_training.dart';
import 'features/trainings/domain/use_cases/update_words_for_matching_training.dart';
import 'features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';

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
      fetchWordBySource: sl(),
      searchWordsForASet: sl(),
      updateTranslation: sl(),
      fetchTranslationsForWords: sl(),
      fetchTranslationsForSearchedWordsInSet: sl(),
      deleteTranslation: sl(),
      addTranslation: sl(),
      addWordsFromSetToDictionary: sl(),
    ),
  );
  sl.registerFactory(() => SetBloc(
        loadSets: sl(),
        addSet: sl(),
        fetchWordsForSets: sl(),
        fetchTranslationsForWordsInSet: sl(),
        deleteSet: sl(),
      ));
  sl.registerFactory(() => TrainingsBloc(
        fetchWordsForWtTraining: sl(),
        fetchWordsForTwTRainings: sl(),
        fetchWordsForMatchingTRaining: sl(),
        fetchWordsForDictantTraining: sl(),
        addSuggestedTranslationsToWordsInWT: sl(),
        addSuggestedSourcesToWordsInTW: sl(),
        updateWordsForWTTraining: sl(),
        updateWordsForTWTraining: sl(),
        updateWordsForMatchingTraining: sl(),
        updateWordsForDictantTraining: sl(),
        updateWordsForCardsTraining: sl(),
        fetchWordsForCardsTraining: sl(),
      ));
  // UseCases
  sl.registerLazySingleton(() => FetchAllWordsInDict(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchWordBySource(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchSets(
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
  sl.registerLazySingleton(() => AddWordsFromSetToDictionary(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => SearchWordsForASet(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => AddSet(
        setRepository: sl(),
      ));
  sl.registerLazySingleton(() => DeleteSet(
        setRepository: sl(),
      ));
  sl.registerLazySingleton(() => UpdateTranslation(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchWordsForWTTraining(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => AddSuggestedTranslationsToWordsInWT(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchWordsForSets(
        setRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchTranslationsForWords(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => DeleteTranslation(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => AddTranslation(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => UpdateWordsForWTTraining(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => AddSuggestedSourcesToWordsInTW(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchWordsForTWTraining(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchWordsForMatchingTraining(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => UpdateWordsForTWTraining(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchWordsForDictantTraining(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchWordsForCardsTraining(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => UpdateWordsForMatchingTraining(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => UpdateWordsForDictantTraining(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => UpdateWordsForCardsTraining(
        trainingsRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchTranslationsForWordsInSet(
        wordRepository: sl(),
      ));
  sl.registerLazySingleton(() => FetchTranslationsForSearchedWordsInSet(
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
  sl.registerLazySingleton<TrainingsRepository>(
    () => TrainingsRepositoryImpl(
      trainingsDataSource: sl(),
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
  sl.registerLazySingleton<TrainingsDatasource>(
    () => TrainingsDatasourceImpl(),
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
