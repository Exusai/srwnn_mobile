import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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