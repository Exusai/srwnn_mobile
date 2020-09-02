import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Controllers/app_localizations.dart';

class Loading extends StatelessWidget {
  final bool dispMesage;
  Loading({this.dispMesage});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF2F2F2),
      child: Center(
        child: Column(
          children: [
            Spacer(),
            SpinKitCubeGrid(
              color: Colors.blue,
              size: 80.0,
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                dispMesage ? AppLocalizations.of(context).translate('loading_dialog'): '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15
                ),
              ),
            ),
            Spacer()
          ],
        )
      ),
    );
  }
}