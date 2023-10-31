// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:testtensorflow/controller/scan_controller.dart';
//
// class CameraView extends StatelessWidget {
//   const CameraView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height - 150;
//     return Scaffold(
//       body: GetBuilder<ScanController>(
//         init: ScanController(),
//         builder: (controller) {
//           // double factorX = screenWidth / (controller.imgWidth);
//           // print('factorX: $factorX');
//           // double imgRatio = controller.imgWidth / controller.imgHeight;
//           // double newWidth = controller.imgWidth * factorX;
//           // double newHeight = newWidth / imgRatio;
//           // double factorY = newHeight / (controller.imgHeight);
//           // print('factor Y: $factorY');
//
//           // double factorX = screenWidth / (controller.imgHeight);
//           // double factorY = screenHeight / (controller.imgWidth);
//
//           double factorX = screenWidth / (controller.imgHeight ?? 1);
//           double factorY = screenHeight / (controller.imgWidth ?? 1);
//           print('factor Y: $factorY');
//
//           // double pady = (screenHeight - newHeight) / 2;
//           // double padx = (screenWidth - newWidth) / 2;
//           // print("CameraView screenWidth: ${screenWidth}");
//           // print("CameraView screenHeight: ${screenHeight}");
//           // print("CameraView x1: ${controller.x1}");
//           // print("CameraView x2: ${controller.x2}");
//           // print("CameraView y1: ${controller.y1}");
//           // print("CameraView y2: ${controller.y2}");
//           // print("CameraView label: ${controller.label}");
//           // print("CameraView imgHeight: ${controller.imgHeight}");
//           // print("CameraView imgWidth: ${controller.imgWidth}");
//           return controller.isCameraInitialized.value
//               ? Stack(
//                 children: [
//                   CameraPreview(controller.cameraController),
//                   // Positioned(
//                   //   left:  (controller.x1 ??1) * factorX,
//                   //   top: (controller.y1??1) * factorY,
//                   //   child: Container(
//                   //     width: (controller.x2??1 - controller.x1??1) * factorX,
//                   //     height: (controller.y2??1 - controller.y1??1)* factorY,
//                   //     decoration: BoxDecoration(
//                   //       borderRadius: BorderRadius.circular(8),
//                   //       border: Border.all(color: Colors.green,width: 4),
//                   //     ),
//                   //     child: Column(
//                   //       mainAxisSize: MainAxisSize.min,
//                   //       children: [
//                   //         Container(
//                   //             color: Colors.white,
//                   //             child: Text("${controller.label}"),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ),
//                   // ),
//
//                   Positioned(
//                     left: controller.x1 != null ? controller.x1 * factorX : null,
//                     top: controller.y1 != null ? controller.y1 * factorY : null,
//                     child: controller.x1 != null && controller.x2 != null && controller.y1 != null && controller.y2 != null
//                         ? Container(
//                           width: (controller.x2 - controller.x1) * factorX,
//                           height: (controller.y2 - controller.y1) * factorY,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.green, width: 4),
//                       ),
//                           child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               color: Colors.white,
//                               child: Text("${controller.label}"),
//                           ),
//                         ],
//                       ),
//                     )
//                         : Container(), // Sử dụng Container rỗng khi giá trị là null
//                   ),
//
//
//                   Column(
//                     children: [
//                       Container(
//                         height: 100,
//                       ),
//                       Text("Size: ${screenWidth} / ${screenHeight}"),
//                       Text("Left: ${controller.x1} / ${controller.x1 * factorX }"),
//                       Text("Top: ${controller.y1} / ${controller.y1 * factorY }"),
//                       Text("Width: ${(controller.x2 - controller.x1) * factorX * 2}"),
//                       Text("Height: ${(controller.y2 - controller.y1) * factorY * 2}"),
//                     ],
//                   )
//                 ],
//               )
//               :const Center(child: Text("Loading Preview..."),);
//         },
//       ),
//     );
//   }
// }

