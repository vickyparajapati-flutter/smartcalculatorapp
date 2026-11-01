import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  // Uses Google's official test ad unit IDs in Debug Mode automatically (flutter run).
  // Automatically switches to Real AdMob IDs in Release Mode (flutter build apk / appbundle).
  static bool get isTestMode => kDebugMode;

  // ==================== REAL ADMOB PRODUCTION UNIT IDS ====================
  static const String _realBannerAndroid = 'ca-app-pub-7517890910821454/4341139953';
  static const String _realInterstitialAndroid = 'ca-app-pub-7517890910821454/9050541150';
  static const String _realAppOpenAndroid = 'ca-app-pub-7517890910821454/1714976611';

  // ==================== OFFICIAL GOOGLE TEST UNIT IDS ====================
  // Google strictly mandates these sample IDs during debug development
  static const String _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testAppOpenAndroid = 'ca-app-pub-3940256099942544/9257390508';

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

  // ==================== AD MANAGERS & COOLDOWNS ====================
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialLoading = false;
  static DateTime? _lastInterstitialShownTime;
  static const Duration _interstitialCooldown = Duration(seconds: 45);

  static AppOpenAd? _appOpenAd;
  static bool _isAppOpenLoading = false;
  static bool _isShowingAppOpen = false;

  static Future<void> initialize() async {
    if (kIsWeb) return;
    try {
      await MobileAds.instance.initialize();
      loadInterstitialAd();
      loadAppOpenAd();
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
}
