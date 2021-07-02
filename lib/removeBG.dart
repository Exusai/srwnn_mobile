import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'Models/user.dart';
import 'Models/bgRemove.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'Models/subscriptionData.dart';
import 'Controllers/databaseService.dart';
import 'MAXDLS.dart';
import 'package:srwnn_mobile/dialogs.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'Controllers/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Controllers/adds.dart';

class BackgroundRemover extends StatefulWidget {
  @override
  _BackgroundRemoverState createState() => _BackgroundRemoverState();
}

class _BackgroundRemoverState extends State<BackgroundRemover> {
  double threshold = 0.5;
  int blur = 0;
  bool loading = false;
  File uploadedImage;
  Uint8List newImage;
  Uint8List postProcessed;

  String filename;
  String error = '';

  bool showADS = false;
  bool fastProcess = true;

  InterstitialAd _interstitialAd;
  bool isInstertitialReady = false;
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
    
    final user = Provider.of<Usuario>(context) ?? Usuario(uid: '', isAnon: true);

    Widget processButton = ElevatedButton(
      onPressed: uploadedImage == null ? null :  () async {
        setState(() => loading = true);
        if (showADS || user.isAnon && isInstertitialReady){
          _interstitialAd.show();
        }
        if (fastProcess) {
          try {
            postProcessed = await BGRemoverOnline.removeBGFast('0000', uploadedImage.readAsBytesSync());
            setState(() => error = '');  
          } on Exception {
            setState(() => error = 'Server Error, try again later.'); 
          } on Error {
            setState(() => error = 'Server Error, try again later.'); 
          }
          setState(() => loading = false);
        } else {
          try {
            newImage = await BGRemoverOnline.removeBG('0000', uploadedImage.readAsBytesSync());
            setState(() => error = '');  
          } on Exception {
            setState(() => error = 'Server Error, try again later.');  
          } on Error {
            setState(() => error = 'Server Error, try again later.');  
          }
          _postProcess();
        }
        
      },
      child: Text(AppLocalizations.of(context).translate("process"))
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //---Titulo                     ---//
        /* Container(
          color: Colors.grey[900],
          height: 40,
          child: Row(
            children: [
              Spacer(),
              Text(
                AppLocalizations.of(context).translate('remove_imageBG'),
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)
              ),
              Spacer(),
            ],
          ),
        ),
        //---Mostrar Imagen y resultado---//
        Container(
          height: height3*.50,
          width: width,
          decoration: BoxDecoration(color: Colors.grey[800]),
          child: Column(
            children: [
              Expanded(
                child: loading ? Loading() : postProcessed != null? Image.memory(postProcessed) : uploadedImage != null? Image.file(uploadedImage) : CustomContainer(),
              ),
              SizedBox(height: 10,),
              Text(
                loading ? 'Loading' : postProcessed == null? AppLocalizations.of(context).translate('original_image') : AppLocalizations.of(context).translate('processed_image')
              ),
              SizedBox(height: 10,),
            ],
          ),
        ), */
        //---Botones, siliders y etc---//
        Container(
          child: Column(
            children: [
              /////////SLiders
              Container(
                child: IgnorePointer(
                  ignoring: fastProcess,
                  child: ExpansionTile(
                    subtitle: Text(AppLocalizations.of(context).translate('adjust_parameters_to_get_desired_result'), style: TextStyle(color: fastProcess ? Colors.white.withAlpha(30) : Colors.white),),
                    title: Text(AppLocalizations.of(context).translate('settings'), style: TextStyle(color: fastProcess ? Colors.white.withAlpha(30) : Colors.white)),
                    initiallyExpanded: false,
                    
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
              
              //BOTONEs
              Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            FilePickerResult result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'JPG', 'jpeg', 'JPEG', 'png', 'PNG',],
                            );
                            if(result != null) {
                              setState(() => error = '');
                              setState(() {uploadedImage = null; uploadedImage = File(result.files.single.path);});
                              
                              setState(() {postProcessed = null;});
                              setState(() {newImage = null;});
                              setState(() {filename = result.files.single.name;});
                            } else {

                            }
                          },
                          child: Text(AppLocalizations.of(context).translate('select_image')),
                        ),
                        
                        ////////////////////////////////////////////////////////////////////////////////////////////////////
                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                        /* Boton que cuenta si ya llevas 20 y si eres premium aún puedes descargar  */
                        !user.isAnon ? StreamBuilder<UserCredits>(
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
                                      onPressed: uploadedImage == null ? null : () {
                                        showDialog(context: context, builder: (_) => upgradeDialog(context, user.uid));
                                      },
                                      child: Text(AppLocalizations.of(context).translate("process"))
                                    );
                                  } else {
                                    //aún puede procesar btn
                                    showADS = true;
                                    return processButton;
                                  }
                                },
                              );
                            } else {
                              // puede procesar btn
                              return processButton;
                            }
                            
                          },
                        ) : processButton,
                        ////////////////////////////////////////////////////////////////////////////////////////////////////
                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                        SizedBox(height: 5,),
                        ElevatedButton(
                          onPressed: postProcessed == null ? null : ()  async {
                            if (user.isAnon == true) {
                              showDialog(context: context, builder: (_) => logToDownload(context));
                            } else {
                              var imgPath = await getTemporaryDirectory();
                              File imageNoBG = new File('${imgPath.path}/noBGIMG.png')..writeAsBytesSync(postProcessed); 
                              GallerySaver.saveImage(imageNoBG.path, albumName: '2xImg');
                              await DatabaseService(uid: user.uid).processedImageCount();
                              showDialog(context: context, builder: (_) => imageSaved(context));
                            } 
                          },
                          child: Text(AppLocalizations.of(context).translate("download_image"))
                        ),

                        Text(error, style: TextStyle(color: Colors.orange[800]),)
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 5,),
                    Row(
                      mainAxisSize: MainAxisSize.max, 
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(AppLocalizations.of(context).translate('fast_processing')),
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
                    SizedBox(height: 5,),
                ],
              ),
              
            ],
          ),
        ),
      ],
    );
  }

  void _postProcess() async {
    postProcessed = await compute(postProcess, [uploadedImage.readAsBytesSync(), newImage, blur, threshold]);
    setState(() => loading = false);
  }
}

class CustomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3)
        ),
        child: Center(child: Text(AppLocalizations.of(context).translate('not_image_yet'))),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      child: const SpinKitCubeGrid(
        color: Colors.white,
        size: 150.0,
      ),
    );
  }
}

