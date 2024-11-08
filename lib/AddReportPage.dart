// import 'ImportAll.dart';
// import 'package:http/http.dart' as http;
//
// class AddReportScreen extends StatefulWidget {
//   const AddReportScreen({super.key});
//
//   @override
//   State<AddReportScreen> createState() => _AddReportScreenState();
// }
//
// class _AddReportScreenState extends State<AddReportScreen> {
//   File? selectedMedia;
//   final ImagePicker _picker = ImagePicker();
//   String extractedText = "";
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getLostData();
//   }
//
//   Future<void> getLostData() async {
//     final LostDataResponse response = await _picker.retrieveLostData();
//     if (response.isEmpty) {
//       return;
//     }
//     if (response.file != null) {
//       File? croppedFile = await _cropImage(File(response.file!.path));
//       if (croppedFile != null) {
//         setState(() {
//           selectedMedia = croppedFile;
//         });
//         final text = await _extractText(croppedFile);
//         setState(() {
//           extractedText = text ?? "";
//         });
//       }
//     } else {
//       CustomToast(response.exception?.message ?? "Unknown error occurred.",
//               Colors.redAccent, Colors.white, 16)
//           .showToast();
//     }
//   }
//
//   Future<File?> _cropImage(File imageFile) async {
//     try {
//       CroppedFile? croppedFile = await ImageCropper().cropImage(
//         sourcePath: imageFile.path,
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: Colors.deepOrange,
//             toolbarWidgetColor: Colors.white,
//             aspectRatioPresets: [
//               CropAspectRatioPreset.original,
//               CropAspectRatioPreset.square,
//               CropAspectRatioPresetCustom(),
//             ],
//           ),
//           IOSUiSettings(
//             title: 'Crop Image',
//             aspectRatioPresets: [
//               CropAspectRatioPreset.original,
//               CropAspectRatioPreset.square,
//               CropAspectRatioPresetCustom(),
//             ],
//           ),
//         ],
//       );
//       if (croppedFile != null) {
//         return File(croppedFile.path);
//       }
//       return null;
//     } on Exception catch (e) {
//       CustomToast("Image load failed. Try again or try image from gallery.",
//               Colors.blueGrey, Colors.white, 16)
//           .showToast();
//     }
//     return null;
//   }
//
//   Future<void> _getImage(ImageSource source) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile != null) {
//         print("Image selected successfully: ${pickedFile.path}");
//         File? croppedFile = await _cropImage(File(pickedFile.path));
//         if (croppedFile != null) {
//           setState(() {
//             selectedMedia = croppedFile;
//           });
//           print("Image cropped successfully: ${croppedFile.path}");
//           final text = await _extractText(croppedFile);
//           setState(() {
//             extractedText = text ?? "No text extracted";
//           });
//         }else{
//           print("Image cropping failed.");
//           CustomToast("Image cropping failed.", Colors.red, Colors.white, 16).showToast();
//         }
//       }else {
//         print("No image selected.");
//         CustomToast("No image selected.", Colors.red, Colors.white, 16).showToast();
//       }
//
//     } on Exception catch (e) {
//       CustomToast("Image load failed. Try again or try image from gallery.",
//               Colors.blueGrey, Colors.white, 16)
//           .showToast();
//     }
//   }
//
//   // Future<String?> _extractText(File imageFile) async {
//   //   try {
//   //     var url = Uri.parse('https://ocr-hzm6.onrender.com/extract-text');
//   //     String fullText = "";
//   //
//   //     var request = http.MultipartRequest('POST', url)
//   //       ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
//   //
//   //     var response = await request.send();
//   //
//   //     if (response.statusCode == 200) {
//   //       var responseData = await response.stream.bytesToString();
//   //       var json = jsonDecode(responseData);
//   //       fullText = json['full_text'];
//   //       print("Full Text: ${json['full_text']}");
//   //       print("Test Values: ${json['test_values']}");
//   //     } else {
//   //       fullText = response.statusCode.toString();
//   //       print("Error: ${response.statusCode}");
//   //     }
//   //     return fullText;
//   //   } on Exception catch (e) {
//   //     CustomToast(
//   //             "Text extraction failed. Try again or try image from gallery.",
//   //             Colors.blueGrey,
//   //             Colors.white,
//   //             16)
//   //         .showToast();
//   //   }
//   // }
//
//   Future<String?> _extractText(File imageFile) async {
//     try {
//       var url = Uri.parse('http://192.168.234.167:5000/extract_text');
//       String fullText = "";
//
//       var request = http.MultipartRequest('POST', url)
//         ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
//
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         var responseData = await response.stream.bytesToString();
//         var json = jsonDecode(responseData);
//         fullText = json['full_text'];
//         print("Full Text: ${json['full_text']}");
//         print("Test Values: ${json['test_values']}");
//       } else {
//         // Log the full response data for debugging
//         var responseData = await response.stream.bytesToString();
//         print("Error: ${response.statusCode}");
//         print("Response: $responseData");
//         fullText = "Error: ${response.statusCode}";
//       }
//       return fullText;
//     } catch (e) {
//       print("Error extracting text: $e");
//       CustomToast(
//           "Text extraction failed. Try again or try image from gallery.",
//           Colors.blueGrey,
//           Colors.white,
//           16)
//           .showToast();
//     }
//   }
//
//
//   Widget _extractTextView() {
//     if (selectedMedia == null) {
//       return Text("No image selected!");
//     }
//     return Column(
//       children: [
//         if (extractedText.isEmpty)
//           const CircularProgressIndicator()
//         else
//           Text(
//             extractedText,
//             style: const TextStyle(fontSize: 20),
//           ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: gradientMain,
//             // color: Color(0xFF6C5B7B),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//           height: MediaQuery.of(context).size.height / 2,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'Select image using',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     color: Colors.white),
//               ),
//               CustomButtonGestureDetector(
//                 'Camera',
//                 MediaQuery.of(context).size.width / 3,
//                 MediaQuery.of(context).size.width / 6,
//                 Colors.white,
//                 Colors.black,
//                 18,
//                 () {
//                   _getImage(ImageSource.camera);
//                   // Navigator.of(context).pop();
//                 },
//               ),
//               CustomButtonGestureDetector(
//                 'Gallery',
//                 MediaQuery.of(context).size.width / 3,
//                 MediaQuery.of(context).size.width / 6,
//                 Colors.white,
//                 Colors.black,
//                 18,
//                 () {
//                   _getImage(ImageSource.gallery);
//                   // Navigator.of(context).pop();
//                 },
//               ),
//               _extractTextView(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';

