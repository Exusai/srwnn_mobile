import 'package:flutter/material.dart';
import 'Controllers/app_localizations.dart';

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

