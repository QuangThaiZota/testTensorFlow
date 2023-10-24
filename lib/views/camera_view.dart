import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:testtensorflow/controller/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;



    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          double factorX = screenWidth / (controller.imgWidth);
          double imgRatio = screenWidth / controller.imgHeight;
          double newWidth = screenWidth * factorX;
          double newHeight = newWidth / imgRatio;
          double factorY = newHeight / (screenHeight);

          double pady = (screenHeight - newHeight) / 2;
          print("CameraView x1: ${controller.x1}");
          print("CameraView x2: ${controller.x2}");
          print("CameraView y1: ${controller.y1}");
          print("CameraView y2: ${controller.y2}");
          print("CameraView label: ${controller.label}");
          print("CameraView imgHeight: ${controller.imgHeight}");
          print("CameraView imgWidth: ${controller.imgWidth}");
          return controller.isCameraInitialized.value
              ? Stack(
                children: [
                  CameraPreview(controller.cameraController),
                  Positioned(
                    // top: (controller.y)*(screenHeight),
                    // left: (controller.x)*(screenWidth),
                    left: controller.x1 * factorX,
                    top: controller.y1 * factorY+ pady,
                    width: (controller.x2 - controller.x1) * factorX,
                    height: (controller.y2 - controller.y1) * factorY,
                    // left: 100,
                    // top: 100,
                    // width: 100,
                    // height: 100,
                    child: Container(
                      // width:  (controller.w)*context.width,
                      // height: (controller.h)*context.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green,width: 4),
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
                    ),
                  ),
                ],
              )
              :const Center(child: Text("Loading Preview..."),);
        },
      ),
    );
  }
}
