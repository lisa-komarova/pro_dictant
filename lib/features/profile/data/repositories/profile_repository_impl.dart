import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:pro_dictant/core/error/failure.dart';
import 'package:pro_dictant/features/profile/domain/entities/statistics_entity.dart';
import 'package:pro_dictant/features/profile/domain/repositories/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';
import '../data_sources/profile_datasource.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileDatasource profileDatasource;

  ProfileRepositoryImpl({required this.profileDatasource});

  @override
  Future<Either<Failure, StatisticsEntity>> fetchStatistics() async {
    try {
      final numberOfWordsInDictionary =
          await profileDatasource.fetchNumberOfWordsInDictionary();
      final numberOfLearntWords =
          await profileDatasource.fetchNumberOfLearntWords();
      final goal = await profileDatasource.fetchGoal();
      final dateSets = await profileDatasource.fetchDatasets();
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);
      final prefs = await SharedPreferences.getInstance();
      String? day = prefs.getString('day');
      final bool isTodayCompleted;
      if (dateSets.isNotEmpty) {
        int isToday = dateSets.first.keys.first.compareTo(date);
        if (isToday == 0) {
          isTodayCompleted = true;
        } else {
          isTodayCompleted = false;
        }
      } else {
        isTodayCompleted = false;
      }
      if (day == null) {
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(date);
        prefs.setString('day', formattedDate);
        prefs.setString('timeOnApp', '');
        prefs.setInt('numberOfAdsShown', 0);
      } else if (DateTime.parse(day).compareTo(date) != 0) {
        prefs.setString('timeOnApp', '');
        prefs.setInt('numberOfAdsShown', 0);
        var formatter = DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(date);
        prefs.setString('day', formattedDate);
      }
      final StatisticsEntity statistics = StatisticsEntity(
          wordsInDictionary: numberOfWordsInDictionary,
          learntWords: numberOfLearntWords,
          goal: goal,
          isTodayCompleted: isTodayCompleted,
          dataSets: dateSets);
      return Right(statistics);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, StatisticsEntity>> updateDayStatistics(
      DateTime date) async {
    try {
      await profileDatasource.updateDayStatistics(date);
      final numberOfWordsInDictionary =
          await profileDatasource.fetchNumberOfWordsInDictionary();
      final numberOfLearntWords =
          await profileDatasource.fetchNumberOfLearntWords();
      final goal = await profileDatasource.fetchGoal();
      final dateSets = await profileDatasource.fetchDatasets();
      DateTime now = DateTime.now();
      DateTime dateNow = DateTime(now.year, now.month, now.day);
      final bool isTodayCompleted;
      if (dateSets.isNotEmpty) {
        int isToday = dateSets.first.keys.first.compareTo(dateNow);
        if (isToday == 0) {
          isTodayCompleted = true;
        } else {
          isTodayCompleted = false;
        }
      } else {
        isTodayCompleted = false;
      }
      final StatisticsEntity statistics = StatisticsEntity(
          wordsInDictionary: numberOfWordsInDictionary,
          learntWords: numberOfLearntWords,
          goal: goal,
          isTodayCompleted: isTodayCompleted,
          dataSets: dateSets);
      return Right(statistics);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, StatisticsEntity>> updateGoal(
      int goalInMinutes) async {
    try {
      await profileDatasource.updateGoal(goalInMinutes);
      final numberOfWordsInDictionary =
          await profileDatasource.fetchNumberOfWordsInDictionary();
      final numberOfLearntWords =
          await profileDatasource.fetchNumberOfLearntWords();
      final goal = await profileDatasource.fetchGoal();
      final dateSets = await profileDatasource.fetchDatasets();
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);
      final bool isTodayCompleted;
      if (dateSets.isNotEmpty) {
        int isToday = dateSets.first.keys.first.compareTo(date);
        if (isToday == 0) {
          isTodayCompleted = true;
        } else {
          isTodayCompleted = false;
        }
      } else {
        isTodayCompleted = false;
      }
      final StatisticsEntity statistics = StatisticsEntity(
          wordsInDictionary: numberOfWordsInDictionary,
          learntWords: numberOfLearntWords,
          goal: goal,
          isTodayCompleted: isTodayCompleted,
          dataSets: dateSets);
      return Right(statistics);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getTimeOnApp() async {
    try {
      final time = await profileDatasource.getTimeOnApp();
      return Right(time);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
