import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:srwnn_mobile/Models/user.dart';
import 'package:srwnn_mobile/dialogs.dart';
import 'package:srwnn_mobile/main.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'Controllers/app_localizations.dart';
import 'Controllers/databaseService.dart';


class ImageView extends StatefulWidget {
  final File image;
  final File orgImage;

  ImageView({this.image, this.orgImage});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      value: 0.5
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TensorImage imgProp = TensorImage.fromFile(widget.orgImage);
    final user = Provider.of<Usuario>(context) ?? Usuario(uid: '', isAnon: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (selector.executionOnline == false){
                GallerySaver.saveImage(widget.image.path, albumName: '2xImg');
                showDialog(context: context, builder: (_) => imageSaved(context));
              } else {
                if (user.isAnon == true){
                  showDialog(context: context, builder: (_) => logToDownload(context));
                } else {
                  GallerySaver.saveImage(widget.image.path, albumName: '2xImg');
                  await DatabaseService(uid: user.uid).processedImageCount();
                  showDialog(context: context, builder: (_) => imageSaved(context));
                }
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            child: PhotoView.customChild(
              minScale: PhotoViewComputedScale.contained * 0.8,
              initialScale: PhotoViewComputedScale.covered,
              enableRotation: true,
              childSize:  Size(imgProp.width.toDouble(),imgProp.height.toDouble()),
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      height: imgProp.height.toDouble(),
                      width: imgProp.width.toDouble(),
                      child: Image.file(
                        widget.orgImage,
                        height: imgProp.height.toDouble(),
                        alignment: Alignment.topLeft,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: controller, 
                      builder: (_, child) {
                        return AnimatedContainer(
                          duration: Duration(microseconds: 1),
                          height: imgProp.height.toDouble(),
                          width: imgProp.width.toDouble() * controller.value,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                width: imgProp.width.toDouble()*0.005,
                                color: Colors.black
                                
                              ),
                            ),
                            
                          ),
                          child: Image.file(
                            widget.image, 
                            alignment: Alignment.topLeft,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, child) {
                return Slider(
                  value: controller.value,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (newVal){
                    controller.value = newVal;
                  },
                );
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
          //Navigator.pop(context);
          //Navigator.pop(context);
        },
        child: Text('Ok'),
      ),
    ],
  );
}

