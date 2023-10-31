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
    double screenHeight = MediaQuery.of(context).size.height - 150;
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          // double factorX = screenWidth / (controller.imgWidth);
          // print('factorX: $factorX');
          // double imgRatio = controller.imgWidth / controller.imgHeight;
          // double newWidth = controller.imgWidth * factorX;
          // double newHeight = newWidth / imgRatio;
          // double factorY = newHeight / (controller.imgHeight);
          // print('factor Y: $factorY');

          // double factorX = screenWidth / (controller.imgHeight);
          // double factorY = screenHeight / (controller.imgWidth);

          double factorX = screenWidth / (controller.imgHeight ?? 1);
          double factorY = screenHeight / (controller.imgWidth ?? 1);
          print('factor Y: $factorY');

          // double pady = (screenHeight - newHeight) / 2;
          // double padx = (screenWidth - newWidth) / 2;
          // print("CameraView screenWidth: ${screenWidth}");
          // print("CameraView screenHeight: ${screenHeight}");
          // print("CameraView x1: ${controller.x1}");
          // print("CameraView x2: ${controller.x2}");
          // print("CameraView y1: ${controller.y1}");
          // print("CameraView y2: ${controller.y2}");
          // print("CameraView label: ${controller.label}");
          // print("CameraView imgHeight: ${controller.imgHeight}");
          // print("CameraView imgWidth: ${controller.imgWidth}");
          return controller.isCameraInitialized.value
              ? Stack(
                children: [
                  CameraPreview(controller.cameraController),
                  // Positioned(
                  //   left:  (controller.x1 ??1) * factorX,
                  //   top: (controller.y1??1) * factorY,
                  //   child: Container(
                  //     width: (controller.x2??1 - controller.x1??1) * factorX,
                  //     height: (controller.y2??1 - controller.y1??1)* factorY,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       border: Border.all(color: Colors.green,width: 4),
                  //     ),
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Container(
                  //             color: Colors.white,
                  //             child: Text("${controller.label}"),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Positioned(
                    left: controller.x1 != null ? controller.x1 * factorX : null,
                    top: controller.y1 != null ? controller.y1 * factorY : null,
                    child: controller.x1 != null && controller.x2 != null && controller.y1 != null && controller.y2 != null
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
                        : Container(), // Sử dụng Container rỗng khi giá trị là null
                  ),


                  Column(
                    children: [
                      Container(
                        height: 100,
                      ),
                      Text("Size: ${screenWidth} / ${screenHeight}"),
                      Text("Left: ${controller.x1} / ${controller.x1 * factorX }"),
                      Text("Top: ${controller.y1} / ${controller.y1 * factorY }"),
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
