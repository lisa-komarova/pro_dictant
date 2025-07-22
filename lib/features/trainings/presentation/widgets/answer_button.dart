import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AnswerButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String text;
  final ButtonStyle? style;

  const AnswerButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  State<AnswerButton> createState() => _SafeButtonState();
}

class _SafeButtonState extends State<AnswerButton> {
  bool _isProcessing = false;

  Future<void> _handlePress() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      await widget.onPressed();
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: _isProcessing ? null : _handlePress,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFd9c3ac),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AutoSizeText(
            widget.text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