import 'ImportAll.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  File? selectedMedia;
  final ImagePicker _picker = ImagePicker();
  String extractedText = "Extracted text will appear here";

  // Function to pick an image
  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        // Crop image if needed
        File? croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          setState(() {
            selectedMedia = croppedFile;
          });
          await _extractText(croppedFile);
        }
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Function to crop the image
  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
      );
      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      print("Error cropping image: $e");
    }
    return null;
  }

  // Function to extract text from the image using the backend
  Future<void> _extractText(File imageFile) async {
    try {
      var url = Uri.parse('http://10.100.202.150:5000/extract_text');
      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody.body);
        setState(() {
          extractedText = responseData['extracted_text'] ?? "No text found";
        });
        await _saveRecognizedTextToFile(extractedText);
      } else {
        setState(() {
          extractedText = "Error extracting text. Status: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        extractedText = "Error: Failed to connect to the server";
      });
      print("Error extracting text: $e");
    }
  }

  // Function to save recognized text to a file
  Future<void> _saveRecognizedTextToFile(String text) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/recognized_text.txt';
      final file = File(filePath);

      await file.writeAsString(text);
      print('Text saved to file: $filePath');
    } catch (e) {
      print("Error saving text to file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (selectedMedia != null)
                Image.file(selectedMedia!, height: 200)
              else
                const Placeholder(fallbackHeight: 200, fallbackWidth: double.infinity),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _getImage(ImageSource.gallery),
                child: const Text('Select Image from Gallery'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _getImage(ImageSource.camera),
                child: const Text('Capture Image from Camera'),
              ),
              const SizedBox(height: 20),
              Text(extractedText, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
