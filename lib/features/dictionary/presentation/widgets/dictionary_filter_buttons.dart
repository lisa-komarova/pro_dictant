import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';

class DictionaryFilterButtons extends StatefulWidget {
  const DictionaryFilterButtons({
    super.key,
  });

  @override
  State<DictionaryFilterButtons> createState() =>
      _DictionaryFilterButtonState();
}

class _DictionaryFilterButtonState extends State<DictionaryFilterButtons> {
  Color colorNew = const Color(0xFFB70E0E);
  Color colorLearning = const Color(0xFFd9c3ac);
  Color colorLearnt = const Color(0xFF85977f);
  String titleNew = "Новые";
  String titleLearning = "На\nизучении";
  String titleLearnt = "Изученные";
  bool isNewSelected = false;
  bool isLearningSelected = false;
  bool isLearntSelected = false;
  double _buttonWidth = 100;

  @override
  Widget build(BuildContext context) {
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
    return Flexible(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (title == titleNew) {
              isNewSelected = !isNewSelected;
              isLearningSelected = false;
              isLearntSelected = false;
              if (isNewSelected == false) {
                BlocProvider.of<WordsBloc>(context).add(LoadWords());
              } else {
                BlocProvider.of<WordsBloc>(context)
                    .add(FilterWords('', true, false, false));
              }
            } else if (title == titleLearning) {
              isNewSelected = false;
              isLearningSelected = !isLearningSelected;
              isLearntSelected = false;
              if (isLearningSelected == false) {
                BlocProvider.of<WordsBloc>(context).add(LoadWords());
              } else {
                BlocProvider.of<WordsBloc>(context)
                    .add(FilterWords('', false, true, false));
              }
            } else if (title == titleLearnt) {
              isNewSelected = false;
              isLearningSelected = false;
              isLearntSelected = !isLearntSelected;
              if (isLearntSelected == false) {
                BlocProvider.of<WordsBloc>(context).add(LoadWords());
              } else {
                BlocProvider.of<WordsBloc>(context)
                    .add(FilterWords('', false, false, true));
              }
            }
          });
        },
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.hachiMaruPop(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
