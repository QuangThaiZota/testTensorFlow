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
          print("Controller weight: ${controller.w}");
          print("Controller label: ${controller.label}");
          return controller.isCameraInitialized.value
              ? Stack(
                children: [
                  CameraPreview(controller.cameraController),
                  Positioned(
                    top: (controller.y)*(screenHeight),
                    left: (controller.x)*(screenWidth),
                    child: Container(
                      width:  (controller.w)*context.width,
                      height: (controller.h)*context.height,
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
