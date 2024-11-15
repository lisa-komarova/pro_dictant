class StatisticsEntity {
  final int wordsInDictionary;
  final int learntWords;
  final int goal;
  bool isTodayCompleted;
  final List<Map<DateTime, int>> dataSets;

  StatisticsEntity(
      {required this.wordsInDictionary,
      required this.learntWords,
      required this.goal,
      required this.isTodayCompleted,
      required this.dataSets});
}
