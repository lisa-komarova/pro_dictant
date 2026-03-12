import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pro_dictant/core/theme.dart';
import 'package:pro_dictant/features/authentification/presentation/pages/login_page.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/sets_bloc/set_bloc.dart';
import 'package:pro_dictant/features/dictionary/presentation/manager/words_bloc/words_event.dart';
import 'package:pro_dictant/features/profile/presentation/manager/profile_bloc.dart';
import 'package:pro_dictant/features/trainings/presentation/manager/trainings_bloc/trainings_bloc.dart';
import 'package:pro_dictant/service_locator.dart' as di;
import 'package:pro_dictant/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/s.dart';
import 'features/authentification/presentation/manager/login_bloc/login_bloc.dart';
import 'features/dictionary/presentation/manager/words_bloc/words_bloc.dart';
import 'features/trainings/presentation/manager/provider/combo_training_session.dart';
import 'firebase_options.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  await sl<GoogleSignIn>().initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  User? user = FirebaseAuth.instance.currentUser;
  bool skipLogin = true;

  if (user == null) {
    skipLogin = await shouldSkipLogin();
  }

  runApp(MyApp(user: user, skipLogin: skipLogin));
}

class MyApp extends StatelessWidget {
  final User? user;
  final bool skipLogin;

  const MyApp({super.key, required this.user, required this.skipLogin});

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
          BlocProvider<LoginBloc>(create: (context) => sl<LoginBloc>()),
        ],
        child: ChangeNotifierProvider<ComboTrainingSession>(
          create: (_) => sl<ComboTrainingSession>(),
          child: MaterialApp(
            supportedLocales: S.supportedLocales,
            localizationsDelegates: S.localizationDelegates,
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            home: user != null
                ? HomePage()
                : skipLogin
                    ? HomePage()
                    : LoginPage(),
          ),
        ));
  }
}

Future<bool> shouldSkipLogin() async {
  final prefs = await SharedPreferences.getInstance();

  bool? hasSeen = prefs.getBool('hasSeenLoginCheck');

  if (hasSeen == null || hasSeen == false) {
    return false;
  }

  return true;
}
