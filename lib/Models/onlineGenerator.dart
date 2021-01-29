import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as image2;
import 'package:path_provider/path_provider.dart';
import 'package:srwnn_mobile/Qliphort.dart';
//import 'dart:convert';


class SRWGeneratorOnline {
  String modelConfig; 
  File image;
  SRWGeneratorOnline({this.image, this.modelConfig});

  Future generate2xImage() async {
    String url = QLIPHORT;

    FormData formData = new FormData.fromMap({
      "model": modelConfig.toString(),
      "image": await MultipartFile.fromFile(image.path.toString())
    });
      
    Dio dio = new Dio();
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 350000;
    print('starting requ');
    //Response response =  await dio.post(url, data: formData);
    Response response;
    try{
      response = await dio.post(url, data: formData);
      print(response.data['msg']);
    } on DioError catch (e) {
      print('ERROR');
      print(e.error);
      throw Error();
    }
    //print('Response Recived');
    //Response response= await dio.post(url, data: formData);
    String message = await response.data['msg'];
    //print(message);
    if (message != '1'){
      throw Exception();
    }
    String strImage = await response.data['img'];
    //print(strImage);

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
