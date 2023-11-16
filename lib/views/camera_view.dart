import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';
import '../controller/scan_controller.dart';
// import 'button_Camera.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';


import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class CameraView extends StatefulWidget {
  CameraView({super.key});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  XFile? capturedImage;
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  bool isAutoCapturing = false;
  int count =0;


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height - 150;

    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          double factorX = screenWidth / (controller.imgHeight ?? 1);
          double factorY = screenHeight / (controller.imgWidth ?? 1);

          // double x = (controller.x2 - controller.x1)/1.0;
          // double y = (controller.y2 - controller.y1)/1.0;

          double x = (controller.x1)*1.0;
          double y = (controller.y1)*1.0;
          double width = (controller.x2 - controller.x1)*1.0;
          double height = (controller.y2 - controller.y1)*1.0;
          print("Dô rồi nè 1 ");
          if (controller.isCameraInitialized.value) {
            print("Dô rồi nè 2: ${controller.label}");

            if(count > 15){
              print('Chụp chỗ này $count');
              autoCapture(controller, factorX, factorY, x, y, width, height);
            }

            if( controller.label == "CCCD_Chip_FrontSide")
            {

              count++;
              print('Đếm $count');
            }
            if( controller.label == "CCCD_Chip_BackSide")
            {
              count= 0;
              print('Đếm $count');
            }
            if( controller.label == "CCCD_NoChip")
            {
              count= 0;
              print('Đếm $count');
            }
            if( controller.label == "CMND")
            {
              count= 0;
              print('Đếm $count');
            }
            print("Dô rồi nè 3");
            return capturedImage!=null ?
            SafeArea(
              child: Column(
                children: [
                  Container(height: 200,),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Image.file(
                      File(capturedImage!.path),
                    ),
                  ),
                ],
              ),
            )
                :
            Stack(
              children: [
                CameraPreview(controller.cameraController),
                Positioned(
                  left: controller.x1 != null ? controller.x1 * factorX : null,
                  top: controller.y1 != null ? controller.y1 * factorY : null,
                  child: controller.x1 != null &&
                      controller.x2 != null &&
                      controller.y1 != null &&
                      controller.y2 != null
                      ? Container(
                    width: (controller.x2 - controller.x1) * factorX,
                    height: (controller.y2 - controller.y1) * factorY,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green, width: 4),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Colors.white,
                          child: Text("${controller.label}"),
                        ),
                      ],
                    ),
                  )
                      : Container(),
                ),
              ],
            );
          }
          else {
            return const Center(
              child: Text("Loading Preview..."),
            );
          }
        },
      ),
    );
  }

  void autoCapture(ScanController controller, double factorX, double factorY, double x, double y, double width, double height) async {
    print("chụp ảnh 1");
    if (isAutoCapturing || capturedImage != null) {
      return;
    }
    isAutoCapturing = true;
    print("chụp ảnh 2");
    try {
      capturedImage = await controller.cameraController.takePicture();
      print("Đường dẫn ảnh sau chụp: ${capturedImage?.path}");
      print("mimeType ảnh sau chụp: ${capturedImage?.mimeType}");
      print("name ảnh sau chụp: ${capturedImage?.name}");
      print("length ảnh sau chụp: ${capturedImage?.length}");
      print("lastModified ảnh sau chụp: ${capturedImage?.lastModified}");
      print("chụp ảnh 3");
      print("Thông số ảnh:$x, $y, $width, $height");
      print("chụp ảnh 4");
      capturedImage = await _cropImage(capturedImage, 50, 100, width, height);
      // _cropImage();
      print("chụp ảnh 5");
      setState(() async {
        capturedImage = capturedImage;
        XFile(capturedImage!.path);
        print("Đường dẫn ảnh sau cắt: ${capturedImage?.path}");
        print("mimeType ảnh sau cắt: ${capturedImage?.mimeType}");
        print("name ảnh sau cắt: ${capturedImage?.name}");
        print("length ảnh sau cắt: ${capturedImage?.length}");
        print("lastModified ảnh sau cắt: ${capturedImage?.lastModified}");
        isAutoCapturing = false;
      }
      );
    } catch (e) {
      print("Lỗi khi chụp và cắt hình ảnh: $e");
      isAutoCapturing = false;
    }
  }

  // Future<XFile?> _cropImage(XFile? image, double x, double y, double width, double height) async {
  //   if (image == null) {
  //     print('Invalid image file.');
  //     return null;
  //   }
  //
  //   final File imageFile = File(image.path);
  //   if (!imageFile.existsSync()) {
  //     print('Image file does not exist.');
  //     return null;
  //   }
  //
  //   img.Image? imgImage;
  //   try {
  //     imgImage = img.decodeImage(imageFile.readAsBytesSync());
  //   } catch (e) {
  //     print('Error decoding image: $e');
  //   }
  //
  //   if (imgImage == null) {
  //     print('Failed to decode image. Handle the error appropriately.');
  //     return null;
  //   }
  //
  //   final img.Image croppedImage = img.Image(width.toInt(), height.toInt());
  //
  //   // Vẽ phần cần crop từ ảnh gốc lên ảnh mới
  //   img.Image.copyInto(croppedImage, img.Image.from(image.width, image.height), dstX: 0, dstY: 0, srcX: x.toInt(), srcY: y.toInt(), srcW: width.toInt(), srcH: height.toInt());
  //
  //   print("Tọa độ: $x,$y,$width,$height ");
  //   // final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());
  //
  //   final directory = Directory.systemTemp;
  //   if (!await directory.exists()) {
  //     await directory.create(recursive: true);
  //   }
  //
  //   final File croppedFile = File('${image.path}');
  //   croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
  //   print('Cropped successfully.');
  //   print ('$croppedFile');
  //
  //   return XFile(croppedFile.path);
  // }
  Future<XFile?> _cropImage(XFile? image, double x, double y, double width, double height) async {
    if (image == null) {
      print('Invalid image file.');
      return null;
    }

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: width, ratioY: height),
      maxWidth: width.toInt() * 2,
      maxHeight: height.toInt() * 2,
      cropStyle: CropStyle.rectangle,
      compressQuality: 100,
    );

    print('Cropped successfully.');
    print('$croppedFile');

    return XFile(croppedFile!.path);
  }




}
