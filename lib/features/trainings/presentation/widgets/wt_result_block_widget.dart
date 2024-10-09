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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.source),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(' - '),
                ),
                Flexible(
                  flex: 4,
                  child: Expanded(
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
                                    color: widget.answer == widget.correctAnswer
                                        ? Color(0xFF85977f)
                                        : Color(0xFFB70E0E),
                                  ),
                                )),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.answer != widget.correctAnswer
                          ? Image.asset(
                              'assets/icons/cancel.png',
                              width: 15,
                              height: 15,
                            )
                          : Image.asset(
                              'assets/icons/add.png',
                              width: 15,
                              height: 15,
                            )),
                ),
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
