// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:camera/camera.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // class Scan extends StatefulWidget {
// //   const Scan({super.key});

// //   @override
// //   _ScanState createState() => _ScanState();
// // }

// // class _ScanState extends State<Scan> {
// //   CameraController? _cameraController;
// //   List<CameraDescription>? cameras;
// //   XFile? _image;
// //   String? _prediction;
// //   bool _loading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeCamera();
// //   }

// //   Future<void> _initializeCamera() async {
// //     cameras = await availableCameras();
// //     if (cameras!.isNotEmpty) {
// //       _cameraController = CameraController(cameras![0], ResolutionPreset.medium);
// //       await _cameraController!.initialize();
// //       setState(() {});
// //     }
// //   }

// //   Future<void> _captureImage() async {
// //     if (_cameraController == null || !_cameraController!.value.isInitialized) {
// //       return;
// //     }
// //     final XFile image = await _cameraController!.takePicture();
// //     setState(() {
// //       _image = image;
// //       _prediction = null;
// //     });
// //   }

// //   Future<void> _uploadImage() async {
// //     if (_image == null) return;

// //     setState(() {
// //       _loading = true;
// //     });

// //     var request = http.MultipartRequest(
// //       'POST',
// //       Uri.parse('http://192.168.137.1:8000/image'), // Change to your FastAPI backend URL
// //     );
// //     request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

// //     var response = await request.send();
// //     var responseBody = await response.stream.bytesToString();
// //     var jsonData = json.decode(responseBody);

// //     setState(() {
// //       _prediction = jsonData['prediction'].toString();
// //       _loading = false;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Color(0xFF1E1F25),
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           _cameraController != null && _cameraController!.value.isInitialized
// //               ? AspectRatio(
// //                   aspectRatio: _cameraController!.value.aspectRatio,
// //                   child: CameraPreview(_cameraController!),
// //                 )
// //               : Text("Initializing Camera...", style: TextStyle(color: Colors.white)),

// //           SizedBox(height: 20),

// //           ElevatedButton(
// //             onPressed: _captureImage,
// //             child: Text("Capture Image"),
// //           ),

// //           SizedBox(height: 10),

// //           ElevatedButton(
// //             onPressed: _uploadImage,
// //             child: _loading ? CircularProgressIndicator() : Text("Upload & Predict"),
// //           ),

// //           SizedBox(height: 20),

// //           _prediction != null
// //               ? Text("Prediction: $_prediction",
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
// //               : Container(),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Scan extends StatefulWidget {
//   const Scan({super.key});

//   @override
//   _ScanState createState() => _ScanState();
// }

// class _ScanState extends State<Scan> {
//   File? _image;
//   String? _prediction;
//   bool _loading = false;

//   final ImagePicker _picker = ImagePicker();

//   // Function to pick image from gallery
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _prediction = null; // Reset previous prediction
//       });
//     }
//   }

//   // Function to upload image and get prediction
//   Future<void> _uploadImage() async {
//     if (_image == null) return;

//     setState(() {
//       _loading = true;
//     });

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('http://192.168.137.1:8000/image'), // Change to your FastAPI backend URL
//     );
//     request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

//     var response = await request.send();
//     var responseBody = await response.stream.bytesToString();
//     var jsonData = json.decode(responseBody);

//     setState(() {
//       _prediction = jsonData['prediction'].toString();
//       _loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1E1F25),
//       // appBar: AppBar(title: Text('Plant Disease Detection')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image == null
//                 ? Text(
//                   "No image selected",
//                   style: TextStyle(
//                     color: Colors.white
//                   ),
//                   )
//                 : Image.file(_image!, height: 300),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _pickImage,
//               child: Text("Pick Image"),
//             ),

//             SizedBox(height: 10),

//             ElevatedButton(
//               onPressed: _uploadImage,
//               child: _loading ? CircularProgressIndicator() : Text("Upload & Predict"),
//             ),

//             SizedBox(height: 20),

