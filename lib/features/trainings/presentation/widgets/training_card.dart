import 'package:flutter/material.dart';

class TrainingCard extends StatelessWidget {
  final String imageName;
  final String trainingName;

  const TrainingCard({
    super.key,
    required this.imageName,
    required this.trainingName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height: 150,
              // width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFFD9C3AC),
                ),
                color: const Color(0xFFFFFFFF),
              ),
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/icons/$imageName.png'),
                ),
              ),
            ),
          ),
        ),
        if (trainingName.isNotEmpty)
          Text(
            trainingName,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
