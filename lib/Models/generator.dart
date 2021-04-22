/* import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as image2;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:path_provider/path_provider.dart';


class SRWGenerator {
  String modelPath; 
  File image;
  SRWGenerator({this.image, this.modelPath});
  //TensorImage tensorImage;
  //ImageProcessor imageProcessor;
  //TensorBuffer reShapeImgBuffer;
  //TensorBuffer probabilityBuffer;
  //TensorProcessor outputProcessor;
  //TensorBuffer outCasted;
  //TensorImage output;
  //File twoXimage;

  Future generate2xImage() async {
    TensorImage tensorImage = TensorImage.fromFile(image);
    //print('tensorimage');
    //print(tensorImage.getTensorBuffer().shape);
    //print(tensorImage.getDataType());
    //print(tensorImage.buffer.asUint8List());

    //normalices input = (input/127.5) - 1
    ImageProcessor imageProcessor = ImageProcessorBuilder()
    .add(NormalizeOp(0, 127.5))
    .add(NormalizeOp(1, 1))
    .build();
    tensorImage = imageProcessor.process(tensorImage);
    
    //Prepares to reshapes img buffer to [1,m,n,3]
    TensorBuffer reShapeImgBuffer = TensorBuffer.createFrom(tensorImage.getTensorBuffer(), TfLiteType.float32);
    //print(reShapeImgBuffer.shape); 
    //reshapes img buffer to [1,m,n,3]
    // ignore: invalid_use_of_protected_member
    reShapeImgBuffer.resize([1, tensorImage.height.toInt(), tensorImage.width.toInt(), 3]);
    //print(reShapeImgBuffer.shape);

    //Creates outputTensor as [1,m*2,n*2,3]
    TensorBuffer probabilityBuffer = TensorBuffer.createFixedSize([1, tensorImage.height.toInt() * 2, tensorImage.width.toInt() * 2, 3], TfLiteType.float32);
    //var interpreterOptions = InterpreterOptions()..useNnApiForAndroid = true;
    
    //creates model interpreter
    //var interpreterOptions = InterpreterOptions()..addDelegate(NnApiDelegate());
    
    Interpreter interpreter = await Interpreter.fromAsset(modelPath);
    //resize interpreter input to match [1,m*2,n*2,3]
    interpreter.resizeInputTensor(0, [1, tensorImage.height.toInt(), tensorImage.width.toInt(), 3]);
    //print('Input Shape:');
    //print(interpreter.getInputTensor(0).shape);

    //run model
    //print('running model...');
    interpreter.run(reShapeImgBuffer.buffer, probabilityBuffer.buffer);
    //interpreter.
    interpreter.close();
    //print('out before run');
    //print(probabilityBuffer.shape);
    //print(probabilityBuffer.buffer.asFloat32List());

    //prepares image from tensor
    // ignore: invalid_use_of_protected_member
    probabilityBuffer.resize([tensorImage.height.toInt()*2, tensorImage.width.toInt()*2, 3]);
    //print('out after re');
    //print(probabilityBuffer.shape);
    //print(probabilityBuffer.buffer.asFloat32List());

    TensorProcessor outputProcessor = TensorProcessorBuilder()
    .add(NormalizeOp(-1, 2))
    .add(NormalizeOp(0, 0.00392156862))
    .add(CastOp(TfLiteType.uint8))
    .build();

    TensorBuffer outCasted = outputProcessor.process(probabilityBuffer);
    TensorImage output = TensorImage.fromTensorBuffer(outCasted);
    //print('Output shape casted an i another tensor');
    //print(output.getTensorBuffer().shape);
    //print(output.getDataType());
    //print(output.getBuffer().asUint8List());

    var imgPath = await getTemporaryDirectory();
    File twoXimage = new File('${imgPath.path}/resizedImg.png')..writeAsBytesSync(image2.encodePng(output.image)); 
    
    return twoXimage;
  }
}
 */