

import 'dart:io' ;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sonidos_de_lluvia_para_dormir/config/appConfig.dart';


class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  static bool isLoaded=false;

  /// Load an AppOpenAd.
  void loadAd() {
    AppOpenAd.load(
      adUnitId: Platform.isAndroid ?_asigno_android() :_asigno_IOS(),         
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print("Ad Loadede.................................");
          _appOpenAd = ad;
          isLoaded=true;
        },
        onAdFailedToLoad: (error) {
          // Handle the error.
        },
      ),
    );
  }

 String _asigno_android() => AppConfig.IS_DEBUG ?AppConfig.CARGA_DE_APLICACION_AD_ID_ANDROID_TEST : AppConfig.CARGA_DE_APLICACION_AD_ID_ANDROID_PROD ;
 String _asigno_IOS()     => AppConfig.IS_DEBUG ?AppConfig.CARGA_DE_APLICACION_AD_ID_IOS_TEST     : AppConfig.CARGA_DE_APLICACION_AD_ID_IOS_PROD;


  // Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (_appOpenAd == null) {
      loadAd();
      return;
    }
    if (_isShowingAd) {
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}