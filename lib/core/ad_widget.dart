import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

///builds banner ad
class BannerAdvertisement extends StatefulWidget {
  final int screenWidth;

  const BannerAdvertisement({super.key, required this.screenWidth});

  @override
  State<BannerAdvertisement> createState() => _BannerAdvertisementState();
}

class _BannerAdvertisementState extends State<BannerAdvertisement> {
  BannerAd? _bannerAd;
  var isBannerAlreadyCreated = false;

  _loadAd() async {
    _bannerAd = _createBanner();
    setState(() {
      isBannerAlreadyCreated = true;
    });
  }

  BannerAdSize _getAdSize() {
    return BannerAdSize.sticky(width: widget.screenWidth);
  }

  _createBanner() {
    return BannerAd(
        adUnitId: 'demo-banner-yandex',
        // or 'demo-banner-yandex'
        adSize: _getAdSize(),
        adRequest: const AdRequest(),
        onAdLoaded: () {
          if (!mounted) {
            _bannerAd!.destroy();
            return;
          }
        },
        onAdFailedToLoad: (error) {
          // Ad failed to load with AdRequestError.
          // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
        },
        onAdClicked: () {
          // Called when a click is recorded for an ad.
        },
        onLeftApplication: () {
          // Called when user is about to leave application (e.g., to go to the browser), as a result of clicking on the ad.
        },
        onReturnedToApplication: () {
          // Called when user returned to application after click.
        },
        onImpression: (impressionData) {
          // Called when an impression is recorded for an ad.
        });
  }

  @override
  void initState() {
    super.initState();
    MobileAds.initialize();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      width: double.infinity,
      child: _buildAd(),
    );
  }

  Widget _buildAd() {
    if (isBannerAlreadyCreated) {
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          child: AdWidget(bannerAd: _bannerAd!),
        ),
      );
    } else {
      return Container();
    }
  }
}
