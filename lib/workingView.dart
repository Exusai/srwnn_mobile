import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srwnn_mobile/imageView.dart';
import 'package:srwnn_mobile/main.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'Controllers/adds.dart';
import 'Controllers/app_localizations.dart';
import 'Controllers/databaseService.dart';
import 'Models/generator.dart';
import 'Models/onlineGenerator.dart';
import 'Models/subscriptionData.dart';
import 'Models/user.dart';
import 'buyCR.dart';
import 'dialogs.dart';
import 'loading.dart';

//import 'package:admob_flutter/admob_flutter.dart';

class InferenceView extends StatefulWidget {
  final File image;
  final String modelPath;
  final bool showAds;

  InferenceView({this.image, this.modelPath, this.showAds});
  @override
  _InferenceViewState createState() => _InferenceViewState();
}



class _InferenceViewState extends State<InferenceView> {
  File newImage;
  TensorImage tensorImage = TensorImage.fromFile(image);
  bool loading = false;
  bool dispMSG = false;
  bool error = false;
  bool imageError = false;
  bool alocationError = false;
  //String warning = ;
  
  BannerAd _bannerAd;
  //Widget banner;

  @override
  void initState(){
    super.initState();
    if (selector.executionOnline == true && widget.showAds == true){
      //Admob.initialize(Adds.appID);
      _bannerAd = BannerAd(adUnitId: Adds.banner, size: AdSize.banner);
      //Widget banner = AdmobBanner(adUnitId: Adds.banner, adSize: AdmobBannerSize.BANNER);
      _loadBanner();
    }
  }

