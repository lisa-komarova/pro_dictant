import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../../core/s.dart';

class RepetitionAnswerButtons extends StatefulWidget {
  final Function(bool positive, bool neutral, bool negative) onTap;

  const RepetitionAnswerButtons({super.key, required this.onTap});

  @override
  State<RepetitionAnswerButtons> createState() =>
      _RepetitionAnswerButtonsState();
}

class _RepetitionAnswerButtonsState extends State<RepetitionAnswerButtons> {
  bool press1 = false;
  bool press2 = false;
  bool press3 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildBtn(
          text: S.of(context).iKnowWontForget,
          normal: const Color(0xFFd9c3ac),
          pressed: const Color(0xFF85977f),
          isPressed: press1,
          onTap: () async {
            setState(() => press1 = true);
            await Future.delayed(const Duration(milliseconds: 150));
            setState(() => press1 = false);
            widget.onTap(true, false, false);
          },
        ),
        buildBtn(
          text: S.of(context).iKnowMightForget,
          normal: const Color(0xFFd9c3ac),
          pressed: Colors.white,
          isPressed: press2,
          onTap: () async {
            setState(() => press2 = true);
            await Future.delayed(const Duration(milliseconds: 150));
            setState(() => press2 = false);
            widget.onTap(false, true, false);
          },
        ),
        buildBtn(
          text: S.of(context).iDontRemember,
          normal: const Color(0xFFd9c3ac),
          pressed: const Color(0xFFB70E0E),
          isPressed: press3,
          onTap: () async {
            setState(() => press3 = true);
            await Future.delayed(const Duration(milliseconds: 150));
            setState(() => press3 = false);
            widget.onTap(false, false, true);
          },
        ),
      ],
    );
  }

  Widget buildBtn({
    required String text,
    required Color normal,
    required Color pressed,
    required bool isPressed,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      margin: const EdgeInsets.all(8),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isPressed ? pressed : normal,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Center(
          child: AutoSizeText(text, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
