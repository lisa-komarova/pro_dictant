import 'package:flutter/material.dart';

class WTResultBlockWidget extends StatefulWidget {
  const WTResultBlockWidget({
    super.key,
    required this.source,
    required this.answer,
    required this.correctAnswer,
  });

  final String source;
  final String answer;
  final String correctAnswer;

  @override
  State<WTResultBlockWidget> createState() => _WTResultBlockWidgetState();
}

class _WTResultBlockWidgetState extends State<WTResultBlockWidget> {
  bool toShowCorrectAnswer = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.source),
                            ),
                          ),
                          const Text(' - '),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  toShowCorrectAnswer = !toShowCorrectAnswer;
                                });
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: toShowCorrectAnswer
                                      ? Text(widget.correctAnswer)
                                      : Text(
                                          widget.answer,
                                          style: TextStyle(
                                            color: widget.answer ==
                                                    widget.correctAnswer
                                                ? const Color(0xFF85977f)
                                                : const Color(0xFFB70E0E),
                                          ),
                                        )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.answer != widget.correctAnswer
                        ? Image.asset(
                            'assets/icons/cancel.png',
                            width: 15,
                            height: 15,
                            color: const Color(0xFFB70E0E),
                          )
                        : null),
              ],
            ),
          ),
          Image.asset(
            'assets/icons/divider.png',
            width: 15,
            height: 15,
          ),
        ],
      ),
    );
  }
}