  @override
  void dispose(){
    super.dispose();
    if (selector.executionOnline == true && widget.showAds == true){
      _bannerAd.dispose();
    }
    image = null;
    newImage = null;
  } 
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuario>(context) ?? Usuario(uid: '', isAnon: true);
    ///
    /// Floating button
    ///
    Widget floatProcessButton = FloatingActionButton(
      onPressed: ()async{
        if (selector.executionOnline == true) {
          setState(() => loading = true);
          setState(() => dispMSG = false);
          if (widget.showAds) await _bannerAd.dispose();
          _bannerAd = null;
          imageCache.clear();
          newImage = null;
          SRWGeneratorOnline genOnline = SRWGeneratorOnline(image: image, modelConfig: selector.getModelConfig());
          try{
            newImage = await genOnline.generate2xImage();
            setState(() => error = false);
            setState(() => imageError = false);
          } on Error {
            //setState(() => loading = false);
            setState(() => error = true);
          } on Exception{
            setState(() => imageError = true);
          }
        }
        else if (selector.executionOnline == false){
          setState(() => loading = true);
          setState(() => dispMSG = true);
          imageCache.clear();
          newImage = null;
          SRWGenerator gen = new SRWGenerator(image: image, modelPath: selector.getModelPath());
          
          try{
            newImage = await gen.generate2xImage();
          } on Exception {
            setState(() => alocationError = true);
          } on Error {
            setState(() => alocationError = true);
          }
        }
        
        setState(() => loading = false);
        if (error == false && alocationError == false && imageError == false){
          Navigator.push(context,MaterialPageRoute(builder: (context) => new ImageView(image: newImage, orgImage: image,)),);

          /*if (imageError == true) {
            showDialog(context: context, builder: (_) => imageErrorDialog(context));
          } else {
            Navigator.push(context,MaterialPageRoute(builder: (context) => ImageView(image: newImage, orgImage: image,)),);
          }*/
        } else {
          if (error == true) { showDialog(context: context, builder: (_) => serverErrorDialog(context)); }
          else if (imageError == true) { showDialog(context: context, builder: (_) => imageErrorDialog(context)); }
          else if ( alocationError == true ) { showDialog(context: context, builder: (_) => alocationErrorDialog(context)); }
          else { showDialog(context: context, builder: (_) => unknownErrorDialog(context)); }
        }
      },
      child: Text(AppLocalizations.of(context).translate('start_btn')),
    );
    ///
    /// Floating button end
    ///
    return loading && widget.showAds == false ? LoadingNoAd() : loading ? Loading(dispMesage: dispMSG,): Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('confirmation_title')),
      ),
      //////////////////////////////////////////////////////////////////////////////////////
      /// Check for subs ///////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////
      //floatingActionButton: floatProcessButton,
      floatingActionButton: selector.executionOnline == false ? floatProcessButton : !user.isAnon ? StreamBuilder<UserCredits>(
        stream: CheckOutService(uid: user.uid).userCR,
        initialData: UserCredits(credits: 0),
        builder: (context, snapshot1){
          UserCredits userCredits = snapshot1.data ?? UserCredits(credits: 0);
          if (userCredits.credits == 0) {
            // si aún no descarga 20 puede procesar
            return StreamBuilder<int>(
              stream: DatabaseService(uid: user.uid).userDownloads ?? 0,
              builder: (context, snapshot2) {
                int downloads = snapshot2.data;
                ///
                /// Cambiar a 20 downloads
                ///
                if (downloads >= 10) {
                  //no puede procesar btn
                  return RaisedButton(
                    onPressed: () {
                      //mejorar cuenta
                      showDialog(context: context, builder: (_) => upgradeDialog(context, user.uid));
                    },
                    child: Text(AppLocalizations.of(context).translate('start_btn')),
                  );
                } else {
                  //aún puede procesar btn
                  return floatProcessButton;
                }
              },
            );
          } else {
            // puede procesar btn
            return floatProcessButton;
          }
        },
      ) : floatProcessButton,
      //////////////////////////////////////////////////////////////////////////////////////
      /// Check for subs ///////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////
      body: Center(
        child: Container(
          //padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              //Spacer(),
              Container(
                //height: 350,
                child: Image.file(image, fit: BoxFit.contain,),
              ),

              Divider(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      //mainAxisSize: MainAxisSize.max,
                      children: [
                        //Spacer(),
                        Text(AppLocalizations.of(context).translate('inp_height')),
                        //SizedBox(width: 10,),
                        Spacer(),
                        Text(tensorImage.height.toString()),
                        //Spacer()
                      ],
                    ),

                    Row(
                      children: [
                        //Spacer(),
                        Text(AppLocalizations.of(context).translate('inp_widht')),
                        Spacer(),
                        Text(tensorImage.width.toString()),
                        //Spacer()
                      ],
                    ),

                    Row(
                      children: [
                        //Spacer(),
                        Text(AppLocalizations.of(context).translate('expected_out')),
                        Spacer(),
                        Text((tensorImage.height*2).toString()),
                        Text('x'),
                        Text((tensorImage.width*2).toString()),
                        //Spacer()
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.showAds == false && selector.executionOnline == true ? '' : AppLocalizations.of(context).translate(selector.executionOnline ? 'pre_process_warning2' : 'pre_process_warning'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange[900],
                  ),
                ),
              ),
              !user.isAnon ? StreamBuilder<UserCredits>(
                stream: CheckOutService(uid: user.uid).userCR,
                initialData: UserCredits(credits: 0),
                builder: (context, snapshot){
                  UserCredits userCredits = snapshot.data ?? UserCredits(credits: 0);
                  return StreamBuilder<int>(
                    stream: DatabaseService(uid: user.uid).userDownloads ?? 0,
                    initialData: 0,
                    builder: (context, snapshot2) {
                      int downloads = snapshot2.data ?? 0;
                      if (downloads >10){
                        downloads = 10;
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'CR:',
                                  style: TextStyle(fontSize: 25),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  userCredits.credits.toString() ?? '0',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate('free_images_downloaded'),
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  downloads.toString() ?? '0',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  '/10',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text(
                              AppLocalizations.of(context).translate('sell_text'),
                              textAlign: TextAlign.justify,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {return BuyCR(userUID: user.uid,);}));
                              },
                              child: Text(
                                AppLocalizations.of(context).translate('buy_CR'),
                                style: TextStyle(color: Colors.blueAccent),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ) : Text(''),


              SizedBox(height: 60,),
            ],
          ),
        ),
      ),
    );
  }
  
  _loadBanner(){
    //_bannerAd..load()..show(anchorType: AnchorType.bottom, anchorOffset: 80.0);
    _bannerAd..load()..show(anchorType: AnchorType.top, anchorOffset: 80.0);
  }
}