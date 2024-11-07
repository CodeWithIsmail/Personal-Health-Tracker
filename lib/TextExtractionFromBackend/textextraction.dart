import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class TextRecognitionPage extends StatefulWidget {
  const TextRecognitionPage({super.key});

  @override
  State<TextRecognitionPage> createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {

  File? image;
  String recognizedText = "Extracted text will appear here";
  final ImagePicker picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      // Call the text extraction function once the image is picked
      await textExtraction(image!);
    }
  }

  // Function to extract text using the backend server
  Future<void> textExtraction(File image) async {
    try {
      final uri = Uri.parse('http://192.168.234.167:5000/extract_text');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      print('Status Code: ${response.statusCode}');  // Print status code for debugging

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody.body);
        setState(() {
          recognizedText = responseData['extracted_text'];
        });
        // Save the recognized text to a file
        await saveRecognizedTextToFile(recognizedText);
      } else {
        setState(() {
          recognizedText = 'Failed to extract text';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        recognizedText = 'Connection error: Failed to reach the server';
      });
    }

    print(recognizedText);
  }

  // Function to save recognized text to a file
  Future<void> saveRecognizedTextToFile(String text) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/recognized_text.txt';
      final file = File(filePath);

      await file.writeAsString(text);
      print('Text saved to file: $filePath');
    } catch (e) {
      print('Error saving text to file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              image != null
                  ? Image.file(image!)
                  : Placeholder(
                fallbackHeight: 200,
                fallbackWidth: double.infinity,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 20),
              Text(
                recognizedText,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
