import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_ocr/CardScanner.dart';
import 'package:flutter_ocr/RecognizerScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';

import 'EnhanceScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImagePicker imagePicker;
  late List<CameraDescription> _cameras;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    initalizeCamera();
  }

  late CameraController controller;
  bool isInit = false;
  initalizeCamera() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isInit = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  bool scan = false;
  bool recognize = true;
  bool enhance = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 50, bottom: 15, left: 5, right: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            color: Colors.blueAccent,
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.scanner,
                          size: 25,
                          color: scan ? Colors.black : Colors.white,
                        ),
                        Text(
                          'Scan',
                          style: TextStyle(
                            color: scan ? Colors.black : Colors.white,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        scan = true;
                        recognize = false;
                        enhance = false;
                      });
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.document_scanner,
                          size: 25,
                          color: recognize ? Colors.black : Colors.white,
                        ),
                        Text(
                          'Recognize',
                          style: TextStyle(
                            color: recognize ? Colors.black : Colors.white,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        scan = false;
                        recognize = true;
                        enhance = false;
                      });
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_sharp,
                          size: 25,
                          color: enhance ? Colors.black : Colors.white,
                        ),
                        Text(
                          'Enhance',
                          style: TextStyle(
                            color: enhance ? Colors.black : Colors.white,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        scan = false;
                        recognize = false;
                        enhance = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.black,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 300,
                    child: isInit
                        ? AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: CameraPreview(controller),
                          )
                        : Container(),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 300,
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "images/f1.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(20),
                ).animate(onPlay: (controller) => controller.repeat()).
                moveY(begin: 0,
                    end: MediaQuery.of(context).size.height - 320,duration: 2000.ms)
              ],
            ),
          ),
          Card(
            color: Colors.blueAccent,
            child: SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: const Icon(
                      Icons.rotate_left,
                      size: 35,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.camera,
                      size: 50,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      await controller.takePicture().then((value) {
                        File image = File(value.path);
                        processImage(image);
                                            });
                    },
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.image_outlined,
                      size: 35,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      XFile? xfile = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (xfile != null) {
                        File image = File(xfile.path);
                        processImage(image);
                      }
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  processImage(File image) async {
    final editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageCropper(
          image: image.readAsBytesSync(), // <-- Uint8List of image
        ),
      ),
    );
    image.writeAsBytes(editedImage);
    if (recognize) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return RecognizerScreen(image);
      }));
    } else if (scan) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return CardScanner(image);
      }));
    }
    else if (enhance) {
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return EnhanceScreen(image);
      }));
    }
  }
}
