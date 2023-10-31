import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:testtensorflow/views/view_picture.dart';
import '../controller/scan_controller.dart';
import 'button_Camera.dart';

class CameraView extends StatefulWidget {
  CameraView({super.key});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  XFile? capturedImage;
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
            // Khi điều kiện đủ để tự động chụp ảnh, gọi hàm autoCapture

              print("Dô rồi nè 2");
              autoCapture(controller, factorX, factorY);

            print("Dô rồi nè 3");
            return Stack(
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
                // Hiển thị ảnh đã chụp
                if (capturedImage != null)
                 SafeArea(
                child: Stack(
          children: [
          Image.file(
          File(capturedImage!.path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          ),
          GestureDetector(
          onTap: (){
          Navigator.pop(context);
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
          margin: EdgeInsets.only(
          left: 20,
          right: 40,
          bottom: 40,
          ),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
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
          child: Center(
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
          )

                // FutureBuilder<Uint8List>(
                //   future: croppedFile,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                //       return Image.memory(snapshot.data!, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
                //     } else {
                //       return CircularProgressIndicator(); // Hiển thị tiến trình nếu hình ảnh đang được crop
                //     }
                //   },
                // ),

          ],
            );
          } else {
            return const Center(
              child: Text("Loading Preview..."),
            );
          }
        },
      ),
    );
  }

  // Hàm tự động chụp ảnh
  void autoCapture(ScanController controller, double factorX, double factorY) async {
    print("chụp ảnh 1");
    if (isAutoCapturing || capturedImage != null) {
      return;
    }

    isAutoCapturing = true;

    print("chụp ảnh 2");
    try {
      final XFile captured = await controller.cameraController.takePicture();
      print("chụp ảnh 3");
      double x = controller.x1! * factorX;
      double y = controller.y1! * factorY;
      double width = (controller.x2! - controller.x1!) * factorX;
      double height = (controller.y2! - controller.y1!) * factorY;
      print("chụp ảnh 4");
      File croppedImage = await _cropImage(captured, x, y, width, height);
      print("chụp ảnh 5");
      setState(() {
        capturedImage = XFile(croppedImage.path);
        print("đường dẫn ảnh sau cắt: ${croppedImage.path}");
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
  Future<File> _cropImage(XFile image, double x, double y, double width, double height) async {
    final File imageFile = File(image.path);
    final img.Image imgImage = img.decodeImage(imageFile.readAsBytesSync())!;

    final img.Image croppedImage = img.copyCrop(imgImage, x.toInt(), y.toInt(), width.toInt(), height.toInt());

    final directory = await getTemporaryDirectory(); // Lấy thư mục tạm thời

    final File croppedFile = File('${directory.path}/cropped_image.jpeg'); // Lưu vào thư mục tạm thời
    croppedFile.writeAsBytesSync(img.encodeJpg(croppedImage));
    return croppedFile;
  }

}