//             _prediction != null
//                 ? Text("Prediction: $_prediction",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  File? _image;
  String? _prediction;
  String? _cure;
  String? _recproducts;
  String? _symp;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = null; // Reset previous prediction
      });
    }
  }

  // Function to capture image from camera
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = null; // Reset previous prediction
      });
    }
  }

  // Function to upload image and get prediction
  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image first!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://192.168.137.1:8000/image/'), // Change to your FastAPI backend URL
    );
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var jsonData = json.decode(responseBody);

    print("jsonData $jsonData");

    setState(() {
  _prediction = jsonData['prediction'].toString();
  _cure = json.decode(jsonData['info'])["cure"].toString();
  // _symp = jsonData['info']["symptoms"].toString();
  _recproducts = json.decode(jsonData['info'])["recommended_products"].toString(); // ✅ Fix applied
  _loading = false;
});

  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Scaffold(
      // backgroundColor: Color(0xFF1E1F25),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Disease Detection"),
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        surfaceTintColor: Colors.white,
      ),
      body: Center(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _image == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: queryData.size.height * 0.254,
                      width: 160,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Center(
                        child: Text(
                          "No image selected",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(_image!, height: queryData.size.height * 0.254),
                  ),
            SizedBox(height: 20),
            _prediction != null
                ? Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, right: 8.0, left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // RichText(
                        //   text: TextSpan(
                        //     style: const TextStyle(color: Colors.black),
                        //     children: [
                        //       TextSpan(
                        //         text: "Prediction: ",
                        //         style: const TextStyle(
                        //             color: Colors.red,
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.bold,
                        //             fontFamily: "Poppins-Regular"),
                        //       ),
                        //       const TextSpan(text: ' '),
                        //       TextSpan(
                        //           text: "${_prediction?.replaceAll('_', ' ')}",
                        //           style: TextStyle(
                        //               fontFamily: "Poppins-Regular",
                        //               fontSize: 16)),
                        //     ],
                        //   ),
                        // ),

                        Table(
                          border: TableBorder.all(),
                          columnWidths: const {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(3),
                          },
                          children: [
                            TableRow(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Category",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Plant/Fruit",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
  padding: EdgeInsets.all(8.0),
  child: Text(
    (_prediction?.replaceAll('___', ' ') ?? '').split(' ').first,
    style: TextStyle(fontSize: 16),
  ),
),

                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Disease",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                               Padding(
  padding: EdgeInsets.all(8.0),
  child: Text(
    (_prediction?.replaceAll('___', ' ') ?? '').split(' ').length > 1 
      ? (_prediction?.replaceAll('___', ' ') ?? '').split(' ')[1].replaceAll('_', ' ') 
      : '', 
    style: TextStyle(fontSize: 16),
  ),
),


                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Cure",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    _cure?.replaceAll('_', ' ') ?? '',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Symptoms",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    _symp?.replaceAll('_', ' ') ?? '',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),

                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Recommended Products",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    _recproducts ?? '',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // RichText(
                        //   textAlign: TextAlign.center,
                        //   text: TextSpan(
                        //     style: const TextStyle(color: Colors.black),
                        //     children: [
                        //       TextSpan(
                        //         text: "Cure: ",
                        //         style: const TextStyle(
                        //             color: Colors.green,
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.bold,
                        //             fontFamily: "Poppins-Regular"),
                        //       ),
                        //       TextSpan(
                        //           text: "${_cure?.replaceAll('_', ' ')}",
                        //           style: TextStyle(
                        //               fontFamily: "Poppins-Regular",
                        //               fontSize: 16)),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  )
                // ? Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Text(
                //           "Prediction: ${_prediction?.replaceAll('_', ' ')}",
                //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                //         ),
                //         Text(
                //           "${_cure?.replaceAll('_', ' ')}",
                //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                //   textAlign: TextAlign.center,
                //         )
                //     ],
                //   ),
                // )
                : Container(
                    child: Center(
                      child:
                          Text("Upload an image to predict the disease in it."),
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: ElevatedButton(
                onPressed: _pickImage,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                          color: Colors.green,
                          width: 2), // Border color and width
                    ),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all<Color?>(Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Pick Image from Gallery",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: ElevatedButton(
                onPressed: _captureImage,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Capture Image with Camera",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                          color: Colors.green,
                          width: 2), // Border color and width
                    ),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all<Color?>(Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: ElevatedButton(
                onPressed: _uploadImage,
                child: _loading
                    ? Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "Upload & Predict",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color?>(Colors.green),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Scan extends StatefulWidget {
//   const Scan({super.key});

//   @override
//   _ScanState createState() => _ScanState();
// }

// class _ScanState extends State<Scan> {
//   CameraController? _controller;
//   XFile? _image;
//   String? _prediction;
//   String? _cure;
//   bool _loading = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final camera = cameras.first;
//     _controller = CameraController(camera, ResolutionPreset.medium);
//     await _controller!.initialize();
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future<void> _captureImage() async {
//     if (_controller == null || !_controller!.value.isInitialized) {
//       return;
//     }
//     final image = await _controller!.takePicture();
//     setState(() {
//       _image = image;
//       _prediction = null;
//     });
//   }

//   Future<void> _uploadImage() async {
//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please capture an image first!')),
//       );
//       return;
//     }

//     setState(() {
//       _loading = true;
//     });

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('http://192.168.137.1:8000/image/'), // Change to your backend URL
//     );
//     request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

//     var response = await request.send();
//     var responseBody = await response.stream.bytesToString();
//     var jsonData = json.decode(responseBody);

//     setState(() {
//       _prediction = jsonData['prediction'].toString();
//       _cure = jsonData['cure'].toString();
//       _loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           _controller == null || !_controller!.value.isInitialized
//               ? Center(child: CircularProgressIndicator())
//               : Expanded(
//                   child: CameraPreview(_controller!),
//                 ),
//           _image != null
//               ? Image.file(File(_image!.path), height: 200)
//               : SizedBox(height: 10),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: _captureImage,
//             child: Text("Capture Image"),
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: _uploadImage,
//             child: _loading ? CircularProgressIndicator() : Text("Upload & Predict"),
//           ),
//           if (_prediction != null)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Text("Prediction: $_prediction", style: TextStyle(color: Colors.red, fontSize: 18)),
//                   Text("Cure: $_cure", style: TextStyle(color: Colors.green, fontSize: 18)),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
// }

class BottomHemispherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // Draw a semicircle at the bottom
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height),
        width: size.width,
        height: size.height * 2,
      ),
      0,
      3.14,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}





// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:camera/camera.dart';

// class Scan extends StatefulWidget {
//   const Scan({super.key});

//   @override
//   _ScanState createState() => _ScanState();
// }

// class _ScanState extends State<Scan> {
//   File? _image;
//   String? _prediction;
//   bool _loading = false;
//   late List<CameraDescription> _cameras;
//   CameraController? _cameraController;
//   bool _isCameraInitialized = false;

//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }

//   // Initialize camera
//   Future<void> _initCamera() async {
//     _cameras = await availableCameras();
//     if (_cameras.isNotEmpty) {
//       _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
//       await _cameraController!.initialize();
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     }
//   }

//   // Pick image from gallery
//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _prediction = null; // Reset previous prediction
//       });
//     }
//   }

//   // Capture image using in-app camera
//   Future<void> _captureImage() async {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    
//     try {
//       final XFile file = await _cameraController!.takePicture();
//       setState(() {
//         _image = File(file.path);
//         _prediction = null; // Reset previous prediction
//       });
//     } catch (e) {
//       print("Error capturing image: $e");
//     }
//   }

//   // Upload image and get prediction
//   Future<void> _uploadImage() async {
//     if (_image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select an image first!')),
//       );
//       return;
//     }

//     setState(() {
//       _loading = true;
//     });

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('http://192.168.137.1:8000/image/'),
//     );
//     request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

//     var response = await request.send();
//     var responseBody = await response.stream.bytesToString();
//     var jsonData = json.decode(responseBody);

//     setState(() {
//       _prediction = jsonData['prediction'].toString();
//       _loading = false;
//     });
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image == null
//                 ? Container(
//                     height: 250,
//                     width: 160,
//                     decoration: BoxDecoration(border: Border.all()),
//                     child: Center(
//                       child: Text(
//                         "No image selected",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   )
//                 : Image.file(_image!, height: 300),

//             SizedBox(height: 20),

//             _prediction != null
//                 ? Text(
//                     "Prediction: ${_prediction?.replaceAll('_', ' ')}",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
//                   )
//                 : Text("Upload an image to predict the disease in it."),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _pickImage,
//               child: Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: Text("Pick Image from Gallery", style: TextStyle(color: Colors.white)),
//               ),
//               style: ButtonStyle(
//                 backgroundColor: WidgetStateProperty.all<Color?>(Colors.green),
//               ),
//             ),

//             SizedBox(height: 10),

//             ElevatedButton(
//               onPressed: _captureImage,
//               child: Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: Text("Capture Image with Camera", style: TextStyle(color: Colors.white)),
//               ),
//               style: ButtonStyle(
//                 backgroundColor: WidgetStateProperty.all<Color?>(Colors.green),
//               ),
//             ),

//             SizedBox(height: 10),

//             ElevatedButton(
//               onPressed: _uploadImage,
//               child: _loading
//                   ? Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: CircularProgressIndicator(),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: Text("Upload & Predict", style: TextStyle(color: Colors.white)),
//                     ),
//               style: ButtonStyle(
//                 backgroundColor: WidgetStateProperty.all<Color?>(Colors.green),
//               ),
//             ),

//             SizedBox(height: 20),

//             _isCameraInitialized
//                 ? Container(
//                     height: 200,
//                     width: 300,
//                     child: CameraPreview(_cameraController!),
//                   )
//                 : Container(
//                     height: 200,
//                     width: 300,
//                     color: Colors.black12,
//                     child: Center(child: Text("Camera initializing...")),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
