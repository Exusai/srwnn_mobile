import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:srwnn_mobile/Controllers/urlLauncher.dart';
import 'package:srwnn_mobile/NewUI/wrapper.dart';
import 'package:srwnn_mobile/buyCR.dart';
import 'package:srwnn_mobile/dialogs.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Controllers/ModelSelector.dart';
import 'Controllers/app_localizations.dart';
import 'Controllers/authService.dart';
import 'Models/user.dart';
import 'authViews/auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Usuario>(context) ?? Usuario(uid: '', isAnon: true);
    
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
      
      body: Wrapper()
    );
  }
  
}