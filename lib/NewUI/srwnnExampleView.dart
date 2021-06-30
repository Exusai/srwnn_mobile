import 'package:flutter/material.dart';

class SRWNNExample extends StatelessWidget {
  final String outImg;
  final String inImg;

  SRWNNExample({ this.inImg, this.outImg });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image(
            image: AssetImage(outImg),
            fit: BoxFit.cover
            //height: ,
          ),
        ),
        Positioned.fill(
          //width: 100,
          child: Image(
            image: AssetImage(outImg),
            fit: BoxFit.cover
            //height: 80,
          ),
        ),
      ],
    
    );
  }
}