import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/tw_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/wt_in_process_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/training_card.dart';

import 'dictant_in_process_page.dart';
import 'matching_in_process_page.dart';

class TrainingsPage extends StatelessWidget {
  const TrainingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Expanded(
            child: GridView.count(
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              childAspectRatio: 0.95,
              children: <Widget>[
                GestureDetector(
                  child: TrainingCard(
                    training_name: 'слово-перевод',
                    image_name: 'word-t',
                  ),
                  onTap: () {
                    BlocProvider.of<TrainingsBloc>(context)
                        .add(FetchWordsForWtTRainings());
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => WTInProcessPage()));
                  },
                ),
                GestureDetector(
                  child: TrainingCard(
                    training_name: 'перевод-слово',
                    image_name: 't-word',
                  ),
                  onTap: () {
                    BlocProvider.of<TrainingsBloc>(context)
                        .add(FetchWordsForTwTRainings());
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => TWInProcessPage()));
                  },
                ),
                GestureDetector(
                  child: TrainingCard(
                    training_name: 'соответствие',
                    image_name: 'word_matching',
                  ),
                  onTap: () {
                    BlocProvider.of<TrainingsBloc>(context)
                        .add(FetchWordsForMatchingTRainings());
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => MatchingInProcessPage()));
                  },
                ),
                TrainingCard(
                  training_name: 'карточки',
                  image_name: 'sprint',
                ),
                GestureDetector(
                  child: TrainingCard(
                    training_name: 'диктант',
                    image_name: 'dictant',
                  ),
                  onTap: () {
                    BlocProvider.of<TrainingsBloc>(context)
                        .add(FetchWordsForDictantTRainings());
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => DictantInProcessPage()));
                  },
                ),
                TrainingCard(
                  training_name: 'повторение',
                  image_name: 'repetition',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
