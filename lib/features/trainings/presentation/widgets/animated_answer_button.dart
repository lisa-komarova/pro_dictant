import 'package:flutter/material.dart';

class AnimatedAnswerButton extends StatefulWidget {
  final String text;
  final Color color;
  final Locale locale;
  final VoidCallback onTap;

  const AnimatedAnswerButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.locale ,
  });

  @override
  State<AnimatedAnswerButton> createState() => _AnimatedAnswerButtonState();
}

class _AnimatedAnswerButtonState extends State<AnimatedAnswerButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      decoration: BoxDecoration(
        color: pressed ? widget.color : const Color(0xFFd9c3ac),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          setState(() => pressed = true);
          await Future.delayed(const Duration(milliseconds: 150));
          setState(() => pressed = false);
          widget.onTap();
        },
        child: Center(
          child: Text(
            widget.text,
            locale: widget.locale ,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}