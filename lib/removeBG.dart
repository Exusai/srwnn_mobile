import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'Models/user.dart';
import 'Models/bgRemove.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'Models/subscriptionData.dart';
import 'Controllers/databaseService.dart';
import 'MAXDLS.dart';
import 'package:srwnn_mobile/dialogs.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BackgroundRemover extends StatefulWidget {
  @override
  _BackgroundRemoverState createState() => _BackgroundRemoverState();
}

class _BackgroundRemoverState extends State<BackgroundRemover> {

  double threshold = 0.5;
  int blur = 0;

  bool loading = false;

  File uploadedImage;
  Uint8List newImage;
  Uint8List postProcessed;

  String filename;

  String error = '';

  bool fastProcess = true;
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
    
    final user = Provider.of<Usuario>(context) ?? Usuario(uid: '', isAnon: true);

    Widget processButton = ElevatedButton(
      onPressed: uploadedImage == null ? null :  () async {
        /* setState(() => loading = true);
        newImage = await BGRemoverOnline.removeBG('0000', uploadedImage);
        postProcessed = await BGRemoverOnline.postProcess([uploadedImage, newImage, blur, threshold]);
        setState(() => loading = false); */
        setState(() => loading = true);
        if (fastProcess) {
          try {
            postProcessed = await BGRemoverOnline.removeBGFast('0000', uploadedImage.readAsBytesSync());
            setState(() => error = '');  
          } on Exception {
            setState(() => error = 'Server Error, try again later.'); 
          } on Error {
            setState(() => error = 'Server Error, try again later.'); 
          }
        } else {
          try {
            newImage = await BGRemoverOnline.removeBG('0000', uploadedImage.readAsBytesSync());
            setState(() => error = '');  
          } on Exception {
            setState(() => error = 'Server Error, try again later.');  
          } on Error {
            setState(() => error = 'Server Error, try again later.');  
          }
          _postProcess();
        }
        setState(() => loading = false);
      },
      child: Text("process")
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //---Titulo                     ---//
        Container(
          color: Colors.grey[900],
          height: 40,
          child: Row(
            children: [
              Spacer(),
              Text(
                'remove_imageBG',
                //style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)
              ),
              Spacer(),
            ],
          ),
        ),
        //---Mostrar Imagen y resultado---//
        Container(
          height: height3*.50,
          width: width,
          decoration: BoxDecoration(color: Colors.grey[800]),
          child: Column(
            children: [
              Expanded(
                //width: width/2,
                //height: height3*.70-37,
                child: loading ? Loading() : postProcessed != null? Image.memory(postProcessed) : uploadedImage != null? Image.file(uploadedImage) : CustomContainer(),
              ),
              SizedBox(height: 10,),
              //Divider(),
              Text('original_image'),
              SizedBox(height: 10,),
            ],
          ),
        ),
        //---Botones, siliders y etc---//
        Container(
          //height: height3/2,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /////////SLiders
              Container(
                //width: width/2,
                child: IgnorePointer(
                  ignoring: fastProcess,
                  child: ExpansionTile(
                    subtitle: Text('adjust_parameters_to_get_desired_result', style: TextStyle(color: fastProcess ? Colors.white.withAlpha(30) : Colors.white),),
                    title: Text('settings', style: TextStyle(color: fastProcess ? Colors.white.withAlpha(30) : Colors.white)),
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //expandedAlignment: MainAxisAlignment.start,
                    initiallyExpanded: !fastProcess,
                    
                    children: [
                      /* SizedBox(height: 5,),
                      Text('Imagen Procesada'),
                      Divider(),
                      Text('Límite'), */
                      //SizedBox(height: 5,),
                      Text('threshold', style: TextStyle(color: fastProcess ? Colors.white.withAlpha(30) : Colors.white)),
                      Slider(
                        value: threshold,
                        onChanged: fastProcess ? null : (postProcessed == null  || newImage  == null) ? null : (double value){
                          setState(() => threshold = value);
                        },
                        /* onChangeStart: (_) {
                          setState(() => loading = true);
                        }, */
                        onChangeEnd: (double value){
                          setState(() => loading = true);
                          _postProcess();
                        },
                        min: .05,
                        max: 0.95,
                        divisions: 18,
                        label: threshold.toStringAsFixed(2),
                      ),
                      //Divider(),
                      Text('blur', style: TextStyle(color: fastProcess ? Colors.white.withAlpha(30) : Colors.white)),
                      //SizedBox(height: 5,),
                      Slider(
                        value: blur.toDouble(),
                        divisions: 20,
                        label: blur.toString(),
                        onChanged: fastProcess ? null : (postProcessed == null  || newImage  == null) ? null : (double value){
                          setState(() => blur = value.toInt());
                        },
                        /* onChangeStart: (_) {
                          setState(() => loading = true);
                        }, */
                        onChangeEnd: (_) async {
                          setState(() => loading = true);
                          _postProcess();
                        },
                        min: 0,
                        max: 20,
                      ),
                      
                    ],
                  ),
                ),
              ),
              
              //BOTONEs
              Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    //width: width/2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            FilePickerResult result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'JPG', 'jpeg', 'JPEG', 'png', 'PNG',],
                            );
                            if(result != null) {
                              setState(() => error = '');
                              setState(() {uploadedImage = File(result.files.single.path);});
                              
                              setState(() {postProcessed = null;});
                              setState(() {newImage = null;});
                              setState(() {filename = result.files.single.name;});
                            } else {
                              // User canceled the picker
                            }
                            //print('magen cargada');
                            //print('magen cargada');
                          },
                          child: Text('select_image'),
                        ),
                        
                        ////////////////////////////////////////////////////////////////////////////////////////////////////
                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                        /* Boton que cuenta si ya llevas 20 y si eres premium aún puedes descargar  */
                        !user.isAnon ? StreamBuilder<UserCredits>(
                          stream: CheckOutService(uid: user.uid).userCR,
                          initialData: UserCredits(credits: 0),
                          builder: (context, snapshot1) {                        
                            UserCredits userCredits = snapshot1.data ?? UserCredits(credits: 0);
                            if (userCredits.credits == 0) {
                              // si aún no descarga 20 puede procesar
                              return StreamBuilder<int>(
                                stream: DatabaseService(uid: user.uid).userDownloads,
                                builder: (context, snapshot2) {
                                  int downloads = snapshot2.data ?? 0;
                                  if (downloads >= MAXDLS) {
                                    //no puede procesar btn
                                    return ElevatedButton(
                                      onPressed: uploadedImage == null ? null : () {
                                        showDialog(context: context, builder: (_) => upgradeDialog(context, user.uid));
                                      },
                                      child: Text("process")
                                    );
                                  } else {
                                    //aún puede procesar btn
                                    return processButton;
                                  }
                                },
                              );
                            } else {
                              // puede procesar btn
                              return processButton;
                            }
                            
                          },
                        ) : processButton,
                        ////////////////////////////////////////////////////////////////////////////////////////////////////
                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                        SizedBox(height: 5,),
                        ElevatedButton(
                          onPressed: postProcessed == null ? null : ()  async {
                            if (user.isAnon == true) {
                              showDialog(context: context, builder: (_) => logToDownload(context));
                            } else {
                              //ImageSaver.saveImage(postProcessed, 'noBG_' + filename.split('.').first + '.png');
                              var imgPath = await getTemporaryDirectory();

                              //print(image.path);
                              File imageNoBG = new File('${imgPath.path}/noBGIMG.png')..writeAsBytesSync(postProcessed); 
                              
                              GallerySaver.saveImage(imageNoBG.path, albumName: '2xImg');
                              
                              await DatabaseService(uid: user.uid).processedImageCount();
                              showDialog(context: context, builder: (_) => imageSaved(context));
                            } 
                          },
                          child: Text("download_image")
                        ),

                        Text(error, style: TextStyle(color: Colors.orange[800]),)
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 5,),
                    Row(
                      mainAxisSize: MainAxisSize.max, 
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('fast_processing'),
                        FlutterSwitch(
                          value: fastProcess, 
                          height: 20.0,
                          toggleSize: 20.0,
                          width: 40,
                          padding: 0,
                          onToggle: (bool val) {
                            setState(() {
                              fastProcess = val;
                            });
                          }
                        )
                      ],
                    ),
                    SizedBox(height: 5,),
                ],
              ),
              
            ],
          ),
        ),

        //Spacer(),
      ],
    );
  }

  void _postProcess() async {
    //setState(() => postProcessed = null);
    postProcessed = await compute(postProcess, [uploadedImage.readAsBytesSync(), newImage, blur, threshold]);
    setState(() => loading = false);
  }
}

class CustomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3)
        ),
        child: Center(child: Text('not_image_yet')),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      //decoration: BoxDecoration(color: Colors.white),
      child: const SpinKitCubeGrid(
        color: Colors.white,
        size: 150.0,
      ),
    );
  }
}

