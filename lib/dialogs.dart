import 'package:flutter/material.dart';
import 'Controllers/app_localizations.dart';

AlertDialog aboutDialog(context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('about')),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          Text(AppLocalizations.of(context).translate('about_text1'), textAlign: TextAlign.justify),
          Text(AppLocalizations.of(context).translate('about_text2'), textAlign: TextAlign.justify),
          Text(AppLocalizations.of(context).translate('about_text3'), textAlign: TextAlign.justify),
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
    title: Text(AppLocalizations.of(context).translate('about')),
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          Text(AppLocalizations.of(context).translate('about_text1'), textAlign: TextAlign.justify),
          Text(AppLocalizations.of(context).translate('about_text2'), textAlign: TextAlign.justify),
          Text(AppLocalizations.of(context).translate('about_text3'), textAlign: TextAlign.justify),
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

