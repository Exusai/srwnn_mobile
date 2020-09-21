import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:srwnn_mobile/imageView.dart';
import 'package:srwnn_mobile/main.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'Controllers/adds.dart';
import 'Controllers/app_localizations.dart';
import 'Models/generator.dart';
import 'Models/onlineGenerator.dart';
import 'dialogs.dart';
import 'loading.dart';

//import 'package:admob_flutter/admob_flutter.dart';

class InferenceView extends StatefulWidget {
  final File image;
  final String modelPath;

  InferenceView({this.image, this.modelPath});
  @override
  _InferenceViewState createState() => _InferenceViewState();
}

File newImage;

class _InferenceViewState extends State<InferenceView> {
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
    
    if (selector.executionOnline == true){
      //Admob.initialize(Adds.appID);
      _bannerAd = BannerAd(adUnitId: Adds.banner, size: AdSize.banner);
      //Widget banner = AdmobBanner(adUnitId: Adds.banner, adSize: AdmobBannerSize.BANNER);
      _loadBanner();
    }
  }

  @override
  void dispose(){
    super.dispose();
    if (selector.executionOnline == true){
      _bannerAd.dispose();
    }
  }  
  
  @override
  Widget build(BuildContext context) {
    return loading ? Loading(dispMesage: dispMSG,): Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('confirmation_title')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          if (selector.executionOnline == true) {
            setState(() => loading = true);
            setState(() => dispMSG = false);
            await _bannerAd.dispose();
            _bannerAd = null;
            imageCache.clear();
            newImage = null;
            SRWGeneratorOnline genOnline = SRWGeneratorOnline(image: image, modelConfig: selector.getModelConfig());
            try{
              newImage = await genOnline.generate2xImage();
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
            SRWGenerator gen = SRWGenerator(image: image, modelPath: selector.getModelPath());
            
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
            Navigator.push(context,MaterialPageRoute(builder: (context) => ImageView(image: newImage, orgImage: image,)),);

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
      ),
      body: Center(
        child: Container(
          child: ListView(
            children: [
              //Spacer(),
              Container(
                //height: 350,
                child: Image.file(image, fit: BoxFit.contain,),
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Spacer(),
                  Text(AppLocalizations.of(context).translate('inp_height')),
                  SizedBox(width: 10,),
                  Text(tensorImage.height.toString()),
                  Spacer()
                ],
              ),

              Row(
                children: [
                  Spacer(),
                  Text(AppLocalizations.of(context).translate('inp_widht')),
                  SizedBox(width: 10,),
                  Text(tensorImage.width.toString()),
                  Spacer()
                ],
              ),

              Row(
                children: [
                  Spacer(),
                  Text(AppLocalizations.of(context).translate('expected_out')),
                  SizedBox(width: 10,),
                  Text((tensorImage.height*2).toString()),
                  Text('x'),
                  Text((tensorImage.width*2).toString()),
                  Spacer()
                ],
              ),
              SizedBox(height: 5,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppLocalizations.of(context).translate(selector.executionOnline ? 'pre_process_warning2' : 'pre_process_warning'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange[900],
                  ),
                ),
              ),
              SizedBox(height: 10,),
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