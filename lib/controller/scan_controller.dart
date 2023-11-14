import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_vision/flutter_vision.dart';

class ScanController extends GetxController{
  CameraImage? cameraImage;

  @override
  void onInit(){
    super.onInit();
    initCamera();
    initTFlite();
    label = "ddd";
  }

  @override
  void dispose(){
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var x,y,w,h = 0.0;
  var x1, x2, y1, y2;
  var label;
  var cameraCout = 0;
  var imgHeight =0;
  var imgWidth = 0;
  var isCameraInitialized = false.obs;
  FlutterVision vision = FlutterVision();
  late Timer yoloTimer;
  var ourDetectedObject;


  late Timer frameTimer;

  void startFrameTimer() {
    const frameDuration = const Duration(milliseconds: 32); // 16ms là thời gian giữa các khung hình, tương đương với 60 khung hình mỗi giây
    frameTimer = Timer.periodic(frameDuration, (timer) {
      // Thực hiện xử lý khung hình ở đây, ví dụ:
      objectDectector(cameraImage!);
    });
  }

  void stopFrameTimer() {
    frameTimer?.cancel();
  }



  initCamera() async{
    if(await Permission.camera.request().isGranted)
      {
        cameras = await availableCameras();
        print("initCamera");
        cameraController = await CameraController(
          cameras[0],
          ResolutionPreset.max,          // imageFormatGroup: ImageFormatGroup.fromCameras(cameras),
        );
        await cameraController.initialize().then((value) {
           cameraController.startImageStream((image){
             cameraImage = image;
             cameraCout++;
             if(cameraCout% 5==0){
               cameraCout =0;
               objectDectector(image);
             }
             update();
           });
        });
        isCameraInitialized(true);
        startFrameTimer();
        // startYoloTimer(); // Bắt đầu chạy YOLO mỗi 0.25 giây
        update();
      }
    else
      {
        print("Permission denies");
      }
    update();
  }

  initTFlite() async{
    // await Tflite.loadModel(
    //   model: "assets/model1.tflite",
    //   labels: "assets/label1.txt",
    //   isAsset: true,
    //   numThreads: 1,
    //   useGpuDelegate: false,
    // );

    // Use Yolo v8
    await vision.loadYoloModel(
        modelPath: 'assets/best_float16.tflite',
        labels: 'assets/labelmodel.txt',
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 4,
        useGpu: false);

    //YoloV5
    // await vision.loadYoloModel(
    //     labels: 'assets/labels.txt',
    //     modelPath: 'assets/yolov8n.tflite',
    //     modelVersion: "yolov8",
    //     quantization: false,
    //     numThreads: 1,
    //     useGpu: false);

  }



  // objectDectector(CameraImage image) async{
  //   // var detector = await Tflite.runModelOnFrame(
  //   //     bytesList: image.planes.map((e){
  //   //       return e.bytes;
  //   // }).toList(),
  //   // asynch: true,
  //   // imageHeight: image.height,
  //   // imageWidth: image.width,
  //   // imageMean: 127.5,
  //   // imageStd: 127.5,
  //   // numResults: 1,
  //   // rotation: 90,
  //   // threshold: 0.4
  //   // );
  //
  //   ///Using SSDMobileNet
  //   // var detector = await Tflite.detectObjectOnFrame(
  //   //     bytesList: image.planes.map((plane) {return plane.bytes;}).toList(),// required
  //   //     model: "SSDMobileNet",
  //   //     // model: "YOLO",
  //   //     imageHeight: image.height,
  //   //     imageWidth: image.width,
  //   //     imageMean: 127.5,   // defaults to 127.5
  //   //     imageStd: 127.5,    // defaults to 127.5
  //   //     rotation: 90,       // defaults to 90, Android only
  //   //     // numResults: 2,      // defaults to 5
  //   //     threshold: 0.1,     // defaults to 0.1
  //   //     asynch: true        // defaults to true
  //   // );
  //
  //   // var detector = await Tflite.detectObjectOnFrame(
  //   //     bytesList: image.planes.map((plane) {return plane.bytes;}).toList(),// required
  //   //     model: "YOLO",
  //   //     imageHeight: image.height,
  //   //     imageWidth: image.width,
  //   //     imageMean: 0,         // defaults to 127.5
  //   //     imageStd: 255.0,      // defaults to 127.5
  //   //     // numResults: 2,        // defaults to 5
  //   //     threshold: 0.1,       // defaults to 0.1
  //   //     numResultsPerClass: 2,// defaults to 5
  //   //     // anchors: anchors,     // defaults to [0.57273,0.677385,1.87446,2.06253,3.33843,5.47434,7.88282,3.52778,9.77052,9.16828]
  //   //     blockSize: 32,        // defaults to 32
  //   //     numBoxesPerBlock: 5,  // defaults to 5
  //   //     asynch: true          // defaults to true
  //   // );
  //
  //   var detector = await vision.yoloOnFrame(
  //       bytesList: image.planes.map((plane) => plane.bytes).toList(),
  //       imageHeight: image.height,
  //       imageWidth: image.width,
  //       iouThreshold: 0.4,
  //       confThreshold: 0.4,
  //       classThreshold: 0.5);
  //
  //   // var detector = await vision.yoloOnFrame(
  //   //     bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
  //   //     imageHeight: cameraImage.height,
  //   //     imageWidth: cameraImage.width,
  //   //     iouThreshold: 0.4,
  //   //     confThreshold: 0.4,
  //   //     classThreshold: 0.5);
  //
  //   // var detector = await vision.yoloOnFrame(
  //   //     bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
  //   //     imageHeight: cameraImage.height,
  //   //     imageWidth: cameraImage.width,
  //   //     iouThreshold: 0.4,
  //   //     confThreshold: 0.4,
  //   //     classThreshold: 0.5);
  //
  //   // if(detector != null){
  //   //   log("Result is $detector ");
  //   //   var ourDectectedObject = detector.first;
  //   //     if(ourDectectedObject['confidenceInClass'] * 100 > 60) {
  //   //       log("Result is $ourDectectedObject ");
  //   //       label = ourDectectedObject['detectedClass'];
  //   //       print("height $label");
  //   //       h = ourDectectedObject["rect"]["h"];
  //   //       print("height $h");
  //   //       w = ourDectectedObject["rect"]["w"];
  //   //       print("width $w");
  //   //       y = ourDectectedObject["rect"]["y"];
  //   //       x = ourDectectedObject["rect"]["x"];
  //   //     }
  //   //   update();
  //   //   // }
  //   // }
  //
  //
  //   //Bắn data với yolov8
  //   imgHeight = image.height;
  //   imgWidth = image.width;
  //   if (detector != null) {
  //     log("Result is $detector ");
  //     ourDetectedObject = detector.first;
  //     var box = ourDetectedObject['box'];
  //     if (box[4] * 100 >=20) {
  //       log("Result is $ourDetectedObject ");
  //       label = ourDetectedObject['tag'];
  //       print("Detected Class: $label");
  //       if (ourDetectedObject['box'] != null) {
  //         print("Result Box: $box");
  //         print("ScanController:");
  //         x1 = double.tryParse(box[0].toString()) ?? box[0];
  //         print("ScanController x1: $x1");
  //         y1 = double.tryParse(box[1].toString()) ?? box[1];
  //         print("ScanController y1: $y1");
  //         x2 = double.tryParse(box[2].toString()) ?? box[2];
  //         print("ScanController x2: $x2");
  //         y2 = double.tryParse(box[3].toString()) ?? box[3];
  //         print("ScanController 5: $y2");
  //         // var classConfidence = double.tryParse(box[4].toString()) ?? box[4];
  //         print("Bounding Box Coordinates 6:");
  //         print("x1: $x1, y1: $y1, x2: $x2, y2: $y2");
  //       }
  //     }
  //     update();
  //   }
  //   else {
  //     detector.clear();
  //     update();
  //   }
  // }

  objectDectector(CameraImage image) async {
    log("objectDectector");
    if (cameraImage == null) {
      return; // Tránh xử lý nếu cameraImage chưa được khởi tạo
    }

    var detector = await vision.yoloOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );

    log("Result is $detector");

    imgHeight = image.height;
    imgWidth = image.width;
    if (detector.isNotEmpty) {
      log("Result is $detector ");
      ourDetectedObject = detector.first;
      var box = ourDetectedObject['box'];
      if (box[4] * 100 >= 20) {
        log("Result is $ourDetectedObject ");
        label = ourDetectedObject['tag'];
        print("Detected Class: $label");
        if (box.length >= 4) {
          x1 = double.tryParse(box[0].toString());
          y1 = double.tryParse(box[1].toString());
          x2 = double.tryParse(box[2].toString());
          y2 = double.tryParse(box[3].toString());
          print("Bounding Box Coordinates:");
          print("x1: $x1, y1: $y1, x2: $x2, y2: $y2");
          update();
        }
      } else {
        handleNoDetection();
        update();
      }
      update();
    } else {
      handleNoDetection();
      update();
    }
  }

  void handleNoDetection() {
    x1 = 0;
    y1 = 0;
    x2 = 0;
    y2 = 0;
    label = "";
  }

}