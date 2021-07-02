import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
//import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
//import 'package:srwnn_mobile/Controllers/databaseService.dart';
import 'package:srwnn_mobile/Controllers/urlLauncher.dart';
import 'package:srwnn_mobile/NewUI/wrapper.dart';
import 'package:srwnn_mobile/buyCR.dart';
import 'package:srwnn_mobile/dialogs.dart';
//import 'package:srwnn_mobile/removeBG.dart';
//import 'package:srwnn_mobile/workingView.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'Controllers/ModelConfigs.dart';
import 'Controllers/ModelSelector.dart';
import 'Controllers/app_localizations.dart';
import 'Controllers/authService.dart';
//import 'Models/subscriptionData.dart';
import 'Models/user.dart';
import 'authViews/auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
//import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  InAppPurchaseConnection.enablePendingPurchases();
  MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthService(),
        ),
        StreamProvider(
          initialData: null,
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
enum Options {web, webApp, about, github, mail, login, faq, cr}
bool qliOnline  = true;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    //FirebaseAdMob.instance.initialize(appId: Adds.appID);
  }

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExusAI Super Resulution',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Color(0xff1A1A1A),
        brightness: Brightness.dark,
        primaryColor: Color(0xff242424),
        accentColor: Color(0xff3187F5),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color(0xff3187F5),
            enableFeedback: true,
            textStyle: TextStyle(
              fontFamily: 'Roboto',
              //fontWeight: FontWeight.w300,
            )
          ),  
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20),
            textStyle: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w300,
            )
          )
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

      home: MyHomePage(title: 'ExusAI Super Resolution'),
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
  final AuthService _authService = AuthService();
  /* Future  getImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'JPG', 'jpeg', 'JPEG', 'png', 'PNG',],
    );
    if(result != null) {
      setState(() {image = File(result.files.single.path);});
      //setState(() {filename = result.files.single.name;});
      //setState(() {fileSize = result.files.single.size;});
      //imgProp = image2.decodeImage(uploadedImage);
    } else {
      setState(() {
        message = 'please_select_img';
      });
    }
  } */

  //int _page = 0;
  //GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuario>(context) ?? Usuario(uid: '', isAnon: true);
    
    /* Widget selectImageButton(bool showAds) {
      return ElevatedButton(
        onPressed: () async {
          //print("getting image");
          await getImage();
          //go to next wea and pass image and info
          //print("got image");
          if (image != null ) {
            Navigator.push(context,MaterialPageRoute(builder: (context) => new InferenceView(image: image, modelPath: selector.getModelPath(), showAds: showAds,)),);
          } else {
            /* try {
              await retrieveLostData();
              //Navigator.push(context,MaterialPageRoute(builder: (context) => new InferenceView(image: image, modelPath: selector.getModelPath(), showAds: showAds,)),);
            } on Exception {
              setState(() {
                message = 'please_select_img';
              });
            } */
            //await getImage();
            setState(() {
              message = 'please_select_img';
            });
          }
        },
        child: Text(AppLocalizations.of(context).translate('select_image_tr'),)
      );
    } */
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text(
          qliOnline ? 'ExusAI' : 'Server Under Mantainance',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 28
          ),
        ),
        centerTitle: false,
        elevation: 0,
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
              if (result == Options.cr){
                Navigator.push(context, MaterialPageRoute(builder: (context) {return BuyCR(userUID: user.uid,);}));
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
              !user.isAnon ? PopupMenuItem<Options>(
                value: Options.cr,
                child: ListTile(
                  title: Text(AppLocalizations.of(context).translate('buy_CR')),
                  leading: Icon(Icons.add_circle)
                ),
              ) : null,
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
      
      /* bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color.fromARGB(255, 32, 32, 32),
        height: 50,
        items: <Widget>[
          Icon(Icons.select_all_outlined, size: 30),
          Icon(Icons.image_outlined, size: 30),
          Icon(Icons.image_aspect_ratio, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ), */

      body: Wrapper()

      /* body: _page == 0 ? Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10,),
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

            // Disable execution on local
            /* Row(
              children: [
                Spacer(),
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
            ), */

            Text(
              AppLocalizations.of(context).translate(message),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange[900],
              ),
            ),
            SizedBox(height: 5,),

            selector.executionOnline == false ? selectImageButton(false) : !user.isAnon ? StreamBuilder<UserCredits>(
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
            ) : selectImageButton(true),

            SizedBox(height: 5,),
          ],
        ),
      ) : _page == 1 ? Container(
        child: Center(
          //child: Text("REMOVEBG"),
          child: ListView(
            children: [
              BackgroundRemover(),
            ],
          ),
        ),
      ) : Center(child: Text("Soon/Pronto"),), */
    );
  }
  
}