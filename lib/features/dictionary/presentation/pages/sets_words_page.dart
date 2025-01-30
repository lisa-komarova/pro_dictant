import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/domain/entities/set_entity.dart';

import '../manager/sets_bloc/set_bloc.dart';
import '../manager/sets_bloc/set_event.dart';
import '../widgets/set_words_list.dart';

class SetsWordsPage extends StatefulWidget {
  final SetEntity set;

  const SetsWordsPage({super.key, required this.set});

  @override
  State<SetsWordsPage> createState() => _SetsWordsPageState();
}

class _SetsWordsPageState extends State<SetsWordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.set.name.toUpperCase(),
          style: GoogleFonts.hachiMaruPop(),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            BlocProvider.of<SetBloc>(context).add(const LoadSets());
            Navigator.of(context).pop();
          },
          icon: Image.asset('assets/icons/cancel.png'),
        ),
      ),
      body: const SetWordsList(),
    );
  }
}
