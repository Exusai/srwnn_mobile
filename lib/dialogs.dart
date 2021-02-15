import 'package:flutter/material.dart';
import 'package:srwnn_mobile/authViews/auth.dart';
import 'Controllers/app_localizations.dart';
import 'Controllers/urlLauncher.dart';

AlertDialog aboutDialog(context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('about')),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          Text(AppLocalizations.of(context).translate('about_text1'), textAlign: TextAlign.left),
          Text(AppLocalizations.of(context).translate('about_text2'), textAlign: TextAlign.left),
          Text(AppLocalizations.of(context).translate('about_text3'), textAlign: TextAlign.left),
        ],
      ),
    ),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Ok'),
      ),
    ],
  );
}

AlertDialog faqDialog(context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('help')),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          Text(AppLocalizations.of(context).translate('faq1'), textAlign: TextAlign.left),
        ],
      ),
    ),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Ok'),
      ),
      RaisedButton(
        child: Text('Web App'),
        onPressed: () async {
          await launchURL('https://app.exusai.com/');
        },
      )
    ],
  );
}

AlertDialog serverErrorDialog(context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('server_error')),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          Text(AppLocalizations.of(context).translate('common_errors'), textAlign: TextAlign.left),
          Text(AppLocalizations.of(context).translate('posible_error0'), textAlign: TextAlign.left),
          Text(AppLocalizations.of(context).translate('posible_error1'), textAlign: TextAlign.left),
          Text(AppLocalizations.of(context).translate('posible_error2'), textAlign: TextAlign.left),
          Text(AppLocalizations.of(context).translate('posible_error3'), textAlign: TextAlign.left),
          Text(AppLocalizations.of(context).translate('posible_error4'), textAlign: TextAlign.left),
        ],
      ),
    ),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Ok'),
      ),
    ],
  );
}

AlertDialog imageErrorDialog(context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('server_image_error')),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          Text(AppLocalizations.of(context).translate('large_errors'), textAlign: TextAlign.left),
        ],
      ),
    ),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Ok'),
      ),
    ],
  );
}

AlertDialog alocationErrorDialog(context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('alloc_error')),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          Text(AppLocalizations.of(context).translate('alloc_error_desc'), textAlign: TextAlign.left),
        ],
      ),
    ),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Ok'),
      ),
    ],
  );
}

AlertDialog unknownErrorDialog(context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('unknown_error')),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          Text(AppLocalizations.of(context).translate('unknown_error'), textAlign: TextAlign.left),
        ],
      ),
    ),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Ok'),
      ),
    ],
  );
}

AlertDialog resetPasswordDialog(context, correo) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('reset_ps')),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
         Text(AppLocalizations.of(context).translate('reset_ps_mail1') + correo + AppLocalizations.of(context).translate('reset_ps_mail2'))
        ],
      ),
    ),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Ok'),
      ),
    ],
  );
}

AlertDialog logToDownload(context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('log_to_dl')),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
          //Navigator.pop(context);
        },
        child: Text(
          AppLocalizations.of(context).translate('cancel')
        ),
      ),

      RaisedButton(
        child: Text('Register/Login'),
        padding: EdgeInsets.symmetric(horizontal: 40),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {return Auth();}));
        }
      ),
    ],
  );
}

AlertDialog upgradeDialog(context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('limit_reached')),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
         Text(AppLocalizations.of(context).translate('upgrade_pls'))
        ],
      ),
    ),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(AppLocalizations.of(context).translate('return')),
      ),

      RaisedButton(
        onPressed: () async {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionPage()),);
          await launchURL('https://app.exusai.com/#/auth');
        },
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Text(AppLocalizations.of(context).translate('admin_sub')),
      )
    ],
  );
}
