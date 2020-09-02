import 'dart:convert';
import 'package:dio/dio.dart';

import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as image2;
import 'package:path_provider/path_provider.dart';


class SRWGeneratorOnline {
  String modelConfig; 
  File image;
  SRWGeneratorOnline({this.image, this.modelConfig});

  Future generate2xImage() async {
    String url = 'http://127.0.0.1:5000/generate';

    FormData formData = FormData.fromMap({
      "model": modelConfig,
      "image": MultipartFile.fromFile(image.path),
    });
    
    /*try{
      Response response = await dio.post(url, data: formData);
    } on DioError catch (e) {
      print(e.response.data);
    }*/
    
    Response response = await dio.post(url, data: formData);

    String strImage = response.data['img'];
    var decodedImage = base64Decode(strImage);

    var output = image2.decodePng(decodedImage);

    var imgPath = await getTemporaryDirectory();
    File twoXimage = new File('${imgPath.path}/resizedImg.png')..writeAsBytesSync(image2.encodePng(output)); 
    
    return twoXimage;
  }
}
