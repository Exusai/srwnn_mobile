import 'package:flutter/material.dart';

class SRWNNExample extends StatelessWidget {
  final String outImg;
  final String inImg;

  SRWNNExample({ this.inImg, this.outImg });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  image: AssetImage(inImg),
                  fit: BoxFit.fitWidth,
                  //height: 160,
                ),
              ),
              Expanded(
                child: Image(
                  image: AssetImage(outImg),
                  fit: BoxFit.fitWidth,
                  //height: 160,
                ),
              ),
              //Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}