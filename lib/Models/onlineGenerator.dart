import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as image2;
import 'package:path_provider/path_provider.dart';
//import 'dart:convert';


class SRWGeneratorOnline {
  String modelConfig; 
  File image;
  SRWGeneratorOnline({this.image, this.modelConfig});

  Future generate2xImage() async {
    String url = 'http://45.79.59.144/generate';

    FormData formData = new FormData.fromMap({
      "model": modelConfig.toString(),
      "image": await MultipartFile.fromFile(image.path.toString())
    });
      
    Dio dio = new Dio();
    dio.options.connectTimeout = 120000;
    dio.options.receiveTimeout = 120000;

    //Response response =  await dio.post(url, data: formData);
    Response response;
    try{
      response = await dio.post(url, data: formData);
    } on DioError {
      //print('error');
      throw Error();
    }
    

    //Response response= await dio.post(url, data: formData);
    String message = await response.data['msg'];
    if (message != 1){
      throw Exception();
    }
    String strImage = await response.data['img'];

    //Codec<String, String> stringToBase64 = utf8.fuse(base64);
    //var decodedImage = base64.decode(strImage);

    String splitStr = strImage.split("b'").last;
    //print(splitStr);

    String splitStr2 = splitStr.substring(0, splitStr.length - 1);  
    
    //print(splitStr2);

    Uint8List decodedImage = base64.decode(splitStr2);
    
    var output = image2.decodeImage(decodedImage);

    var imgPath = await getTemporaryDirectory();

    //print(image.path);
    File twoXimage = new File('${imgPath.path}/resizedImg.png')..writeAsBytesSync(image2.encodePng(output)); 
    //print(twoXimage.path);
    
    return twoXimage;
  }
}
