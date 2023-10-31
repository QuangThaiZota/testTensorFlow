import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'button_Camera.dart';

class ViewPicture extends StatefulWidget {
  static String routeName = "ViewPicture";
  var capturedImagePath;

  ViewPicture({Key? key, String? capturedImagePath}) : super(key: key);

  @override
  State<ViewPicture> createState() => _ViewPictureState();
}

class _ViewPictureState extends State<ViewPicture> {
  get capturedImagePath => null;

  @override
  Widget build(BuildContext context) {
    final String? capturedImagePath = ModalRoute.of(context)?.settings.arguments as String?;
    return SafeArea(
      child: Stack(
          children: [
            Image.file(
              File(capturedImagePath!),
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
    );
  }
}
