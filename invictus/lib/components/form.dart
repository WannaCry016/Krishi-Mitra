import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class CropInputForm extends StatefulWidget {
  @override
  _CropInputFormState createState() => _CropInputFormState();
}

class _CropInputFormState extends State<CropInputForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _soilTypeController = TextEditingController();
  final TextEditingController _farmSizeController = TextEditingController();
  final TextEditingController _cropTypeController = TextEditingController();
  final TextEditingController _lastCropController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  String? pdfFilePath;
  bool _isLoading = false;

  Future<void> submitData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        pdfFilePath = null;
      });
      Map<String, dynamic> requestData = {
        "location": _locationController.text,
        "soil_type": _soilTypeController.text,
        "farm_size": double.tryParse(_farmSizeController.text) ?? 0.0,
        "crop_type": _cropTypeController.text,
        "last_crop": _lastCropController.text,
        "budget": _budgetController.text
      };

      final response = await http.post(
        Uri.parse("http://192.168.137.1:8000/report/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "location": _locationController.text,
          "soil_type": _soilTypeController.text,
          "farm_size": double.tryParse(_farmSizeController.text) ?? 0.0,
          "crop_type": _cropTypeController.text,
          "last_crop": _lastCropController.text,
          "budget": _budgetController.text
        }),
      );

      if (response.statusCode == 200) {
        // Save PDF locally
        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/crop_plan.pdf';

        File pdfFile = File(filePath);
        await pdfFile.writeAsBytes(response.bodyBytes);

        // Open PDF
        // OpenFile.open(filePath);

        setState(() {
          pdfFilePath = filePath;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Crop Plan Generated Successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error generating crop plan")),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void openPDF() {
    if (pdfFilePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PDFViewerScreen(pdfFilePath!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No PDF available")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crop Plan Report")),
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/report.jpg"), // Change to your image path
          fit: BoxFit.cover, // Ensures the image covers the entire background
        ),
      ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                    controller: _locationController,
                    decoration: InputDecoration(labelText: "Location (State/District)", labelStyle: TextStyle(color: Colors.white, fontSize: 20)),
                    validator: (value) => value!.isEmpty ? "Enter location" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                    controller: _soilTypeController,
                    decoration:
                        InputDecoration(labelText: "Soil Type (Clay/Loam/Sandy)", labelStyle: TextStyle(color: Colors.white, fontSize: 20)),
                    validator: (value) => value!.isEmpty ? "Enter soil type" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                    controller: _farmSizeController,
                    decoration: InputDecoration(labelText: "Farm Size (acres)", labelStyle: TextStyle(color: Colors.white, fontSize: 20)),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? "Enter farm size" : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                    controller: _cropTypeController,
                    decoration: InputDecoration(
                        labelText: "Preferred Crop Type (optional)", labelStyle: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                    controller: _lastCropController,
                    decoration:
                        InputDecoration(labelText: "Previous Crop Cultivated", labelStyle: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                    controller: _budgetController,
                    decoration:
                        InputDecoration(labelText: "Estimated Budget (INR)", labelStyle: TextStyle(color: Colors.white, fontSize: 20)),
                    // keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? "Enter budget" : null,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: submitData,
                    child: _isLoading
                        ? Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: CircularProgressIndicator(color: Colors.green,),
                        )
                        : Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text("Generate Crop Plan", style: TextStyle(color: Colors.green),),
                        ),
                  ),
                ),
                pdfFilePath == null
                    ? Center(child: Container())
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 300,
                          width: 180,
                          child: PDFView(filePath: pdfFilePath!)),
                    ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: openPDF,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Open PDF"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  PDFViewerScreen(this.pdfPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer")),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}
