import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:srwnn_mobile/Controllers/ModelConfigs.dart';
import 'package:srwnn_mobile/Controllers/adds.dart';
import 'package:srwnn_mobile/Controllers/app_localizations.dart';
import 'package:srwnn_mobile/Controllers/databaseService.dart';
import 'package:srwnn_mobile/Models/bgRemove.dart';
import 'package:srwnn_mobile/Models/subscriptionData.dart';
import 'package:srwnn_mobile/Models/user.dart';
import 'package:srwnn_mobile/NewUI/imageViewer.dart';
import 'package:srwnn_mobile/workingView.dart';
import '../MAXDLS.dart';
import '../dialogs.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:srwnn_mobile/NewUI/srwnnExampleView.dart';
import 'carousel.dart';
import 'dart:io';

class Wrapper extends StatefulWidget {
  //const Wrapper({ Key? key }) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

//SRModelSelector selector = SRModelSelector();
String filename;


class _WrapperState extends State<Wrapper> {
  List<String> categories = ["Súper Resolution", "Background Remover", "Soon"];
  int selectedIndex = 0;

  double threshold = 0.5;
  int blur = 0;
  bool loading = false;
  //File uploadedImage;
  Uint8List newImage;
  Uint8List postProcessed;

  String filename;
  String error = '';

  bool showADS = false;
  bool fastProcess = true;

  InterstitialAd _interstitialAd;
  bool isInstertitialReady = false;

