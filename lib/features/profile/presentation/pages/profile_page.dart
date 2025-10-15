import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/profile/domain/entities/statistics_entity.dart';
import 'package:pro_dictant/features/profile/presentation/manager/profile_bloc.dart';
import 'package:pro_dictant/features/profile/presentation/manager/profile_event.dart';
import 'package:pro_dictant/features/profile/presentation/manager/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime dateNow = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return _loadingIndicator();
            } else if (state is ProfileLoaded) {
              return RefreshIndicator(
                onRefresh: _refreshPage,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              S.of(context).addedWords(
                                  state.statistics.wordsInDictionary),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              S
                                  .of(context)
                                  .learntWords(state.statistics.learntWords),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            GestureDetector(
                              onTap: () => _dialogBuilder(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).goal(state.statistics.goal),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Image.asset(
                                    'assets/icons/dictant.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Скроллируемая статистика
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: _buildStatistics(context, state.statistics),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  _buildStatistics(BuildContext context, StatisticsEntity statisticsEntity) {
    final Map<DateTime, int> dateSets = {};
    for (int i = 0; i < statisticsEntity.dataSets.length; i++) {
      dateSets.addAll(statisticsEntity.dataSets[i]);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: HeatMap(
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now(),
          scrollable: true,
          colorMode: ColorMode.color,
          showColorTip: false,
          showText: true,
          textColor: Colors.black,
          defaultColor: const Color(0xFFd9c3ac),
          size: 35,
          borderRadius: 25,
          colorsets: const {
            1: Color(0xFF85977F),
          },
          datasets: dateSets,
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            S.of(context).changeGoal,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(const UpdateGoal(goalInMinutes: 10));
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).tenMinutes),
                ),
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(const UpdateGoal(goalInMinutes: 15));
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).fifteenMinutes),
                ),
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(const UpdateGoal(goalInMinutes: 30));
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).thirtyMinutes),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                foregroundColor: const Color(0xFFB70E0E),
              ),
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshPage() async {
    BlocProvider.of<ProfileBloc>(context).add(const LoadStatistics());
  }
}
