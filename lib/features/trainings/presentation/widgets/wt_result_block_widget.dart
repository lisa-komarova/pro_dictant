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
            child: GestureDetector(
              onTap: () {
                if (widget.answer == widget.correctAnswer) return;
                setState(() {
                  toShowCorrectAnswer = !toShowCorrectAnswer;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0x6BD9C3AC),
                    borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, bottom: 2),
                                child: Text(
                                  widget.source,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: toShowCorrectAnswer
                                      ? Text(
                                          widget.correctAnswer,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: const Color(0xFF85977f),
                                          ),
                                        )
                                      : Text(
                                          widget.answer,
                                          textAlign: TextAlign.start,
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
                    Padding(
                        padding: const EdgeInsets.only(right: 10.0),
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
