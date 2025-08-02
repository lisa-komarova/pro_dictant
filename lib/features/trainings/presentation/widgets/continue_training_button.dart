import 'package:flutter/material.dart';

import '../../../../core/s.dart';

class ContinueTrainingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ContinueTrainingButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 50,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFD9C3AC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            S.of(context).continueTraining,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
