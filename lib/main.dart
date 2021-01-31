import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:srwnn_mobile/Controllers/databaseService.dart';
import 'package:srwnn_mobile/Controllers/urlLauncher.dart';
import 'package:srwnn_mobile/dialogs.dart';
import 'package:srwnn_mobile/workingView.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Controllers/ModelConfigs.dart';
import 'Controllers/ModelSelector.dart';
import 'Controllers/adds.dart';
import 'Controllers/app_localizations.dart';
import 'Controllers/authService.dart';
import 'Models/subscriptionData.dart';
import 'Models/user.dart';
import 'authViews/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthService(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().user,
        ),
      ],
      child: MyApp(),
    )
  );
}

SRModelSelector selector = SRModelSelector();
String message = 'msg_none';
File image;
enum Options {web, webApp, about, github, mail, login, faq}

/*Future pickerGallery() async {
  final picker = ImagePicker();
  final pickedFile = await ImagePicker.getImage(source: ImageSource.gallery);
  File img = File(pickedFile.path);
  image = img;
}*/

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
      title: 'ExusAI Super Resulution',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //backgroundColor: Color(0xff303030),
        //primaryColor: Colors.red[700],
        //canvasColor: Color(CE0452),
        brightness: Brightness.dark,
        primaryColor: Colors.blue[900],
        accentColor: Colors.pinkAccent,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.pinkAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),),
          padding: EdgeInsets.symmetric(horizontal: 40),  
          //textTheme: ButtonTextTheme.accent,
        ),
        sliderTheme: SliderThemeData(          
          activeTrackColor: Colors.blue[700],
          trackHeight: 20.0,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
          thumbColor: Colors.grey[200],
          overlayColor: Colors.grey[700].withAlpha(32),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
          tickMarkShape: RoundSliderTickMarkShape(),
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: Colors.grey[600],
          valueIndicatorTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        dividerTheme: DividerThemeData(
          indent: 20,
          endIndent: 20,
        ),
      ),
      
      debugShowCheckedModeBanner: false,

      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', ''),
        Locale('es', ''),  
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
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
  final picker = ImagePicker();
  final AuthService _authService = AuthService();
  

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    //imageCache.clear();
    setState(() {
      if (pickedFile != null){
        image = File(pickedFile.path);
      } else {
        setState(() {
          message = 'please_select_img';
        });
      }
    });
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      throw Exception();
    }
    if (response.file != null) {
      setState(() {
        image = File(response.file.path);
      });
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuario>(context) ?? Usuario(uid: '', isAnon: true);

    Widget selectImageButton(bool showAds) {
      return RaisedButton(
        onPressed: () async {
          await getImage();
          //go to next wea and pass image and info
          if (image != null ) {
            Navigator.push(context,MaterialPageRoute(builder: (context) => new InferenceView(image: image, modelPath: selector.getModelPath(), showAds: showAds,)),);
          } else {
            try {
              await retrieveLostData();
            } on Exception {
              setState(() {
                message = 'please_select_img';
              });
            }
          }
        },
        child: Text(AppLocalizations.of(context).translate('select_image_tr'),),
      );
    }
    /* Widget selectImageButton = RaisedButton(
      onPressed: () async {
        await getImage();
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
    ); */

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
              if (result == Options.webApp){
                await launchURL('https://app.exusai.com/');
              } 
              if (result == Options.web){
                await launchURL('https://www.exusai.com');
              }
              if (result == Options.faq){
                showDialog(context: context, builder: (_) => faqDialog(context));
              }
              if (result == Options.login){
                //push to auht
                if(user.isAnon){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {return Auth();}));
                } else {
                 _authService.singOut(); 
                }
              } 
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
              PopupMenuItem<Options>(
                value: Options.web,
                child: ListTile(
                  title: Text(AppLocalizations.of(context).translate('website')),
                  leading: Icon(Icons.web),
                ),
              ),
              PopupMenuItem<Options>(
                value: Options.webApp,
                child: ListTile(
                  title: Text('Web App'),
                  leading: Icon(Icons.apps),
                ),
              ),
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
              PopupMenuItem<Options>(
                value: Options.faq,
                child: ListTile(
                  title: Text(AppLocalizations.of(context).translate('help')),
                  leading: Icon(Icons.help)
                ),
              ),
              PopupMenuItem<Options>(
                value: Options.login,
                child: ListTile(
                  title: user.isAnon ? Text(AppLocalizations.of(context).translate('login_or_register')) : Text(AppLocalizations.of(context).translate('log_out')),
                  leading: user.isAnon ? Icon(Icons.login) : Icon(Icons.logout),
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
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.60)),
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  Text(
                    'Example',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        'Image input',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      Text(
                        'Image Output',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 5,),
                ],
              ),
            ),

            
            Container(
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

            selector.executionOnline == false ? selectImageButton(false) : !user.isAnon ? StreamBuilder<SubscriptionData>(
              stream: CheckOutService(uid: user.uid).subscriptionData,
              builder: (context, snapshot1){
                SubscriptionData subscriptionData = snapshot1.data ?? SubscriptionData(isPremium: false);
                if (subscriptionData.isPremium == false) {
                  return selectImageButton(true);
                } else {
                  // puede procesar btn
                  return selectImageButton(false);
                }
              },
            ) : selectImageButton(true),

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
