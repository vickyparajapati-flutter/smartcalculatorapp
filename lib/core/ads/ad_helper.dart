import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  // Uses Google's official test ad unit IDs in Debug Mode automatically (flutter run).
  // Automatically switches to Real AdMob IDs in Release Mode (flutter build apk / appbundle).
  static bool get isTestMode => kDebugMode;

  // ==================== REAL ADMOB UNIT IDS ====================
  // Paste your real AdMob Unit IDs here when your AdMob account is ready:
  static const String _realBannerAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY';
  static const String _realInterstitialAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ';
  static const String _realAppOpenAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/AAAAAAAAAA';
  static const String _realRewardedAndroid = 'ca-app-pub-XXXXXXXXXXXXXXXX/RRRRRRRRRR';

  // ==================== OFFICIAL GOOGLE TEST UNIT IDS ====================
  // Google strictly mandates these sample IDs during development & testing
  static const String _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testAppOpenAndroid = 'ca-app-pub-3940256099942544/9257390508';
  static const String _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';

  // 1. BANNER AD UNIT ID
  static String get bannerAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return isTestMode ? _testBannerAndroid : _realBannerAndroid;
    }
    return '';
  }

  // 2. INTERSTITIAL AD UNIT ID
  static String get interstitialAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return isTestMode ? _testInterstitialAndroid : _realInterstitialAndroid;
    }
    return '';
  }

  // 3. APP OPEN AD UNIT ID
  static String get appOpenAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return isTestMode ? _testAppOpenAndroid : _realAppOpenAndroid;
    }
    return '';
  }

  // 4. REWARDED AD UNIT ID
  static String get rewardedAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) {
      return isTestMode ? _testRewardedAndroid : _realRewardedAndroid;
    }
    return '';
  }

  // ==================== AD MANAGERS & COOLDOWNS ====================
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialLoading = false;
  static DateTime? _lastInterstitialShownTime;
  static const Duration _interstitialCooldown = Duration(seconds: 45);

  static AppOpenAd? _appOpenAd;
  static bool _isAppOpenLoading = false;
  static bool _isShowingAppOpen = false;

  static RewardedAd? _rewardedAd;
  static bool _isRewardedLoading = false;

  static Future<void> initialize() async {
    if (kIsWeb) return;
    try {
      await MobileAds.instance.initialize();
      loadInterstitialAd();
      loadAppOpenAd();
      loadRewardedAd();
    } catch (e) {
      debugPrint('AdMob initialization error: $e');
    }
  }

  // ---------- INTERSTITIAL ADS ----------
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
              loadInterstitialAd();
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
    if (_lastInterstitialShownTime != null && now.difference(_lastInterstitialShownTime!) < _interstitialCooldown) {
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

  // ---------- APP OPEN ADS (LAUNCH AD) ----------
  static void loadAppOpenAd() {
    if (kIsWeb || _isAppOpenLoading || _appOpenAd != null) return;
    final adUnitId = appOpenAdUnitId;
    if (adUnitId.isEmpty) return;

    _isAppOpenLoading = true;
    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAppOpenLoading = false;
          _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _appOpenAd = null;
              _isShowingAppOpen = false;
              loadAppOpenAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _appOpenAd = null;
              _isShowingAppOpen = false;
              loadAppOpenAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
          _appOpenAd = null;
          _isAppOpenLoading = false;
        },
      ),
    );
  }

  static void showAppOpenAdIfAvailable() {
    if (kIsWeb || _isShowingAppOpen || _appOpenAd == null) return;
    _isShowingAppOpen = true;
    _appOpenAd!.show();
  }

  // ---------- REWARDED ADS (OPTIONAL BONUS) ----------
  static void loadRewardedAd() {
    if (kIsWeb || _isRewardedLoading || _rewardedAd != null) return;
    final adUnitId = rewardedAdUnitId;
    if (adUnitId.isEmpty) return;

    _isRewardedLoading = true;
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _isRewardedLoading = false;
        },
      ),
    );
  }

  static void showRewardedAd({required Function(RewardItem reward) onRewarded, VoidCallback? onDismissed}) {
    if (kIsWeb || _rewardedAd == null) {
      loadRewardedAd();
      onDismissed?.call();
      return;
    }

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      onRewarded(reward);
    });
  }
}
