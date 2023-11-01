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
          if (controller.isCameraInitialized.value && controller.x1 != null &&
              controller.x2 != null &&
              controller.y1 != null &&
              controller.y2 != null) {
              print("Dô rồi nè 2");
              autoCapture(controller, factorX, factorY);
            print("Dô rồi nè 3");
            return capturedImage!=null ?
              SafeArea(
                  child: Stack(
                      children: [
                        Image.file(
                          File(capturedImage!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        // Image.memory(Uint8List.fromList(croppedImage), fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                        GestureDetector(
                            onTap: (){
                              // Navigator.pop(context);
                            },
                            child: button(Icons.arrow_back_ios_new_outlined, Alignment.topLeft,
                                false,  Colors.transparent, Colors.white)),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                            });
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin:const  EdgeInsets.only(
                                left: 20,
                                right: 40,
                                bottom: 40,
                              ),
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(2,2),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.done,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                ):
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
      double width = (controller.x2! - controller.x1!) * factorX;
      double height = (controller.y2! - controller.y1!) * factorY;
      print("chụp ảnh 4");
      XFile? croppedImage = await _cropImage(_pickedFile, x , y, width+600, height+600);
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

  // Hàm cắt ảnh
  // Future<File> _cropImage(XFile image, double x, double y, double width, double height) async {
  //   // final File imageFile = File(image.path);
  //   // print("Cắt ảnh");
  //   // final img.Image imgImage = img.decodeImage(imageFile.readAsBytesSync())!;
  //   // final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());
  //   // final File croppedFile = File('/Bộ nhớ trong/DCIM/Camera/cropped_image.jpg');
  //   // croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
  //   //
  //   // return croppedFile;
  //
  //   final File imageFile = File(image.path);
  //   final img.Image imgImage = img.decodeImage(imageFile.readAsBytesSync())!;
  //
  //   final directory = await getTemporaryDirectory(); // Lấy thư mục tạm thời
  //
  //   final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());
  //
  //   final File croppedFile = File(image.path); // Lưu vào thư mục tạm thời
  //   croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
  //   print('Đường dẫn ảnh: ${croppedFile.path}');
  //   return croppedFile;
  // }

// Hàm cắt ảnh và trả về tệp đã cắt
//   Future<XFile?> _cropImage(XFile? image, double x, double y, double width, double height) async {
//     if (image == null) {
//       print('Invalid image file.');
//       return null;
//     }
//
//     final File imageFile = File(image.path);
//     if (!imageFile.existsSync()) {
//       print('Image file does not exist.');
//       return null;
//     }
//
//     img.Image? imgImage;
//     try {
//       final File imageFile = File(image.path);
//       imgImage = img.decodeImage(imageFile.readAsBytesSync());
//     } catch (e) {
//       print('Error decoding image: $e');
//     }
//
//     if (imgImage == null) {
//       // Xử lý lỗi ở đây, ví dụ: in ra thông báo lỗi hoặc thực hiện hành động thay thế.
//       print('Failed to decode image. Handle the error appropriately.');
//     }
//
//     // Tiếp tục xử lý ảnh cắt ở đây
//     final img.Image croppedImage = img.copyCrop(imgImage!, x.toInt(), y.toInt(), width.toInt(), height.toInt());
//
//     final directory = await getTemporaryDirectory();
//     if (!await directory.exists()) {
//       await directory.create(recursive: true);
//     }
//     final File croppedFile = File('${directory.path}/cropped_image.jpg');
//     croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
//     print('Cắt thành công.');
//     return XFile(croppedFile.path);
//   }

  // Future<XFile?> cropImage(XFile? image, double x, double y, double width, double height) async {
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
  //     final File imageFile = File(image.path);
  //     imgImage = img.decodeImage(imageFile.readAsBytesSync());
  //   } catch (e) {
  //     print('Error decoding image: $e');
  //   }
  //
  //   if (imgImage == null) {
  //     // Xử lý lỗi ở đây, ví dụ: in ra thông báo lỗi hoặc thực hiện hành động thay thế.
  //     print('Failed to decode image. Handle the error appropriately.');
  //     return null;
  //   }
  //
  //   // Tiếp tục xử lý ảnh cắt ở đây
  //   final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());
  //
  //   return XFile(croppedImage);
  // }


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
  //     final File imageFile = File(image.path);
  //     imgImage = img.decodeImage(imageFile.readAsBytesSync());
  //   } catch (e) {
  //     print('Error decoding image: $e');
  //   }
  //
  //   if (imgImage == null) {
  //     // Xử lý lỗi ở đây, ví dụ: in ra thông báo lỗi hoặc thực hiện hành động thay thế.
  //     print('Failed to decode image. Handle the error appropriately.');
  //     return null;
  //   }
  //
  //   // Tiếp tục xử lý ảnh cắt ở đây
  //   final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());
  //
  //   final directory = await getTemporaryDirectory();
  //   if (!await directory.exists()) {
  //     await directory.create(recursive: true);
  //   }
  //   final File croppedFile = File('${directory.path}/cropped_image.jpg');
  //   final List<int> jpgBytes = img.encodeJpg(croppedImage);
  //   await croppedFile.writeAsBytes(jpgBytes);
  //
  //   return XFile(croppedFile.path);
  // }

  // Future<void> _cropImage() async {
  //   if (_pickedFile != null) {
  //     final croppedFile = await ImageCropper().cropImage(
  //       sourcePath: _pickedFile!.path,
  //       compressFormat: ImageCompressFormat.jpg,
  //       compressQuality: 100,
  //       uiSettings: [
  //         AndroidUiSettings(
  //             toolbarTitle: 'Cropper',
  //             toolbarColor: Colors.deepOrange,
  //             toolbarWidgetColor: Colors.white,
  //             initAspectRatio: CropAspectRatioPreset.original,
  //             lockAspectRatio: false),
  //         IOSUiSettings(
  //           title: 'Cropper',
  //         ),
  //         WebUiSettings(
  //           context: context,
  //           presentStyle: CropperPresentStyle.dialog,
  //           boundary: const CroppieBoundary(
  //             width: 520,
  //             height: 520,
  //           ),
  //           viewPort:
  //           const CroppieViewPort(width: 480, height: 480, type: 'circle'),
  //           enableExif: true,
  //           enableZoom: true,
  //           showZoomer: true,
  //         ),
  //       ],
  //     );
  //     if (croppedFile != null) {
  //       setState(() {
  //         _croppedFile  = croppedFile;
  //       });
  //     }
  //   }
  // }

  // Future<XFile?> cropImage(XFile? image, double x, double y, double width, double height) async {
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
  //   try {
  //     final croppedImageFile = await ImageCropper.cropImage(
  //       sourcePath: image.path,
  //       aspectRatio: CropAspectRatio(ratioX: width, ratioY: height),
  //     );
  //
  //     if (croppedImageFile != null) {
  //       return XFile(croppedImageFile.path);
  //     }
  //   } catch (e) {
  //     print('Error cropping image: $e');
  //   }
  //
  //   print('Failed to crop image. Handle the error appropriately.');
  //   return null;
  // }

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
