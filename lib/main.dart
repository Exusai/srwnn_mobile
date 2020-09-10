import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:srwnn_mobile/Controllers/urlLauncher.dart';
import 'package:srwnn_mobile/dialogs.dart';
import 'package:srwnn_mobile/workingView.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'Controllers/ModelConfigs.dart';
import 'Controllers/ModelSelector.dart';
import 'Controllers/adds.dart';
import 'Controllers/app_localizations.dart';

void main() {
  runApp(MyApp());
}

SRModelSelector selector = SRModelSelector();
String message = 'msg_none';
File image;
enum Options {about, github, mail, tip}

pickerGallery() async {
  File img = await ImagePicker.pickImage(source: ImageSource.gallery);
  image = img;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  void initState(){
    super.initState();
    FirebaseAdMob.instance.initialize(appId: Adds.appID);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Resulution W.N.N.',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Color(0xff303030),
        primaryColor: Color(0xff303030),
        //canvasColor: Color(CE0452),
      ),
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', ''),
        Locale('es', ''),  
      ],
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },

      home: MyHomePage(title: 'Super Resolution W.N.N'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
        actions: [
          new PopupMenuButton<Options>(
            icon: Icon(Icons.more_horiz,),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
            onSelected: (Options result) async {
              //print(result);
              if (result == Options.github){
                await launchURL('https://github.com/Exusai/srwnn_mobile');
              } 
              if (result == Options.mail){
                await launchMail();
              } 

              if (result == Options.about){
                showDialog(context: context, builder: (_) => aboutDialog(context));
              } 
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
              PopupMenuItem<Options>(
                value: Options.about,
                child: ListTile(
                  title: Text(AppLocalizations.of(context).translate('about')),
                  leading: Icon(Icons.info),
                ),
              ),
              PopupMenuItem<Options>(
                value: Options.github,
                child: ListTile(
                  title: Text('Github'),
                  leading: Icon(Icons.code),
                ),
              ),
              PopupMenuItem<Options>(
                value: Options.mail,
                child: ListTile(
                  title: Text(AppLocalizations.of(context).translate('mail')),
                  leading: Icon(Icons.mail),
                ),
              ),
              /*PopupMenuItem<Options>(
                value: Options.tip,
                child: ListTile(
                  title: Text(AppLocalizations.of(context).translate('tip')),
                  leading: Icon(Icons.monetization_on),
                ),
              ),*/
            ],
          ),

        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20,),
            Container(
              //height: 180,
              //width: 500,
              child: Row(
                children: [
                  //Spacer(),
                  Expanded(
                    child: Image(
                      image: AssetImage(selector.getImageInExample()),
                      fit: BoxFit.fitWidth,
                      //height: 160,
                    ),
                  ),
                  Expanded(
                    child: Image(
                      image: AssetImage(selector.getImageOutExmaple()),
                      fit: BoxFit.fitWidth,
                      //height: 160,
                    ),
                  ),
                  //Spacer(),
                ],
              ),
            ),

            SizedBox(height: 10,),
            Text(
              AppLocalizations.of(context).translate('model_tr'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5,),
            CupertinoSlidingSegmentedControl(
              children: models, 
              onValueChanged: (int val) {
                setState(() {
                  selector.model = val;
                  message = selector.updateParameters();
                });
              },
              groupValue: selector.model,
            ),
            SizedBox(height: 10,),

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
              children: blur, 
              onValueChanged: (int val) {
                setState(() {
                  selector.blurLevel = val;
                  message = selector.updateParameters();
                });
              },
              groupValue: selector.blurLevel,
            ),
            SizedBox(height: 10,),

            Row(
              children: [
                Spacer(),
                /*Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('expand_tr'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5,),
                    CupertinoSlidingSegmentedControl(
                      children: expand, 
                      onValueChanged: (int val) {
                        setState(() {
                          selector.expansion = val;
                          message = selector.updateParameters();
                        });
                      },
                      groupValue: selector.expansion,
                    ),
                    SizedBox(height: 10,),
                  ],
                ),

                SizedBox(width: 15,),

                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('upscale_tr'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5,),
                    CupertinoSlidingSegmentedControl(
                      children: upscale, 
                      onValueChanged: (int val) {
                        setState(() {
                          selector.upscaleLevel = val;
                          message = selector.updateParameters();
                        });
                      },
                      groupValue: selector.upscaleLevel,
                    ),
                    SizedBox(height: 10,),
                  ],
                ),

                SizedBox(width: 15,),*/

                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('execution_tr'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5,),
                    CupertinoSlidingSegmentedControl(
                      children: execution, 
                      onValueChanged: (int val) {
                        setState(() {
                          if (val == 0){
                            selector.executionOnline = false;
                          } else {
                            selector.executionOnline = true;
                          }
                          
                          message = selector.updateParameters();
                        });
                      },
                      groupValue: selector.executionOnline == true ? 1 : 0,
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
                Spacer(), 
              ],
            ),

            Text(
              AppLocalizations.of(context).translate(message),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange[900],
              ),
            ),
            SizedBox(height: 5,),

            RaisedButton(
              onPressed: () async {
                await pickerGallery();
                //go to next wea and pass image and info
                if (image != null ) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InferenceView(image: image, modelPath: selector.getModelPath())),
                  );
                } else {
                  setState(() {
                    message = 'please_select_img';
                  });
                }

              },
              child: Text(AppLocalizations.of(context).translate('select_image_tr'),),
            ),

            /*FlatButton(
              onPressed: () async {
                await pickerGallery();
                //go to next wea and pass image and info
                if (image != null ) {
                  Navigator.push(
                    context,
                    //Image.asset('')
                    File.fromUri(uri)
                    MaterialPageRoute(builder: (context) => InferenceView(image: image, modelPath: selector.getModelPath())),
                  );
                } else {
                  setState(() {
                    message = 'Error';
                  });
                }

              },
              child: Text('Sample image'),
            ),*/
            
          ],
        ),
      ),

    );
  }
}
