import 'package:flutter/material.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/training_card.dart';

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
              children: const <Widget>[
                TrainingCard(
                  training_name: 'слово-перевод',
                  image_name: 'word-t',
                ),
                TrainingCard(
                  training_name: 'перевод-слово',
                  image_name: 't-word',
                ),
                TrainingCard(
                  training_name: 'соответствие',
                  image_name: 'word_matching',
                ),
                TrainingCard(
                  training_name: 'карточки',
                  image_name: 'sprint',
                ),
                TrainingCard(
                  training_name: 'диктант',
                  image_name: 'dictant',
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
