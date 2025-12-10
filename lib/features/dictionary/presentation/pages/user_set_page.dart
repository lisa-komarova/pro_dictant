import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/dictionary/presentation/pages/new_set_page.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/set_list.dart';

import '../manager/words_bloc/words_bloc.dart';
import '../manager/words_bloc/words_event.dart';

class UserSetPage extends StatefulWidget {
  const UserSetPage({super.key});

  @override
  State<UserSetPage> createState() => _UserSetPageState();
}

class _UserSetPageState extends State<UserSetPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).wordSets,
            style: GoogleFonts.hachiMaruPop(),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
                BlocProvider.of<WordsBloc>(context).add(const LoadWords());
              },
              icon: Semantics(
                  label: S.of(context).exitButton,
                  child: Image.asset('assets/icons/cancel.png'))),
        ),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.of(context).pop();
            FocusScope.of(context).unfocus();
            BlocProvider.of<WordsBloc>(context).add(const LoadWords());
          },
          child: const Column(
            children: [
              Expanded(child: SetList()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => const NewSetPage()));
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          label: Text(
            S.of(context).newSet,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
