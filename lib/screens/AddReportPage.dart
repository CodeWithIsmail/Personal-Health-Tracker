// import 'package:http/http.dart' as http;
// import '../ImportAll.dart';
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
//   String extractedText = "Extracted text will appear here";
//   String parsedData = "Parsed data will appear here";
//   FirestoreService firestoreService = new FirestoreService();
//   String imageURL = "";
//
//   // bool isLoading = false;
//
//   void initState() {
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
//         // await _uploadImage(croppedFile);
//         // await _processImage(croppedFile);
//       }
//     } else {
//       CustomToast(response.exception?.message ?? "Unknown error occurred.",
//               Colors.redAccent, Colors.white, 16)
//           .showToast();
//     }
//   }
//
//   Future<void> _getImage(ImageSource source) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile != null) {
//         File? croppedFile = await _cropImage(File(pickedFile.path));
//         if (croppedFile != null) {
//           setState(() {
//             // isLoading = true;
//             selectedMedia = croppedFile;
//           });
//           await _uploadImage(croppedFile);
//
//           // await _processImage(croppedFile);
//           String values =
//               await sendImagePromptToGemini(ocrPrompt, croppedFile, null);
//           print(values);
//           _processImage(values);
//           await _gotoAnalysisScreen(croppedFile);
//         }
//       } else {
//         print("No image selected.");
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }
//
//   Future<void> _uploadImage(File imageFile) async {
//     final url =
//         Uri.parse("https://api.cloudinary.com/v1_1/ismailCloud/image/upload");
//     final request = http.MultipartRequest('POST', url)
//       ..fields['upload_preset'] = 'healthTracker'
//       ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
//     final response = await request.send();
//     if (response.statusCode == 200) {
//       final responseData = await response.stream.toBytes();
//       final responseString = String.fromCharCodes(responseData);
//       final jsonMap = jsonDecode(responseString);
//
//       print(jsonMap);
//       print(jsonMap['url']);
//       String imgUrl = jsonMap['url'];
//       setState(() {
//         imageURL = imgUrl;
//       });
//       //  firestoreService.storeImgLink("123", "234", imgUrl);
//     }
//   }
//
//   Future<File?> _cropImage(File imageFile) async {
//     try {
//       CroppedFile? croppedFile = await ImageCropper().cropImage(
//         sourcePath: imageFile.path,
//       );
//       return croppedFile != null ? File(croppedFile.path) : null;
//     } catch (e) {
//       print("Error cropping image: $e");
//     }
//     return null;
//   }
//
//   Future<void> _gotoAnalysisScreen(File imageFile) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ReportAnalysis(imageFile, imageURL),
//       ),
//     );
//   }
//
//   void _processImage(String response) {
//     // Parse the response string into a map
//     Map<String, String> cbcMap = {};
//
//     List<String> lines = response.split('\n');
//     for (String line in lines) {
//       // Skip empty lines
//       if (line.trim().isEmpty) continue;
//
//       // Split by colon and store the key-value pairs in the map
//       List<String> parts = line.split(':');
//       if (parts.length == 2) {
//         String key = parts[0].trim();
//         String value = parts[1].trim();
//
//         // Normalize the key to match the CBC class
//         key = key
//             .replaceAll('/', '_')
//             .replaceAll('-', '_')
//             .replaceAll(' ', '_'); // Handle keys like "HCT/PCV" to "HCT_PCV"
//
//         cbcMap[key] = value;
//       }
//     }
//
//     // Create CBC object from the parsed map
//     CBC cbc = CBC.fromMap(cbcMap);
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CBCinputScreen(cbc),
//       ),
//     );
//
//     // Print the CBC object
//     print(cbc);
//   }
//
//   // Future<void> _processImage(File imageFile) async {
//   //   setState(() {
//   //     // isLoading = true;
//   //   });
//   //   try {
//   //     var url = Uri.parse('http://192.168.2.193:5000/process_image');
//   //     var request = http.MultipartRequest('POST', url)
//   //       ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
//   //
//   //     var response = await request.send();
//   //     var responseBody = await http.Response.fromStream(response);
//   //
//   //     if (response.statusCode == 200) {
//   //       final responseData = json.decode(responseBody.body);
//   //       String extractedText =
//   //           responseData['extracted_text'] ?? "No text found";
//   //       Map<String, dynamic> structuredData =
//   //           responseData['structured_data'] ?? {};
//   //
//   //       CBC cbcReport = CBC.fromMap(structuredData);
//   //       print("cbc class print: " + cbcReport.toString());
//   //       setState(() {
//   //         // isLoading = false;
//   //         this.extractedText = extractedText;
//   //         this.parsedData = structuredData.entries
//   //             .map((e) => "${e.key}: ${e.value}")
//   //             .join("\n");
//   //       });
//   //       Navigator.push(
//   //         context,
//   //         MaterialPageRoute(
//   //           builder: (context) => CBCinputScreen(cbcReport),
//   //         ),
//   //       );
//   //
//   //       //  print("Extracted text: " + extractedText);
//   //       //  print("Structured data: $structuredData");
//   //     } else {
//   //       setState(() {
//   //         extractedText =
//   //             "Error extracting text. Status: ${response.statusCode}";
//   //         parsedData = "Error fetching structured data.";
//   //       });
//   //     }
//   //   } catch (e) {
//   //     print("Error processing image: $e");
//   //     setState(() {
//   //       extractedText = "Error: Failed to connect to the server";
//   //       parsedData = "Error: Failed to connect to the server";
//   //     });
//   //   } finally {
//   //     setState(() {
//   //       // isLoading = false;
//   //     });
//   //   }
//   // }
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
//                 'Give report data using',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                     color: Colors.white),
//               ),
//               // if (isLoading)
//               //   CircularProgressIndicator(
//               //     color: Colors.white,
//               //   ),
//               CustomButtonGestureDetector(
//                 'Camera',
//                 MediaQuery.of(context).size.width / 3,
//                 MediaQuery.of(context).size.width / 6,
//                 Colors.white,
//                 Colors.black,
//                 18,
//                 () {
//                   _getImage(ImageSource.camera);
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
//                 },
//               ),
//               CustomButtonGestureDetector(
//                 'Manual Input',
//                 MediaQuery.of(context).size.width / 3,
//                 MediaQuery.of(context).size.width / 6,
//                 Colors.white,
//                 Colors.black,
//                 18,
//                 () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CBCinputScreen(new CBC(
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "",
//                           "")),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// depreciated