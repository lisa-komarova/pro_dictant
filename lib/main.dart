import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/theme.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/profile/presentation/manager/profile_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/home_page.dart';
import 'package:pro_dictant/service_locator.dart' as di;
import 'package:pro_dictant/service_locator.dart';
import 'package:provider/provider.dart';
import 'core/s.dart';
import 'features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'features/trainings/presentation/manager/provider/combo_training_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<WordsBloc>(
            create: (BuildContext context) =>
                sl<WordsBloc>()..add(const LoadWords()),
          ),
          BlocProvider<SetBloc>(
              create: (BuildContext context) => sl<SetBloc>()),
          BlocProvider<TrainingsBloc>(
              create: (BuildContext context) => sl<TrainingsBloc>()),
          BlocProvider<ProfileBloc>(
              create: (BuildContext context) => sl<ProfileBloc>()),
        ],
        child: ChangeNotifierProvider<ComboTrainingSession>(
          create: (_) => sl<ComboTrainingSession>(),
          child: MaterialApp(
            supportedLocales: S.supportedLocales,
            localizationsDelegates: S.localizationDelegates,
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            home: const HomePage(),
          ),
        ));
  }
}
