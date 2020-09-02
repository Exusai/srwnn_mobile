//import 'package:srwnn_mobile/Controllers/ModelConfigs.dart';

class SRModelSelector{
  int model = 0;
  int style = 0;
  int noiseLevel = 0;
  int blurLevel = 0;
  int expansion = 0;
  int upscaleLevel = 0;
  int execution = 1;

  //SRModelSelector({this.model, this.style, this.noiseLevel, this.blurLevel, this.expansion, this.upscaleLevel});

  String updateParameters(){
    //if wea happens, update restrictions and change to valid config

    if (expansion == 1 && (model + style + noiseLevel + blurLevel + upscaleLevel) != 0){
      model = 0;
      style = 0;
      noiseLevel = 0;
      blurLevel = 0;
      expansion = 0;
      upscaleLevel = 0;
      return 'msg_invalid_config';
    }
    else if (model == 1) {
      model = 0;
      return 'msg_esergan_not_av';
    }
    else if (style == 1) {
      style = 0;
      return 'msg_photo_not_av';
    }
    else return _getMessage();
  }

  String _getMessage(){
    //evaluate inputs and return a message based on that
    if (upscaleLevel == 1) {
      return 'heavy_op_warning';
    }
    else if (expansion == 1) {
      return 'msg_experimental_feature';
    }
    else if (execution == 0) {
      return 'msg_local_warning';
    }

    else if (execution == 1) {
      //return '''Requieres internet connection, but server computing power and usage is limited becuse I don't have money. 
      //and it may or may not be available. If it is not, your image is going to be processed on your device.'''; 
      return 'msg_web_wanrning';
    }
    
    else return '';
  }

  String getModelPath(){
    //evaluate inputs and return a message based on that
    return 'models/srwnn.tflite';
    //return 'models/latency.tflite';
  }

  String getModelConfig(){
    return '0000';
  }

  String getImageOutExmaple(){
    if (execution == 1){
      return 'assets/images/modelExamples/OutBaseModelWeb.png';
    }
    else {
      return 'assets/images/modelExamples/OutBaseModelLite.png';
    }
  }

  String getImageInExample(){
    return 'assets/images/modelExamples/InBaseModelWeb.png';
  }
}