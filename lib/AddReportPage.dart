import 'ImportAll.dart';
import 'package:http/http.dart' as http;

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  File? selectedMedia;
  final ImagePicker _picker = ImagePicker();
  String extractedText = "";

  @override
  void initState() {
    // TODO: implement initState
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
        final text = await _extractText(croppedFile);
        setState(() {
          extractedText = text ?? "";
        });
      }
    } else {
      CustomToast(response.exception?.message ?? "Unknown error occurred.",
              Colors.redAccent, Colors.white, 16)
          .showToast();
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPresetCustom(),
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    } on Exception catch (e) {
      CustomToast("Image load failed. Try again or try image from gallery.",
              Colors.blueGrey, Colors.white, 16)
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
          final text = await _extractText(croppedFile);
          setState(() {
            extractedText = text ?? "";
          });
        }
      }
    } on Exception catch (e) {
      CustomToast("Image load failed. Try again or try image from gallery.",
              Colors.blueGrey, Colors.white, 16)
          .showToast();
    }
  }

  // Future<String?> _extractText(File imageFile) async {
  //   try {
  //     var url = Uri.parse('https://ocr-hzm6.onrender.com/extract-text');
  //     String fullText = "";
  //
  //     var request = http.MultipartRequest('POST', url)
  //       ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
  //
  //     var response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       var responseData = await response.stream.bytesToString();
  //       var json = jsonDecode(responseData);
  //       fullText = json['full_text'];
  //       print("Full Text: ${json['full_text']}");
  //       print("Test Values: ${json['test_values']}");
  //     } else {
  //       fullText = response.statusCode.toString();
  //       print("Error: ${response.statusCode}");
  //     }
  //     return fullText;
  //   } on Exception catch (e) {
  //     CustomToast(
  //             "Text extraction failed. Try again or try image from gallery.",
  //             Colors.blueGrey,
  //             Colors.white,
  //             16)
  //         .showToast();
  //   }
  // }

  Future<String?> _extractText(File imageFile) async {
    try {
      var url = Uri.parse('https://ocr-hzm6.onrender.com/extract-text');
      String fullText = "";

      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var json = jsonDecode(responseData);
        fullText = json['full_text'];
        print("Full Text: ${json['full_text']}");
        print("Test Values: ${json['test_values']}");
      } else {
        // Log the full response data for debugging
        var responseData = await response.stream.bytesToString();
        print("Error: ${response.statusCode}");
        print("Response: $responseData");
        fullText = "Error: ${response.statusCode}";
      }
      return fullText;
    } catch (e) {
      print("Error extracting text: $e");
      CustomToast(
          "Text extraction failed. Try again or try image from gallery.",
          Colors.blueGrey,
          Colors.white,
          16)
          .showToast();
    }
  }


  Widget _extractTextView() {
    if (selectedMedia == null) {
      return Text("No image selected!");
    }
    return Column(
      children: [
        FutureBuilder<String?>(
          future: _extractText(selectedMedia!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return Text(
              snapshot.data ?? extractedText,
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: gradientMain,
            // color: Color(0xFF6C5B7B),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Select image using',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              CustomButtonGestureDetector(
                'Camera',
                MediaQuery.of(context).size.width / 3,
                MediaQuery.of(context).size.width / 6,
                Colors.white,
                Colors.black,
                18,
                () {
                  _getImage(ImageSource.camera);
                  // Navigator.of(context).pop();
                },
              ),
              CustomButtonGestureDetector(
                'Gallery',
                MediaQuery.of(context).size.width / 3,
                MediaQuery.of(context).size.width / 6,
                Colors.white,
                Colors.black,
                18,
                () {
                  _getImage(ImageSource.gallery);
                  // Navigator.of(context).pop();
                },
              ),
              _extractTextView(),
            ],
          ),
        ),
      ),
    );
  }
}
