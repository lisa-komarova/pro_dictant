import 'package:flutter/material.dart';

class TrainingCard extends StatelessWidget {
  final String image_name;
  final String training_name;

  const TrainingCard({
    super.key,
    required this.image_name,
    required this.training_name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: const Color(0xFFD9C3AC),
            ),
            color: Color(0xFFFFFFFF),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/icons/$image_name.png'),
            ),
          ),
        ),
        Text(training_name),
      ],
    );
  }
}
