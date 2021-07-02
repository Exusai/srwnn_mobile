import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:srwnn_mobile/removeBG.dart';

class ImageViwer extends StatefulWidget {
  final Uint8List image;
  final Uint8List postProcessed;
  final String filename;
  final bool loading;
  ImageViwer({this.image, this.postProcessed, this.filename, this.loading});

  @override
  _ImageViwerState createState() => _ImageViwerState();
}

class _ImageViwerState extends State<ImageViwer> {
  bool displayPostProcessed = true;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 40,
            left: 0,
            right: 0,
            child: PhotoView.customChild(
              child: widget.loading ? Loading() : images(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              color: Color(0xff1A1A1A),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: widget.postProcessed != null ? () {
                      setState(() {
                        displayPostProcessed = !displayPostProcessed;
                      });
                    } : null, 
                    icon: Icon(Icons.compare)
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(child: Text(widget.filename, overflow: TextOverflow.ellipsis,)),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.postProcessed != null ? () {
                      // TODO: save
                    } : null, 
                    icon: Icon(Icons.save_alt, color: widget.postProcessed != null ? Theme.of(context).accentColor : Colors.grey,),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  Widget images(){
    if (displayPostProcessed && widget.postProcessed != null){
      return Image.memory(widget.postProcessed);
    } else {
      return Image.memory(widget.image);
    }
  }
}