//
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:image/image.dart' as img;
//
// import '../controller/scan_controller.dart'; // Import lớp 'Image' từ thư viện 'image' và đặt tên là 'img'
//
// class CameraView extends StatefulWidget {
//   CameraView({super.key});
//
//   @override
//   _CameraViewState createState() => _CameraViewState();
// }
//
// class _CameraViewState extends State<CameraView> {
//   bool isAutoCaptureEnabled = true;
//   XFile? capturedImage;
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height - 150;
//
//     return Scaffold(
//       body: GetBuilder<ScanController>(
//         init: ScanController(),
//         builder: (controller) {
//           double factorX = screenWidth / (controller.imgHeight ?? 1);
//           double factorY = screenHeight / (controller.imgWidth ?? 1);
//
//           return controller.isCameraInitialized.value
//               ? Stack(
//             children: [
//               CameraPreview(controller.cameraController),
//               Positioned(
//                 left: controller.x1 != null ? controller.x1 * factorX : null,
//                 top: controller.y1 != null ? controller.y1 * factorY : null,
//                 child: isAutoCaptureEnabled &&
//                     controller.x1 != null &&
//                     controller.x2 != null &&
//                     controller.y1 != null &&
//                     controller.y2 != null
//                     ? GestureDetector(
//                   onTap: () async {
//                     try {
//                       capturedImage = await controller.cameraController.takePicture();
//
//                       double x = controller.x1 * factorX;
//                       double y = controller.y1 * factorY;
//                       double width = (controller.x2 - controller.x1) * factorX;
//                       double height = (controller.y2 - controller.y1) * factorY;
//
//                       File croppedImage = await _cropImage(capturedImage, x, y, width, height);
//
//                       setState(() {
//                         capturedImage = XFile(croppedImage.path);
//                       });
//                     } catch (e) {
//                       print("Lỗi khi chụp và cắt hình ảnh: $e");
//                     }
//                   },
//                   child: Container(
//                     width: (controller.x2 - controller.x1) * factorX,
//                     height: (controller.y2 - controller.y1) * factorY,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.green, width: 4),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           color: Colors.white,
//                           child: Text("${controller.label}"),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//                     : Container(),
//               ),
//               capturedImage != null
//                   ? Positioned(
//                 left: 0,
//                 top: 0,
//                 child: Image.file(File(capturedImage!.path)),
//               )
//                   : Container(),
//               Column(
//                 children: [
//                   Container(
//                     height: 100,
//                   ),
//                   Text("Size: ${screenWidth} / ${screenHeight}"),
//                   Text("Left: ${controller.x1} / ${controller.x1 * factorX }"),
//                   Text("Top: ${controller.y1} / ${controller.y1 * factorY }"),
//                   Text("Width: ${(controller.x2 - controller.x1) * factorX * 2}"),
//                   Text("Height: ${(controller.y2 - controller.y1) * factorY * 2}"),
//                 ],
//               )
//             ],
//           )
//               : const Center(
//             child: Text("Loading Preview..."),
//           );
//         },
//       ),
//     );
//   }
//
//
//
//   Future<File> _cropImage(XFile? image, double x, double y, double width, double height) async {
//     final File imageFile = File(image!.path);
//     final img.Image imgImage = img.decodeImage(imageFile.readAsBytesSync())!;
//     final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());
//     final File croppedFile = File('path/to/save/cropped_image.jpg');
//     croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
//
//     return Future.value(croppedFile);
//   }
// }
//

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image/image.dart' as img;
//
// import '../controller/scan_controller.dart';
//
// class CameraView extends StatefulWidget {
//   CameraView({super.key});
//
//   @override
//   _CameraViewState createState() => _CameraViewState();
// }
//
// class _CameraViewState extends State<CameraView> {
//   bool isAutoCaptureEnabled = true;
//   XFile? capturedImage;
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height - 150;
//
//     return Scaffold(
//       body: GetBuilder<ScanController>(
//         init: ScanController(),
//         builder: (controller) {
//           double factorX = screenWidth / (controller.imgHeight ?? 1);
//           double factorY = screenHeight / (controller.imgWidth ?? 1);
//
//           return controller.isCameraInitialized.value
//               ? Stack(
//             children: [
//               CameraPreview(controller.cameraController),
//               Positioned(
//                 left: controller.x1 != null ? controller.x1 * factorX : null,
//                 top: controller.y1 != null ? controller.y1 * factorY : null,
//                 child: isAutoCaptureEnabled &&
//                     controller.x1 != null &&
//                     controller.x2 != null &&
//                     controller.y1 != null &&
//                     controller.y2 != null
//                     ? Container(
//                   width: (controller.x2 - controller.x1) * factorX,
//                   height: (controller.y2 - controller.y1) * factorY,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.green, width: 4),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         color: Colors.white,
//                         child: Text("${controller.label}"),
//                       ),
//                     ],
//                   ),
//                 )
//                     : Container(),
//               ),
//               capturedImage != null
//                   ? Positioned(
//                 left: 0,
//                 top: 0,
//                 child: Image.file(File(capturedImage!.path)),
//               )
//                   : Container(),
//             ],
//           )
//               : const Center(
//             child: Text("Loading Preview..."),
//           );
//         },
//       ),
//     );
//   }
//
//   void autoCaptureIfConditionsMet(ScanController controller, double factorX, double factorY) {
//     if (capturedImage != null) {
//       return;
//     }
//
//     try {
//       capturedImage = controller.cameraController.takePicture();
//
//       double x = controller.x1 * factorX;
//       double y = controller.y1 * factorY;
//       double width = (controller.x2 - controller.x1) * factorX;
//       double height = (controller.y2 - controller.y1) * factorY;
//
//       _cropAndSaveImage(capturedImage!, x, y, width, height);
//     } catch (e) {
//       print("Error capturing and cropping the image: $e");
//     }
//   }
//
//   void _cropAndSaveImage(XFile image, double x, double y, double width, double height) {
//     final File imageFile = File(image.path);
//     final img.Image imgImage = img.decodeImage(imageFile.readAsBytesSync())!;
//     final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());
//     final File croppedFile = File('path/to/save/cropped_image.jpg');
//     croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
//
//     // You may want to do something with the cropped image here, like saving it or displaying it.
//   }
// }

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image/image.dart' as img;
//
// import '../controller/scan_controller.dart';
//
// class CameraView extends StatefulWidget {
//   CameraView({super.key});
//
//   @override
//   _CameraViewState createState() => _CameraViewState();
// }
//
// class _CameraViewState extends State<CameraView> {
//   bool isAutoCaptureEnabled = true;
//   XFile? capturedImage;
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height - 150;
//
//     return Scaffold(
//       body: GetBuilder<ScanController>(
//         init: ScanController(),
//         builder: (controller) {
//           double factorX = screenWidth / (controller.imgHeight ?? 1);
//           double factorY = screenHeight / (controller.imgWidth ?? 1);
//
//           return controller.isCameraInitialized.value
//               ? Stack(
//             children: [
//               CameraPreview(controller.cameraController),
//               Positioned(
//                 left: controller.x1 != null ? controller.x1 * factorX : null,
//                 top: controller.y1 != null ? controller.y1 * factorY : null,
//                 child: isAutoCaptureEnabled &&
//                     controller.x1 != null &&
//                     controller.x2 != null &&
//                     controller.y1 != null &&
//                     controller.y2 != null
//                     ? Container(
//                   width: (controller.x2 - controller.x1) * factorX,
//                   height: (controller.y2 - controller.y1) * factorY,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.green, width: 4),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         color: Colors.white,
//                         child: Text("${controller.label}"),
//                       ),
//                     ],
//                   ),
//                 )
//                     : Container(),
//               ),
//               capturedImage != null
//                   ? Positioned(
//                 left: 0,
//                 top: 0,
//                 child: Image.file(File(capturedImage!.path)),
//               )
//                   : Container(),
//             ],
//           )
//               : const Center(
//             child: Text("Loading Preview..."),
//           );
//         },
//       ),
//     );
//   }
//
//   void autoCaptureIfConditionsMet(ScanController controller, double factorX, double factorY) {
//     if (capturedImage != null) {
//       return;
//     }
//
//     _captureAndCropImage(controller, factorX, factorY);
//   }
//
//   Future<void> _captureAndCropImage(ScanController controller, double factorX, double factorY) async {
//     try {
//       final XFile captured = await controller.cameraController.takePicture();
//
//       double x = controller.x1! * factorX;
//       double y = controller.y1! * factorY;
//       double width = (controller.x2! - controller.x1!) * factorX;
//       double height = (controller.y2! - controller.y1!) * factorY;
//
//       _cropAndSaveImage(captured, x, y, width, height);
//     } catch (e) {
//       print("Error capturing and cropping the image: $e");
//     }
//   }
//
//   void _cropAndSaveImage(XFile image, double x, double y, double width, double height) {
//     final File imageFile = File(image.path);
//     final img.Image imgImage = img.decodeImage(imageFile.readAsBytesSync())!;
//     final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());
//     final File croppedFile = File('path/to/save/cropped_image.jpg');
//     croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
//
//     // You may want to do something with the cropped image here, like saving it or displaying it.
//     setState(() {
//       capturedImage = XFile(croppedFile.path);
//     });
//   }
// }

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image/image.dart' as img;
//
// import '../controller/scan_controller.dart';
//
// class CameraView extends StatefulWidget {
//   CameraView({super.key});
//
//   @override
//   _CameraViewState createState() => _CameraViewState();
// }
//
// class _CameraViewState extends State<CameraView> {
//   bool isAutoCaptureEnabled = true;
//   XFile? capturedImage;
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height - 150;
//
//     return Scaffold(
//       body: GetBuilder<ScanController>(
//         init: ScanController(),
//         builder: (controller) {
//           double factorX = screenWidth / (controller.imgHeight ?? 1);
//           double factorY = screenHeight / (controller.imgWidth ?? 1);
//
//           return controller.isCameraInitialized.value
//               ? Stack(
//             children: [
//               CameraPreview(controller.cameraController),
//               Positioned(
//                 left: controller.x1 != null ? controller.x1 * factorX : null,
//                 top: controller.y1 != null ? controller.y1 * factorY : null,
//                 child: isAutoCaptureEnabled &&
//                     controller.x1 != null &&
//                     controller.x2 != null &&
//                     controller.y1 != null &&
//                     controller.y2 != null
//                     ? GestureDetector(
//                   onTap: () async {
//                     // Bạn có thể chụp ảnh bằng cách gọi hàm autoCaptureIfConditionsMet:
//                     autoCaptureIfConditionsMet(controller, factorX, factorY);
//                   },
//                   child: Container(
//                     width: (controller.x2 - controller.x1) * factorX,
//                     height: (controller.y2 - controller.y1) * factorY,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.green, width: 4),
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           color: Colors.white,
//                           child: Text("${controller.label}"),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//                     : Container(),
//               ),
//               capturedImage != null
//                   ? Positioned(
//                 left: 0,
//                 top: 0,
//                 child: Image.file(File(capturedImage!.path)),
//               )
//                   : Container(),
//             ],
//           )
//               : const Center(
//             child: Text("Loading Preview..."),
//           );
//         },
//       ),
//     );
//   }
//
//   void autoCaptureIfConditionsMet(ScanController controller, double factorX, double factorY) {
//     if (capturedImage != null) {
//       return;
//     }
//
//     _captureAndCropImage(controller, factorX, factorY);
//   }
//
//   Future<void> _captureAndCropImage(ScanController controller, double factorX, double factorY) async {
//     try {
//       final XFile captured = await controller.cameraController.takePicture();
//
//       double x = controller.x1! * factorX;
//       double y = controller.y1! * factorY;
//       double width = (controller.x2! - controller.x1!) * factorX;
//       double height = (controller.y2! - controller.y1!) * factorY;
//
//       _cropAndSaveImage(captured, x, y, width, height);
//     } catch (e) {
//       print("Error capturing and cropping the image: $e");
//     }
//   }
//
//   void _cropAndSaveImage(XFile image, double x, double y, double width, double height) {
//     final File imageFile = File(image.path);
//     final img.Image imgImage = img.decodeImage(imageFile.readAsBytesSync())!;
//     final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());
//     final File croppedFile = File('path/to/save/cropped_image.jpg');
//     croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
//     print("Path ảnh: %$croppedFile");
//     // You may want to do something with the cropped image here, like saving it or displaying it.
//     setState(() {
//       capturedImage = XFile(croppedFile.path);
//     });
//   }
// }


// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image/image.dart' as img;
//
// import '../controller/scan_controller.dart';
//
// class CameraView extends StatefulWidget {
//   CameraView({super.key});
//
//   @override
//   _CameraViewState createState() => _CameraViewState();
// }
//
// class _CameraViewState extends State<CameraView> {
//   bool isAutoCaptureEnabled = true;
//   XFile? capturedImage;
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height - 150;
//
//     return Scaffold(
//       body: GetBuilder<ScanController>(
//         init: ScanController(),
//         builder: (controller) {
//           double factorX = screenWidth / (controller.imgHeight ?? 1);
//           double factorY = screenHeight / (controller.imgWidth ?? 1);
//
//           // Auto capture when conditions are met
//           autoCaptureIfConditionsMet(controller, factorX, factorY);
//
//           return controller.isCameraInitialized.value
//               ? Stack(
//             children: [
//               CameraPreview(controller.cameraController),
//               Positioned(
//                 left: controller.x1 != null ? controller.x1 * factorX : null,
//                 top: controller.y1 != null ? controller.y1 * factorY : null,
//                 child: isAutoCaptureEnabled &&
//                     controller.x1 != null &&
//                     controller.x2 != null &&
//                     controller.y1 != null &&
//                     controller.y2 != null
//                     ? Container(
//                   width: (controller.x2 - controller.x1) * factorX,
//                   height: (controller.y2 - controller.y1) * factorY,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.green, width: 4),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         color: Colors.white,
//                         child: Text("${controller.label}"),
//                       ),
//                     ],
//                   ),
//                 )
//                     : Container(),
//               ),
//               capturedImage != null
//                   ? Positioned(
//                 left: 0,
//                 top: 0,
//                 child: Image.file(File(capturedImage!.path)),
//               )
//                   : Container(),
//             ],
//           )
//               : const Center(
//             child: Text("Loading Preview..."),
//           );
//         },
//       ),
//     );
//   }
//
//   void autoCaptureIfConditionsMet(ScanController controller, double factorX, double factorY) {
//     if (capturedImage != null) {
//       return;
//     }
//
//     if (controller.x1 != null &&
//         controller.x2 != null &&
//         controller.y1 != null &&
//         controller.y2 != null) {
//       _captureAndCropImage(controller, factorX, factorY);
//     }
//   }
//
//   Future<void> _captureAndCropImage(ScanController controller, double factorX, double factorY) async {
//     try {
//       final XFile captured = await controller.cameraController.takePicture();
//
//       double x = controller.x1! * factorX;
//       double y = controller.y1! * factorY;
//       double width = (controller.x2! - controller.x1!) * factorX;
//       double height = (controller.y2! - controller.y1!) * factorY;
//
//       _cropAndSaveImage(captured, x, y, width, height);
//     } catch (e) {
//       print("Error capturing and cropping the image: $e");
//     }
//   }
//
//   void _cropAndSaveImage(XFile image, double x, double y, double width, double height) {
//     final File imageFile = File(image.path);
//     final img.Image imgImage = img.decodeImage(imageFile.readAsBytesSync())!;
//     final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());
//     final File croppedFile = File('path/to/save/cropped_image.jpg');
//     croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
//
//     // You may want to do something with the cropped image here, like saving it or displaying it.
//     setState(() {
//       capturedImage = XFile(croppedFile.path);
//     });
//   }
// }

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image/image.dart' as img;
//
// import '../controller/scan_controller.dart';
//
// class CameraView extends StatefulWidget {
//   CameraView({super.key});
//
//   @override
//   _CameraViewState createState() => _CameraViewState();
// }
//
// class _CameraViewState extends State<CameraView> {
//   XFile? capturedImage;
//   bool isCapturing = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GetBuilder<ScanController>(
//         init: ScanController(),
//         builder: (controller) {
//           return controller.isCameraInitialized.value
//               ? Stack(
//             children: [
//               CameraPreview(controller.cameraController),
//             ],
//           )
//               : const Center(
//             child: Text("Loading Preview..."),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           if (!isCapturing) {
//             isCapturing = true;
//             XFile? captured = await _captureImage();
//             isCapturing = false;
//
//             if (captured != null) {
//               setState(() {
//                 capturedImage = captured;
//               });
//             }
//           }
//         },
//         child: Icon(Icons.camera_alt),
//       ),
//     );
//   }
//
//   Future<XFile?> _captureImage() async {
//     try {
//       final ScanController controller = Get.find<ScanController>();
//       return await controller.cameraController.takePicture();
//     } catch (e) {
//       print("Lỗi khi chụp ảnh: $e");
//       return null;
//     }
//   }
// }

