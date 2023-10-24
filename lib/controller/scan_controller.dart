import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController{

  @override
  void onInit(){
    super.onInit();
    initCamera();
    initTFlite();
    // label = "ddd";
  }

  @override
  void dispose(){
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late CameraImage cameraImage;
  var x,y,w,h = 0.0;
  var label="ádfjdkj";
  var cameraCout = 0;
  var isCameraInitialized = false.obs;


  initCamera() async{
    if(await Permission.camera.request().isGranted)
      {
        cameras = await availableCameras();

        cameraController = await CameraController(
          cameras[0],
          ResolutionPreset.max,
          // imageFormatGroup: ImageFormatGroup.fromCameras(cameras),
        );
        await cameraController.initialize().then((value) {
           cameraController.startImageStream((image){
             cameraCout++;
             if(cameraCout%10==0){
               cameraCout =0;
               objectDectector(image);
             }
             update();
           });
        });
        isCameraInitialized(true);
        update();
      }
    else
      {
        print("Permission denies");
      }
  }

  initTFlite() async{
    await Tflite.loadModel(
      model: "assets/model1.tflite",
      labels: "assets/label1.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  objectDectector(CameraImage image) async{
    // var detector = await Tflite.runModelOnFrame(
    //     bytesList: image.planes.map((e){
    //       return e.bytes;
    // }).toList(),
    // asynch: true,
    // imageHeight: image.height,
    // imageWidth: image.width,
    // imageMean: 127.5,
    // imageStd: 127.5,
    // numResults: 1,
    // rotation: 90,
    // threshold: 0.4
    // );

    ///Using SSDMobileNet
    var detector = await Tflite.detectObjectOnFrame(
        bytesList: image.planes.map((plane) {return plane.bytes;}).toList(),// required
        model: "SSDMobileNet",
        // model: "YOLO",
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,   // defaults to 127.5
        imageStd: 127.5,    // defaults to 127.5
        rotation: 90,       // defaults to 90, Android only
        // numResults: 2,      // defaults to 5
        threshold: 0.1,     // defaults to 0.1
        asynch: true        // defaults to true
    );

    // var detector = await Tflite.detectObjectOnFrame(
    //     bytesList: image.planes.map((plane) {return plane.bytes;}).toList(),// required
    //     model: "YOLO",
    //     imageHeight: image.height,
    //     imageWidth: image.width,
    //     imageMean: 0,         // defaults to 127.5
    //     imageStd: 255.0,      // defaults to 127.5
    //     // numResults: 2,        // defaults to 5
    //     threshold: 0.1,       // defaults to 0.1
    //     numResultsPerClass: 2,// defaults to 5
    //     // anchors: anchors,     // defaults to [0.57273,0.677385,1.87446,2.06253,3.33843,5.47434,7.88282,3.52778,9.77052,9.16828]
    //     blockSize: 32,        // defaults to 32
    //     numBoxesPerBlock: 5,  // defaults to 5
    //     asynch: true          // defaults to true
    // );



    if(detector != null){
      log("Result is $detector ");
      var ourDectectedObject = detector.first;
        if(ourDectectedObject['confidenceInClass'] * 100 > 60) {
          log("Result is $ourDectectedObject ");
          label = ourDectectedObject['detectedClass'];
          print("height $label");
          h = ourDectectedObject["rect"]["h"];
          print("height $h");
          w = ourDectectedObject["rect"]["w"];
          print("width $w");
          y = ourDectectedObject["rect"]["y"];
          x = ourDectectedObject["rect"]["x"];
        }
      update();
      // }
    }

  }
}