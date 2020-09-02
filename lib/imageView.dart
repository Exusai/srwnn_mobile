import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'Controllers/app_localizations.dart';


class ImageView extends StatefulWidget {
  final File image;
  final File orgImage;

  ImageView({this.image, this.orgImage});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  double controller = 0.5;
  @override
  Widget build(BuildContext context) {
    TensorImage imgProp = TensorImage.fromFile(widget.image);
    
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              //Navigator.pop(context);
              //Navigator.pop(context);
              GallerySaver.saveImage(widget.image.path);
              //print('Saved');
              showDialog(context: context, builder: (_) => imageSaved(context));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            /*child: PhotoView(
              imageProvider: FileImage(image),
            ),*/
            //height: context.size.height,
            child: PhotoView.customChild(
              minScale: PhotoViewComputedScale.contained * 0.8,
              initialScale: PhotoViewComputedScale.contained,
              //basePosition: Alignment.centerRight,
              
              enableRotation: true,
              childSize:  Size(imgProp.width.toDouble(),imgProp.height.toDouble()),
              child: Container(
                child: Stack(
                  
                  children: [
                    /*Image.file(
                      widget.orgImage, 
                      //height: imgProp.height.toDouble(), 
                      //width: imgProp.width.toDouble(),
                      alignment: Alignment.topLeft,
                    ),*/
                    Container(
                      height: imgProp.height.toDouble(),
                      width: imgProp.width.toDouble(),
                      child: Image.file(
                        widget.orgImage,
                        height: imgProp.height.toDouble(),
                        //width: imgProp.width.toDouble(),
                        alignment: Alignment.topLeft,
                        fit: BoxFit.fitHeight,
                      ),
                    ),

                    AnimatedContainer(
                      duration: Duration(milliseconds: 1),
                      height: imgProp.height.toDouble(),
                      width: imgProp.width.toDouble() * controller,
                      //margin: EdgeInsets.only(right: 5),
                      //color: Colors.black,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 4.0,
                            color: Colors.black
                          )
                        )
                      ),
                      child: Image.file(
                        widget.image, 
                        //height: imgProp.height.toDouble(), 
                        //width: imgProp.width.toDouble(), 
                        alignment: Alignment.topLeft,
                        fit: BoxFit.cover,
                        
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            //alignment: Alignment.bottomCenter,
            left: 10,
            right: 10,
            bottom: 10,
            child: Slider(
              value: controller,
              min: 0.0,
              max: 1.0,
              //activeColor: Colors.redAccent[100],
              //inactiveColor: Colors.red[50],
              onChanged: (newVal){
                setState(() {
                  controller = newVal;
                });
              },
            ),
          ),
        ],
      )
    );
  }
}

AlertDialog imageSaved(context) {
  return AlertDialog(
    title: Text(AppLocalizations.of(context).translate('msg_image_saved')),
    actions: [
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: Text('Ok'),
      ),
    ],
  );
}

