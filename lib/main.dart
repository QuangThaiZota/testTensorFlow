
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
import 'package:testtensorflow/views/camera_view.dart';
  
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: CameraView(),
      ),
    );
  }
        