import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Controllers/adds.dart';
import 'Controllers/app_localizations.dart';

class Loading extends StatefulWidget {
  final bool dispMesage;
  Loading({this.dispMesage});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  InterstitialAd _interstitialAd;
  bool isInstertitialReady = false;

  @override
  void initState(){
    super.initState();
    if (widget.dispMesage == false){
      //FirebaseAdMob.instance.initialize(appId: Adds.appID);
      _interstitialAd = InterstitialAd(
        //adUnitId: Adds.loading,
        adUnitId: InterstitialAd.testAdUnitId,
        request: AdRequest(),
        listener: AdListener(
          onAdLoaded: (Ad ad){
            // Ad is now ready to show at any time.
            print("intersticial cargado");
            isInstertitialReady = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print(error);
            ad.dispose();
            isInstertitialReady = false;
          },
          onAdClosed: (Ad ad) {
            ad.dispose();
          },
        ),
      );
      if (isInstertitialReady = true){
        _loadInterstitial();
      }
    }
  }

  @override
  void dispose(){
    super.dispose();
    if (widget.dispMesage == false){
      _interstitialAd?.dispose();
    }
    
  }  

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF2F2F2),
      child: Center(
        child: Column(
          children: [
            Spacer(),
            SpinKitCubeGrid(
              color: Colors.blue,
              size: 80.0,
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                widget.dispMesage ? AppLocalizations.of(context).translate('loading_dialog'): '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15
                ),
              ),
            ),
            Spacer()
          ],
        )
      ),
    );
  }
  _loadInterstitial() async {
    //_interstitialAd..load()..show();
    await _interstitialAd.load();
    _interstitialAd.show();
  }
}

class LoadingNoAd extends StatefulWidget {
  @override
  _LoadingNoAdState createState() => _LoadingNoAdState();
}

class _LoadingNoAdState extends State<LoadingNoAd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF2F2F2),
      child: Center(
        child: SpinKitCubeGrid(
          color: Colors.blue,
          size: 80.0,
        ),
      ),
    );
  }
}