import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/theme.dart';
import 'package:pro_dictant/features/dictionary/presentation/words_bloc/words_event.dart';
import 'package:pro_dictant/home_page.dart';
import 'package:pro_dictant/service_locator.dart' as di;
import 'package:pro_dictant/service_locator.dart';

import 'features/dictionary/presentation/words_bloc/words_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WordsBloc>(
        create: (context) => sl<WordsBloc>()..add(LoadWords()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: app_theme,
          home: const HomePage(),
        ));
  }
}