  Future  getImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'JPG', 'jpeg', 'JPEG', 'png', 'PNG',],
    );
    if(result != null) {
      setState(() {
        image = File(result.files.single.path);
        filename = result.files.single.name;
        newImage = null;
        postProcessed = null;
      });
      //setState(() {filename = result.files.single.name;});
      //setState(() {fileSize = result.files.single.size;});
      //imgProp = image2.decodeImage(uploadedImage);
    } else {
      setState(() {
        message = 'please_select_img';
      });
    }
  }

  @override
  void initState(){
    super.initState();
    //FirebaseAdMob.instance.initialize(appId: Adds.appID);
    _interstitialAd = InterstitialAd(
      adUnitId: Adds.loading,
      //adUnitId: InterstitialAd.testAdUnitId,
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
          isInstertitialReady = false;
        },
      ),
    );
    _interstitialAd.load();
  }

  @override
  void dispose(){
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuario>(context) ?? Usuario(uid: '', isAnon: true);
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget processButtonBGR = ElevatedButton(
      onPressed: image == null ? null :  () async {
        setState(() => loading = true);
        if (showADS || user.isAnon && isInstertitialReady){
          _interstitialAd.show();
        }
        if (fastProcess) {
          try {
            postProcessed = await BGRemoverOnline.removeBGFast('0000', image.readAsBytesSync());
            setState(() => error = '');  
          } on Exception {
            setState(() => error = 'Server Error, try again later.'); 
          } on Error {
            setState(() => error = 'Server Error, try again later.'); 
          }
          setState(() => loading = false);
        } else {
          try {
            newImage = await BGRemoverOnline.removeBG('0000', image.readAsBytesSync());
            setState(() => error = '');  
          } on Exception {
            setState(() => error = 'Server Error, try again later.');  
          } on Error {
            setState(() => error = 'Server Error, try again later.');  
          }
          _postProcess();
          setState(() => loading = false);
        }
      },
      child: Text(AppLocalizations.of(context).translate("process"))
    );

    

    return ListView(
      children: [
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            alignment: Alignment.center,
            height: image == null ? height/3.5 : height/2.5,
            //width: 40,
            //child: SRWNNExample(inImg: selector.getImageInExample(), outImg: selector.getImageOutExmaple(),),
            child: image == null ? Carousel() : ImageViwer(
              image: image.readAsBytesSync(), 
              postProcessed: postProcessed, 
              filename: filename, 
              loading: loading,
              user: user
            ),
          ),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 100),
          child: ElevatedButton(
            onPressed: () async {
              await getImage();
            }, 
            child: Text(AppLocalizations.of(context).translate('select_image_tr'),)
          ),
        ),
        SizedBox(height: 10,),
        //Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            //height: 400,
            decoration: BoxDecoration(
              color: Color(0xff0E0E0E),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
                bottomLeft: const Radius.circular(20.0),
                bottomRight: const Radius.circular(20.0),
              )
            ),
        
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5,),
                SizedBox(
                  height: 25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return categoriesBuild(index, context);
                    }
                  ),
                ), 
                Divider(),
                Container(
                  alignment: Alignment.center,
                  child: controllers(
                    checkCreddits(user, processButtonBGR),
                    user,
                  ),
                )
              ],
            ),
            
          ),
        ),
        SizedBox(height: 10,),
        //SizedBox(height: 10,),
      ],
    );
  }

  Widget controllers(processBtn, user){
    /// 
    /// Super Resolution Controls
    /// 
    if (selectedIndex == 0){
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SRWNNExample(inImg: selector.getImageInExample(), outImg: selector.getImageOutExmaple(),),
          ),
          SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).translate('style_tr'),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5,),
          CupertinoSlidingSegmentedControl(
            children: styles, 
            onValueChanged: (int val) {
              setState(() {
                selector.style = val;
                message = selector.updateParameters();
              });
            },
            groupValue: selector.style,
          ),
          SizedBox(height: 10,),

          Text(
            AppLocalizations.of(context).translate('noise_lvl'),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5,),
          CupertinoSlidingSegmentedControl(
            children: noise, 
            onValueChanged: (int val) {
              setState(() {
                selector.noiseLevel = val;
                message = selector.updateParameters();
              });
            },
            groupValue: selector.noiseLevel,
          ),
          SizedBox(height: 10,),

          Text(
            AppLocalizations.of(context).translate('blur_lvl'),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5,),
          CupertinoSlidingSegmentedControl(
            children: blurLevel, 
            onValueChanged: (int val) {
              setState(() {
                selector.blurLevel = val;
                message = selector.updateParameters();
              });
            },
            groupValue: selector.blurLevel,
          ),
          SizedBox(height: 10,),
          Text(
              AppLocalizations.of(context).translate(message),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange[900],
              ),
            ),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80),
            child: checkCredditsSR(user),
          ),
          SizedBox(height: 10,),
        ],
      );
    } 
    /// 
    /// BGR Controls
    /// 
    if (selectedIndex == 1){
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max, 
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(AppLocalizations.of(context).translate('fast_processing')),
                Spacer(),
                FlutterSwitch(
                  value: fastProcess, 
                  height: 20.0,
                  toggleSize: 20.0,
                  width: 40,
                  padding: 0,
                  onToggle: (bool val) {
                    setState(() {
                      fastProcess = val;
                    });
                  }
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: IgnorePointer(
              ignoring: fastProcess,
              child: ExpansionTile(
                subtitle: Text(AppLocalizations.of(context).translate('adjust_parameters_to_get_desired_result'), style: TextStyle(color: fastProcess ? Colors.white.withAlpha(30) : Colors.white),),
                title: Text(AppLocalizations.of(context).translate('settings'), style: TextStyle(color: fastProcess ? Colors.white.withAlpha(30) : Colors.white)),
                initiallyExpanded: false,
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                children: [
                  Text(AppLocalizations.of(context).translate('threshold'), style: TextStyle(color: fastProcess ? Colors.white.withAlpha(30) : Colors.white)),
                  Slider(
                    value: threshold,
                    onChanged: fastProcess ? null : (postProcessed == null  || newImage  == null) ? null : (double value){
                      setState(() => threshold = value);
                    },
                    onChangeEnd: (double value){
                      setState(() => loading = true);
                      _postProcess();
                    },
                    min: .05,
                    max: 0.95,
                    divisions: 18,
                    label: threshold.toStringAsFixed(2),
                  ),
                  Text(AppLocalizations.of(context).translate('blur'), style: TextStyle(color: fastProcess ? Colors.white.withAlpha(30) : Colors.white)),
                  Slider(
                    value: blur.toDouble(),
                    divisions: 20,
                    label: blur.toString(),
                    onChanged: fastProcess ? null : (postProcessed == null  || newImage  == null) ? null : (double value){
                      setState(() => blur = value.toInt());
                    },
                    onChangeEnd: (_) async {
                      setState(() => loading = true);
                      _postProcess();
                    },
                    min: 0,
                    max: 20,
                  ),
                  
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          processBtn,
          SizedBox(height: 10,),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget selectImageButton(bool showAds){
    return ElevatedButton(
      onPressed: image != null ? () async {
        Navigator.push(context,MaterialPageRoute(builder: (context) => new InferenceView(image: image, modelPath: selector.getModelPath(), showAds: showAds,)),);
      } : null, 
      child: Text(AppLocalizations.of(context).translate('process'),)
    );
  }

  Widget checkCredditsSR(user) {
    return selector.executionOnline == false ? selectImageButton(false) : !user.isAnon ? StreamBuilder<UserCredits>(
      stream: CheckOutService(uid: user.uid).userCR,
      initialData: UserCredits(credits: 0),
      builder: (context, snapshot1){
        UserCredits userCredits = snapshot1.data ?? UserCredits(credits: 0);
        if (userCredits.credits == 0) {
          return selectImageButton(true);
        } else {
          return selectImageButton(false);
        }
      },
    ) : selectImageButton(true);
  }

  Widget checkCreddits(user, btn){
    return !user.isAnon ? StreamBuilder<UserCredits>(
      stream: CheckOutService(uid: user.uid).userCR,
      initialData: UserCredits(credits: 0),
      builder: (context, snapshot1) {                        
        UserCredits userCredits = snapshot1.data ?? UserCredits(credits: 0);
        if (userCredits.credits == 0) {
          // si aún no descarga 20 puede procesar
          return StreamBuilder<int>(
            stream: DatabaseService(uid: user.uid).userDownloads,
            builder: (context, snapshot2) {
              int downloads = snapshot2.data ?? 0;
              if (downloads >= MAXDLS) {
                //no puede procesar btn
                return ElevatedButton(
                  onPressed: image == null ? null : () {
                    showDialog(context: context, builder: (_) => upgradeDialog(context, user.uid));
                  },
                  child: Text(AppLocalizations.of(context).translate("process"))
                );
              } else {
                //aún puede procesar btn
                showADS = true;
                return btn;
              }
            },
          );
        } else {
          // puede procesar btn
          return btn;
        }
      },
    ) : btn;
    
  }

  void _postProcess() async {
    postProcessed = await compute(postProcess, [image.readAsBytesSync(), newImage, blur, threshold]);
    setState(() => loading = false);
  }

  GestureDetector categoriesBuild(int index, BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categories[index],
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: selectedIndex == index ? Colors.white : Colors.white70,
                  ),
                ),
                Container(
                  width: 90,
                  height: 2,
                  margin: EdgeInsets.only(top: 5),
                  color: selectedIndex == index ? Colors.white : Colors.transparent,
                )
              ],
            ),
            /* SizedBox(width: 10,),
            Container(
              width: 1,
              height: 20,
              color: Colors.grey,
            ) */
          ],
        ),
      ),
    );
  }
}