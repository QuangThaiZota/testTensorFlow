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
          print('factorX: $factorX');
          double imgRatio = controller.imgWidth / controller.imgHeight;
          double newWidth = controller.imgWidth * factorX;
          double newHeight = newWidth / imgRatio;
          double factorY = newHeight / (controller.imgHeight);
          print('factor Y: $factorY');

          // double factorX = screenWidth / (controller.imgHeight);
          // double factorY = screenHeight / (controller.imgWidth);

          double pady = (screenHeight - newHeight) / 2;
          double padx = (screenWidth - newWidth) / 2;
          print("CameraView screenWidth: ${screenWidth}");
          print("CameraView screenHeight: ${screenHeight}");
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
                    left: controller.x1 * factorX,
                    top: controller.y1 * factorY,
                    width: (controller.x2 - controller.x1) * factorX,
                    height: (controller.y2 - controller.y1) * factorY  + pady,
                    child: Container(
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
                  Column(
                    children: [
                      Container(
                        height: 100,
                      ),
                      Text("Size: ${screenWidth} / ${screenHeight}"),
                      Text("Left: ${controller.x1} / ${controller.x1 * factorX + padx}"),
                      Text("Top: ${controller.y1} / ${controller.y1 * factorY + pady}"),
                      Text("Width: ${(controller.x2 - controller.x1) * factorX * 2}"),
                      Text("Height: ${(controller.y2 - controller.y1) * factorY * 2}"),
                    ],
                  )
                ],
              )
              :const Center(child: Text("Loading Preview..."),);
        },
      ),
    );
  }
}
