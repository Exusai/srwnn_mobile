//import 'package:srwnn_mobile/Controllers/ModelConfigs.dart';
//import 'package:srwnn_mobile/Controllers/ModelConfigs.dart';
class SRModelSelector{
  int model = 0;
  int style = 0;
  int noiseLevel = 0;
  int blurLevel = 0;
  int expansion = 0;
  int upscaleLevel = 0;
  bool executionOnline = true;

  String updateParameters(){
    if (expansion == 1 && (model + style + noiseLevel + blurLevel + upscaleLevel) != 0){
      model = 0;
      style = 0;
      noiseLevel = 0;
      blurLevel = 0;
      expansion = 0;
      upscaleLevel = 0;
      return 'msg_invalid_config';
    }
    else if(style == 1 && (noiseLevel + blurLevel + upscaleLevel) != 0 ){
      noiseLevel = 0;
      blurLevel = 0;
      expansion = 0;
      upscaleLevel = 0;
      return 'msg_invalid_config';
    } 
    else if(noiseLevel > 0 && blurLevel > 0){
      blurLevel = 0;
      noiseLevel = 0;
      return 'msg_invalid_config';
    }
    else if (model == 1) {
      style = 1;
      executionOnline = true;
      noiseLevel = 0;
      blurLevel = 0;
      return 'msg_esergan_not_av';
    }
    else if (style == 1) {
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
    else if (executionOnline == false) {
      return 'msg_local_warning';
    }

    else if (executionOnline == true) {
      return 'msg_web_wanrning';
    }
    else return '';
  }

  String getModelPath(){
    //return 'models/srwnn.tflite';
    String modelConfig = getModelConfig();

    if(modelConfig == '0000') return 'models/srwnn.tflite';
    if(modelConfig == '0100') return 'models/ .tflite'; //change later
    if(modelConfig == '0010') return 'models/SRWNNdeNoise1.tflite';
    if(modelConfig == '0020') return 'models/SRWNNdeNoise2.tflite';
    if(modelConfig == '0030') return 'models/SRWNNdeNoise3.tflite';
    if(modelConfig == '0001') return 'models/SRWNNdeBlur1.tflite';
    if(modelConfig == '0002') return 'models/SRWNNdeBlur2.tflite';
    if(modelConfig == '0003') return 'models/SRWNNdeBlur3.tflite';
    else return 'models/srwnn.tflite';
  }

  String getModelConfig(){
    String m = model.toString();
    String s = style.toString();
    String n = noiseLevel.toString();
    String b = blurLevel.toString();
    //expansion = 0;
    //upscaleLevel = 0;
    ///--- MSNB
    String modelConfigurationString = m + s + n + b;  
    print('SELECTED MODEL CONFIGURATION: ');
    print(modelConfigurationString);
    return modelConfigurationString;
  }

  String getImageOutExmaple(){
    if (executionOnline == true){
      //return 'assets/images/modelExamples/OutBaseModelWeb.png';
      if(model == 0 && (style + noiseLevel + blurLevel + upscaleLevel) == 0){
        return 'assets/images/modelExamples/OutBaseModelWeb.png';
      }
      else if(model == 1 ){
        return 'assets/images/modelExamples/esrganOUT.png';
      }
      else if(noiseLevel == 1 && (style + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/denoise1OUT.png';
      }
      else if(noiseLevel == 2 && (style + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/denoise2OUT.png';
      }
      else if(noiseLevel == 3 && (style + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/denoise3OUT.png';
      }
      else if(blurLevel == 1 && (style + noiseLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/deblur1OUT.png';
      }
      else if(blurLevel == 2 && (style + noiseLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/deblur2OUT.png';
      }
      else if(blurLevel == 3 && (style + noiseLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/deblur3OUT.png';
      }
      else if(style == 1 && (noiseLevel + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/srwnnPhotoOUT.png';
      }
    }
    else {
      //return 'assets/images/modelExamples/OutBaseModelLite.png';
      if(model == 0 && (style + noiseLevel + blurLevel + upscaleLevel) == 0){
        return 'assets/images/modelExamples/OutBaseModelLite.png';
      }
      else if(noiseLevel == 1 && (style + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/denoiseLite1OUT.png';
      }
      else if(noiseLevel == 2 && (style + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/denoiseLite2OUT.png';
      }
      else if(noiseLevel == 3 && (style + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/denoiseLite3OUT.png';
      }
      else if(blurLevel == 1 && (style + noiseLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/deblurLite1OUT.png';
      }
      else if(blurLevel == 2 && (style + noiseLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/deblurLite2OUT.png';
      }
      else if(blurLevel == 3 && (style + noiseLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/deblurLite3OUT.png';
      }
      else if(style == 1 && (noiseLevel + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/srwnnPhotoLite1OUT.png';
      }
    }
  }

  String getImageInExample(){
    if (executionOnline == true){
      //return 'assets/images/modelExamples/OutBaseModelWeb.png';
      if(model == 0 && (style + noiseLevel + blurLevel + upscaleLevel) == 0){
        return 'assets/images/modelExamples/InBaseModelWeb.png';
      }
      else if(model == 1 ){
        return 'assets/images/modelExamples/esrganIN.png';
      }
      else if(noiseLevel == 1 && (style + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/denoise1IN.png';
      }
      else if(noiseLevel == 2 && (style + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/denoise2IN.png';
      }
      else if(noiseLevel == 3 && (style + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/denoise3IN.png';
      }
      else if(blurLevel == 1 && (style + noiseLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/deblur1IN.png';
      }
      else if(blurLevel == 2 && (style + noiseLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/deblur2IN.png';
      }
      else if(blurLevel == 3 && (style + noiseLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/deblur3IN.png';
      }
      else if(style == 1 && (noiseLevel + blurLevel + upscaleLevel) == 0 ){
        return 'assets/images/modelExamples/srwnnPhotoIN.png';
      } 
    }
    else {
      return 'assets/images/modelExamples/InBaseModelWeb.png';
    }
  }
}