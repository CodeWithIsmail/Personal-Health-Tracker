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

import 'package:http/http.dart' as http;
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
  String parsedData = "Parsed data will appear here";

  FirestoreService firestoreService = new FirestoreService();

  void initState() {
    super.initState();
    getLostData();
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      File? croppedFile = await _cropImage(File(response.file!.path));
      if (croppedFile != null) {
        setState(() {
          selectedMedia = croppedFile;
        });
        await _processImage(croppedFile);
      }
    } else {
      CustomToast(response.exception?.message ?? "Unknown error occurred.",
              Colors.redAccent, Colors.white, 16)
          .showToast();
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        File? croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          setState(() {
            selectedMedia = croppedFile;
          });
      await   _uploadImage(croppedFile);
       await _processImage(croppedFile);
        }
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/ismailCloud/image/upload");
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'healthTracker'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      print(jsonMap);
      print(jsonMap['url']);
      String imgUrl = jsonMap['url'];
      firestoreService.storeImgLink("123", "234", imgUrl);
    }
  }

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

  Future<void> _processImage(File imageFile) async {
    try {
      var url = Uri.parse('http://192.168.104.207:5000/process_image');
      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody.body);
        String extractedText = responseData['extracted_text'] ?? "No text found";
        Map<String, dynamic> structuredData = responseData['structured_data'] ?? {};

        setState(() {
          this.extractedText = extractedText;
          this.parsedData = structuredData.entries
              .map((e) => "${e.key}: ${e.value}")
              .join("\n");
        });

        print("Extracted text: " + extractedText);
        print("Structured data: $structuredData");

      } else {
        setState(() {
          extractedText = "Error extracting text. Status: ${response.statusCode}";
          parsedData = "Error fetching structured data.";
        });
      }
    } catch (e) {
      print("Error processing image: $e");
      setState(() {
        extractedText = "Error: Failed to connect to the server";
        parsedData = "Error: Failed to connect to the server";
      });
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
                const Placeholder(
                    fallbackHeight: 200, fallbackWidth: double.infinity),
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
              const SizedBox(height: 20),
              Text("Parsed Data:",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text(parsedData, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

}
