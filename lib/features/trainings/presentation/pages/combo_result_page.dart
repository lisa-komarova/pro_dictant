import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/trainings/domain/entities/wt_training_entity.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_event.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/combo_initial_page.dart';
import 'package:pro_dictant/features/trainings/presentation/widgets/continue_training_button.dart';
import '../../domain/entities/dictant_training_entity.dart';
import '../../domain/entities/tw_training_entity.dart';

class ComboResultPage extends StatelessWidget {
  final List<(String, String)> allWords;
  final List<WTTrainingEntity> wtInitialWrongAnswers;
  final List<TWTrainingEntity> twInitialWrongAnswers;
  final List<DictantTrainingEntity> dictantInitialWrongAnswers;

  const ComboResultPage({
    super.key,
    required this.allWords,
    required this.wtInitialWrongAnswers,
    required this.twInitialWrongAnswers,
    required this.dictantInitialWrongAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                return Navigator.of(context).pop();
              },
              icon: Semantics(
                  label: S.of(context).exitButton,
                  child: Image.asset('assets/icons/cancel.png'))),
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              S.of(context).results,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: allWords.length,
                semanticChildCount: allWords.length,
                itemBuilder: (context, index) {
                  final word = allWords[index];
                  final wtWrong =
                      wtInitialWrongAnswers.any((e) => e.source == word.$1);
                  final twWrong =
                      twInitialWrongAnswers.any((e) => e.source == word.$1);
                  final dictantWrong = dictantInitialWrongAnswers
                      .any((e) => e.source == word.$1);

                  return Semantics(
                    container: true,
                    explicitChildNodes: true,
                    child: Padding(

                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 5),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0x6BD9C3AC),
                                borderRadius: BorderRadius.circular(25)),
                            //padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      '${word.$1} ',
                                      locale: Locale('en'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      '${word.$2}',
                                      locale: Locale('ru'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildStatusItem(
                                          context,
                                          S.of(context).wordTranslation,
                                          'assets/icons/word-t.png',
                                          wtWrong),
                                      _buildStatusItem(
                                          context,
                                          S.of(context).translationWord,
                                          'assets/icons/t-word.png',
                                          twWrong),
                                      _buildStatusItem(
                                          context,
                                          S.of(context).dictant,
                                          'assets/icons/dictant.png',
                                          dictantWrong),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Image.asset(
                            'assets/icons/divider.png',
                            width: 15,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ContinueTrainingButton(
              onPressed: () {
                BlocProvider.of<TrainingsBloc>(context)
                    .add(const FetchWordsForComboTRainings());
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ComboInitialPage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
      BuildContext context, String label, String icon, bool isWrong) {
    return Expanded(
      child: Semantics(
        label: isWrong
            ? label + " " + S.of(context).wrongAnswer
            : label + " " + S.of(context).rightAnswer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(
                message: label,
                waitDuration: Duration(milliseconds: 100),
                showDuration: Duration(seconds: 2),
                preferBelow: false,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                textStyle: TextStyle(color: Colors.white),
                child: Image.asset(icon, width: 35, height: 35)),
            const SizedBox(width: 8),
            isWrong
                ? Image.asset(
                    'assets/icons/cancel.png',
                    width: 25,
                    height: 25,
                    color: Color(0xFFB70E0E),
                  )
                : Image.asset('assets/icons/add.png',
                    width: 25, height: 25, color: Color(0xFF85977f)),
          ],
        ),
      ),
    );
  }
}
