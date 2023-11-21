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

          double x = (controller.x1f)*1.0;
          double y = (controller.y1f)*1.0;
          double width = (controller.x2f - controller.x1f)*1.0;
          double height = (controller.y2f - controller.y1f)*1.0;

          double imgRatio = screenWidth / screenHeight;
          double newWidth = screenWidth * factorX;
          double newHeight = newWidth / imgRatio;


          double pady = (screenHeight - newHeight) / 2;
          print("Dô rồi nè 1 ");
          if (controller.isCameraInitialized.value) {
            print("Dô rồi nè 2: ${controller.label}");

            if(count > 15){
              print('Chụp chỗ này $count');
              // double scale_x = 1;
              //     // 2160 / 1280;
              // double scale_y = 1;
              // // 3840 / 720 ;
              // x= x*scale_x;
              // y=y*scale_y;
              // width=width*scale_x;
              // height= height*scale_y;

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
              child: Stack(
                children: [
              // Positioned(
              // left: (controller.x1f) * factorX,
              //   top: (controller.y1f) * factorY + pady,
              //   width: ((controller.x2f) - (controller.x1f)) * factorX,
              //   height: ((controller.y2f) - (controller.y1f)) * factorY,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              //       border: Border.all(color: Colors.pink, width: 2.0),
              //     ),
              //     child: Text(
              //       'hii'
              //     ),
              //   ),
              // ),
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
      Size imageSize = await getImageDimensions(capturedImage!.path);
      // Print the image dimensions
      print("Image dimensions: ${imageSize.width} x ${imageSize.height}");
      print("Đường dẫn ảnh sau chụp: ${capturedImage?.path}");
      print("mimeType ảnh sau chụp: ${capturedImage?.mimeType}");
      print("name ảnh sau chụp: ${capturedImage?.name}");
      print("length ảnh sau chụp: ${capturedImage?.length}");
      print("lastModified ảnh sau chụp: ${capturedImage?.lastModified}");
      print("chụp ảnh 3");
      print("Thông số ảnh:$x, $y, $width, $height");
      print("chụp ảnh 4");
      capturedImage = await _cropImage(capturedImage, x, y, width, height);
      // _cropImage();
      print("chụp ảnh 5");
      setState(() async {
        // capturedImage = capturedImage;
        // XFile(capturedImage!.path);
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

  Future<Size> getImageDimensions(String imagePath) async {
    File imageFile = File(imagePath);
    final FileImage image = FileImage(imageFile);
    final Completer<Size> completer = Completer<Size>();
    final ImageStream stream = image.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
      final int width = imageInfo.image.width;
      final int height = imageInfo.image.height;
      final Size dimensions = Size(width.toDouble(), height.toDouble());
      completer.complete(dimensions);
    }));
    return completer.future;
  }

  Future<XFile?> _cropImage(XFile? image, double x, double y, double width, double height) async {
    if (image == null) {
      print('Invalid image file.');
      return null;
    }

    final File imageFile = File(image.path);
    if (!imageFile.existsSync()) {
      print('Image file does not exist.');
      return null;
    }

    img.Image? imgImage;
    try {
      imgImage = img.decodeImage(imageFile.readAsBytesSync());
    } catch (e) {
      print('Error decoding image: $e');
    }

    if (imgImage == null) {
      print('Failed to decode image. Handle the error appropriately.');
      return null;
    }

    // final img.Image croppedImage = img.Image(width.toInt(), height.toInt());

    // Vẽ phần cần crop từ ảnh gốc lên ảnh mới
    // img.Image.copyInto(croppedImage, img.Image.from(image.width, image.height), dstX: 0, dstY: 0, srcX: x.toInt(), srcY: y.toInt(), srcW: width.toInt(), srcH: height.toInt());

    print("Tọa độ: $x,$y,$width,$height");
    img.Image croppedImage = img.copyCrop(imgImage, x: x.toInt(), y: y.toInt(), width: width.toInt(),height: height.toInt());

    final directory = Directory.systemTemp;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    File croppedFile = File('${imageFile}');
    croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
    print('Cropped successfully.');
    print ('$croppedFile');

    return XFile(croppedFile.path);
  }

}