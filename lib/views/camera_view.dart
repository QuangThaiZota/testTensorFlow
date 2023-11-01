import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../controller/scan_controller.dart';
import 'button_Camera.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';

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
          print("Dô rồi nè 1 ");
          if (controller.isCameraInitialized.value) {
              print("Dô rồi nè 2");
              if( controller.label == "CCCD")
              {
                autoCapture(controller, factorX, factorY);
              }
            print("Dô rồi nè 3");
            return capturedImage!=null ?
            SafeArea(
              child: Stack(
                children: [
                  FittedBox(
                    fit: BoxFit.contain, // Giữ tỷ lệ gốc của ảnh
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
                // Hiển thị khung chọn vùng
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

  void autoCapture(ScanController controller, double factorX, double factorY) async {
    print("chụp ảnh 1");
    if (isAutoCapturing || capturedImage != null) {
      return;
    }
    isAutoCapturing = true;
    print("chụp ảnh 2");
    try {
      _pickedFile = await controller.cameraController.takePicture();
      print("chụp ảnh 3");
      // double x = controller.x1! * factorX;
      // double y = controller.y1! * factorY;
      double x = (controller.x1 +controller.x2)/2;
      double y = (controller.y1 +controller.y2)/2;
      double width = (controller.x2! - controller.x1!) * factorX*100;
      double height = (controller.y2! - controller.y1!) * factorY*100;
      print("chụp ảnh 4");
      XFile? croppedImage = await _cropImage(_pickedFile, x , y, width, height);
      // _cropImage();
      print("chụp ảnh 5");
      setState(() {
        capturedImage = croppedImage;
            File(croppedImage!.path);
        print("Đường dẫn ảnh sau cắt: ${capturedImage}");
        isAutoCapturing = false;
      });
    } catch (e) {
      print("Lỗi khi chụp và cắt hình ảnh: $e");
      isAutoCapturing = false;
    }
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
      // Handle decoding error here, e.g., print an error message or take appropriate action.
      print('Failed to decode image. Handle the error appropriately.');
      return null;
    }

    // Continue with cropping the image here.
    final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());

    final directory = Directory.systemTemp;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final File croppedFile = File('${image.path}');
    croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
    print('Cropped successfully.');
    return XFile(croppedFile.path);
  }
}
