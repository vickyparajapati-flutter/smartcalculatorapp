import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  // Set this to false when you are ready to publish with your Real AdMob Unit IDs!
  static const bool isTestMode = true;

  // Real AdMob IDs (Paste your real IDs here when approved by AdMob)
  static const String _realBannerAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
  static const String _realInterstitialAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ';

  // Official Google AdMob Sample / Test Ad Unit IDs (Google strictly requires these during development)
  static const String _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';

  static String get bannerAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return isTestMode ? _testBannerAndroid : _realBannerAndroid;
    }
    return '';
  }

  static String get interstitialAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return isTestMode ? _testInterstitialAndroid : _realInterstitialAndroid;
    }
    return '';
  }

  // Interstitial Ad Manager with Smart Cooldown (e.g. 60 seconds)
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialLoading = false;
  static DateTime? _lastInterstitialShownTime;
  static const Duration _adCooldown = Duration(seconds: 45);

  static Future<void> initialize() async {
    if (kIsWeb) return;
    try {
      await MobileAds.instance.initialize();
      loadInterstitialAd();
    } catch (e) {
      debugPrint('AdMob initialization error: $e');
    }
  }

  static void loadInterstitialAd() {
    if (kIsWeb || _isInterstitialLoading || _interstitialAd != null) return;
    final adUnitId = interstitialAdUnitId;
    if (adUnitId.isEmpty) return;

    _isInterstitialLoading = true;
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd(); // Preload next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd failed to load: $error');
          _interstitialAd = null;
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  static void showInterstitialAd({VoidCallback? onComplete}) {
    if (kIsWeb) {
      onComplete?.call();
      return;
    }

    final now = DateTime.now();
    // Check cooldown to avoid annoying users
    if (_lastInterstitialShownTime != null && now.difference(_lastInterstitialShownTime!) < _adCooldown) {
      onComplete?.call();
      return;
    }

    if (_interstitialAd != null) {
      _lastInterstitialShownTime = now;
      _interstitialAd!.show();
      onComplete?.call();
    } else {
      loadInterstitialAd();
      onComplete?.call();
    }
  }
}
