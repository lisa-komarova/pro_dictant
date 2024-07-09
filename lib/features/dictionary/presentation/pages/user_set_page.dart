import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_dictant/features/dictionary/presentation/widgets/set_list.dart';

class UserSetPage extends StatefulWidget {
  UserSetPage({super.key});

  @override
  State<UserSetPage> createState() => _UserSetPageState();
}

class _UserSetPageState extends State<UserSetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Наборы слов",
          style: GoogleFonts.hachiMaruPop(),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Image.asset('assets/icons/cancel.png')),
      ),
      body: const Column(
        children: [
          SetList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //   _showNewDialog(context);
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        label: const Text(
          'новый \nнабор',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

// Future<void> _showNewDialog(BuildContext context) {
//   //TODO add mapper and replace wordmodel
//   final word = WordModel(
//       id: const Uuid().v4(),
//       source: '',
//       pos: '',
//       transcription: '',
//       translations: '');
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         content: WordForm(
//           word: word,
//           isNew: true,
//         ),
//       );
//     },
//   );
// }
}
