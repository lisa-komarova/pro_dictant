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
    _createBanner();
    setState(() {
      isBannerAlreadyCreated = true;
    });
  }

  void _createBanner() {
    final banner = BannerAd(adSize: BannerAdSize.sticky(width: widget.screenWidth));

    banner.loadStateStream.listen((state) {
      if (state is BannerAdLoadStateLoaded) {
        // Ad loaded
      } else if (state is BannerAdLoadStateError) {
        // Ad failed to load
      }
    });

    banner.events.listen((event) {
      if (event is BannerAdClickedEvent) {
        // Ad clicked
      } else if (event is BannerAdImpressionEvent) {
        // Impression
      }
    });

    banner.load(AdRequest(adUnitId: 'R-M-13553505-1'));
    _bannerAd = banner;
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
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
