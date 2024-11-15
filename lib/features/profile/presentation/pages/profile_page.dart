import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
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
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(const LoadStatistics());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileLoading) {
        return _loadingIndicator();
      } else if (state is ProfileLoaded) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'в словаре: ${state.statistics.wordsInDictionary}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              'выучено: ${state.statistics.learntWords}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            GestureDetector(
                              onTap: () {
                                _dialogBuilder(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'цель: ${state.statistics.goal} мин',
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
                  )
                ],
              ),
            ),
            Flexible(
              child: _buildStatistics(context, state.statistics),
            ),
          ],
        );
      }
      return const SizedBox();
    });
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        //color: const Color(0xB3D9C3AC),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: HeatMapCalendar(
          //initDate: DateTime.now().subtract(const Duration(days: 30)),
          colorMode: ColorMode.color,
          showColorTip: false,
          textColor: Colors.white,
          weekTextColor: Colors.black,
          monthFontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
          defaultColor: const Color(0xFFB70E0E),
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
            'Изменить цель',
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
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('10 минут'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(const UpdateGoal(goalInMinutes: 15));
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('15 минут'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<ProfileBloc>(context)
                      .add(const UpdateGoal(goalInMinutes: 30));
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('30 минут'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
