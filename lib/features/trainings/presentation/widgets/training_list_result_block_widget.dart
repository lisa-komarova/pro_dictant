import 'package:flutter/material.dart';

class TrainingListResultBlockWidget extends StatefulWidget {
  const TrainingListResultBlockWidget({
    super.key,
    required this.source,
    this.answer,
    required this.correctAnswer,
  });

  final String source;
  final String? answer;
  final String correctAnswer;

  @override
  State<TrainingListResultBlockWidget> createState() => _TrainingListResultBlockWidgetState();
}

class _TrainingListResultBlockWidgetState extends State<TrainingListResultBlockWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Column(
        children: [
          Expanded(
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
                              padding:
                                  const EdgeInsets.only(left: 10.0, bottom: 2),
                              child: Text(
                                widget.source,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        widget.answer != null
                            ? Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        widget.answer!,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: widget.answer ==
                                                  widget.correctAnswer
                                              ? const Color(0xFF85977f)
                                              : const Color(0xFFB70E0E),
                                        ),
                                      )),
                                ),
                              )
                            : SizedBox.shrink(),
                        widget.answer != widget.correctAnswer
                            ? Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      widget.correctAnswer,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: const Color(0xFF85977f),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: widget.answer != null
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
