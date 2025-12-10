import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';

class DictionaryFilterButtons extends StatefulWidget {
  final bool isNewSelected;
  final bool isLearntSelected;
  final bool isLearningSelected;

  const DictionaryFilterButtons({
    super.key,
    required this.isNewSelected,
    required this.isLearntSelected,
    required this.isLearningSelected,
  });

  @override
  State<DictionaryFilterButtons> createState() =>
      _DictionaryFilterButtonState();
}

class _DictionaryFilterButtonState extends State<DictionaryFilterButtons> {
  Color colorNew = const Color(0xFFB70E0E);
  Color colorLearning = const Color(0xFFd9c3ac);
  Color colorLearnt = const Color(0xFF85977f);
  late String titleNew;
  late String titleLearning;
  late String titleLearnt;
  bool isNewSelected = false;
  bool isLearningSelected = false;
  bool isLearntSelected = false;
  final double _buttonWidth = 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    titleNew = S.of(context).newWords;
    titleLearning = S.of(context).learning;
    titleLearnt = S.of(context).learnt;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    isNewSelected = widget.isNewSelected;
    isLearningSelected = widget.isLearningSelected;
    isLearntSelected = widget.isLearntSelected;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAButton(
            title: titleNew, color: colorNew, isSelected: isNewSelected),
        _buildAButton(
            title: titleLearning,
            color: colorLearning,
            isSelected: isLearningSelected),
        _buildAButton(
            title: titleLearnt,
            color: colorLearnt,
            isSelected: isLearntSelected),
      ],
    );
  }

  _buildAButton(
      {required String title, required Color color, required bool isSelected}) {
    String isSelectedString =
        isSelected ? S.of(context).selected : S.of(context).notSelected;
    return Flexible(
      child: Semantics(
        label: S.of(context).filterButton(title) + isSelectedString,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            ),
            height: 50,
            width: isSelected ? _buttonWidth * 1.5 : _buttonWidth,
            duration: Durations.short4,
            child: Stack(children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ExcludeSemantics (
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hachiMaruPop(
                          color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
              ),
              SizedBox.expand(
                child: ExcludeSemantics(
                  child: FilledButton(
                      onPressed: () {
                        setState(() {
                          if (title == titleNew) {
                            isNewSelected = !isNewSelected;
                            isLearningSelected = false;
                            isLearntSelected = false;
                            if (isNewSelected == false) {
                              BlocProvider.of<WordsBloc>(context)
                                  .add(const LoadWords());
                            } else {
                              BlocProvider.of<WordsBloc>(context)
                                  .add(const FilterWords('', true, false, false));
                            }
                          } else if (title == titleLearning) {
                            isNewSelected = false;
                            isLearningSelected = !isLearningSelected;
                            isLearntSelected = false;
                            if (isLearningSelected == false) {
                              BlocProvider.of<WordsBloc>(context)
                                  .add(const LoadWords());
                            } else {
                              BlocProvider.of<WordsBloc>(context)
                                  .add(const FilterWords('', false, true, false));
                            }
                          } else if (title == titleLearnt) {
                            isNewSelected = false;
                            isLearningSelected = false;
                            isLearntSelected = !isLearntSelected;
                            if (isLearntSelected == false) {
                              BlocProvider.of<WordsBloc>(context)
                                  .add(const LoadWords());
                            } else {
                              BlocProvider.of<WordsBloc>(context)
                                  .add(const FilterWords('', false, false, true));
                            }
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: null),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
