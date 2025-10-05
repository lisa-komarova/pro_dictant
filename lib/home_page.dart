import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_dictant/core/s.dart';
import 'package:pro_dictant/features/profile/presentation/pages/profile_page.dart';
import 'package:pro_dictant/features/trainings/presentation/pages/trainings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'features/dictionary/presentation/pages/dictionary_page.dart';
import 'features/profile/presentation/manager/profile_bloc.dart';
import 'features/profile/presentation/manager/profile_event.dart';
import 'features/profile/presentation/manager/profile_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 1;
  InterstitialAd? _interstitialAd;
  late final Future<InterstitialAdLoader> _adLoader;
  int numberOfAdsShown = 0;

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(const LoadStatistics());
    getNumberOfAdsShown();
    MobileAds.initialize();
    _adLoader = _createInterstitialAdLoader();
    _loadInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
            if (numberOfAdsShown < 3) {
              _loadInterstitialAd();
              if (_interstitialAd != null) {
                _interstitialAd?.show();
                numberOfAdsShown++;
                saveNumberOfAdsShown(numberOfAdsShown);
              }
            }
          },
          selectedIndex: currentPageIndex,
          destinations: <Widget>[
            NavigationDestination(
              selectedIcon: Image.asset(
                'assets/icons/profile.png',
                width: 35,
                height: 35,
                color: const Color(0xFF243120),
              ),
              icon: Image.asset(
                'assets/icons/profile.png',
                width: 35,
                height: 35,
              ),
              label: S.of(context).profile,
            ),
            NavigationDestination(
              selectedIcon: Image.asset(
                'assets/icons/dictionary.png',
                width: 35,
                height: 35,
                color: const Color(0xFF243120),
              ),
              icon: Image.asset(
                'assets/icons/dictionary.png',
                width: 35,
                height: 35,
              ),
              label: S.of(context).dictionary,
            ),
            NavigationDestination(
              selectedIcon: Image.asset(
                'assets/icons/trainings.png',
                width: 35,
                height: 35,
                color: const Color(0xFF243120),
              ),
              icon: Image.asset(
                'assets/icons/trainings.png',
                width: 35,
                height: 35,
              ),
              label: S.of(context).trainings,
            ),
          ],
        ),
        body: <Widget>[
          const ProfilePage(),
          const DictionaryPage(),
          BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
            if (state is ProfileLoading) {
              return _loadingIndicator();
            } else if (state is ProfileLoaded) {
              return TrainingsPage(
                goal: state.statistics.goal,
                isTodayCompleted: state.statistics.isTodayCompleted,
              );
            } else {
              return const SizedBox();
            }
          }),
        ][currentPageIndex],
      ),
    );
  }

  Widget _loadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void saveNumberOfAdsShown(int number) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('numberOfAdsShown', number);
  }

  getNumberOfAdsShown() async {
    final prefs = await SharedPreferences.getInstance();
    numberOfAdsShown = prefs.getInt('numberOfAdsShown') ?? 0;
  }

  ///creates an ad
  Future<InterstitialAdLoader> _createInterstitialAdLoader() {
    return InterstitialAdLoader.create(
      onAdLoaded: (InterstitialAd interstitialAd) {
        // The ad was loaded successfully. Now you can show loaded ad
        _interstitialAd = interstitialAd;
      },
      onAdFailedToLoad: (error) {
        // Ad failed to load with AdRequestError.
        // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
      },
    );
  }

  ///loads an ad
  Future<void> _loadInterstitialAd() async {
    final adLoader = await _adLoader;
    await adLoader.loadAd(
        adRequestConfiguration: const AdRequestConfiguration(
            adUnitId:
                'R-M-13553505-2')); // for debug you can use 'demo-interstitial-yandex'
  }
}
