import 'package:http/http.dart' as http;
import '../ImportAll.dart';

class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  File? selectedMedia;
  final ImagePicker _picker = ImagePicker();
  String extractedText = "Extracted text will appear here";
  String parsedData = "Parsed data will appear here";
  FirestoreService firestoreService = new FirestoreService();
  String imageURL = "";

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
        // await _uploadImage(croppedFile);
        // await _processImage(croppedFile);
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
            // isLoading = true;
            selectedMedia = croppedFile;
          });
          await _uploadImage(croppedFile);
          // await _processImage(croppedFile);
          String values =
              await sendImagePromptToGemini(generalPrompt, croppedFile, null);
          print(values);
          await _processImage(values);
          await _gotoAnalysisScreen(croppedFile);
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
      setState(() {
        imageURL = imgUrl;
      });
      //  firestoreService.storeImgLink("123", "234", imgUrl);
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

  Future<void> _gotoAnalysisScreen(File imageFile) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportAnalysis(imageFile, imageURL),
      ),
    );
  }

  Future<void> _processImage(String response) async {
    Map<String, String> reportMap = {};
    List<dynamic>? tnames = [];
    String stnames = "";
    String found = "";

    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('test_collection')
        .doc('ismail')
        .get();

    if (document.exists) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        tnames = data['test_names'] as List<dynamic>?;
        if (tnames != null) {
          for (String name in tnames) {
            stnames += name + ",";
          }
        } else {
          print("test names does not exist or is null.");
        }
      }
    } else {
      print("No such document!");
    } // created a comma seperated string of predefined test names from database

    List<String> lines = response.split('\n');
    for (String line in lines) {
      if (line.trim().isEmpty) continue;
      List<String> parts = line.split(':');
      if (parts.length == 2) {
        String key = parts[0].trim();
        String value = parts[1].trim();
        key =
            key.replaceAll('/', '_').replaceAll('-', '_').replaceAll(' ', '_');
        found += key + ",";
      }
    } // created a comma seperated string of founded test names from user input

    String similarCheck = await similar(stnames, found);
    print("predefined: " + stnames);
    print("found: " + found);
    print(similarCheck);

    Map<String, String> testNameMap = {};
    List<String> responseLines = similarCheck.trim().split('\n');
    for (String line in responseLines) {
      List<String> parts = line.split(' : ');
      if (parts.length == 2) {
        String key = parts[0].trim();
        String value = parts[1].trim();
        testNameMap[key] = value;
      }
    } // mapped to each test  name to predefined name
    print(testNameMap);

    for (String line in lines) {
      if (line.trim().isEmpty) continue;
      List<String> parts = line.split(':');
      if (parts.length == 2) {
        String key = parts[0].trim();
        String value = parts[1].trim();
        key =
            key.replaceAll('/', '_').replaceAll('-', '_').replaceAll(' ', '_');
        reportMap[testNameMap[key]!] = value;
      }
    }
    // CBC cbc = CBC.fromMap(reportMap);
    // print(cbc);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportInputScreen(testData: reportMap),
      ),
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
                'Give report data using',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              // if (isLoading)
              //   CircularProgressIndicator(
              //     color: Colors.white,
              //   ),
              CustomButtonGestureDetector(
                'Camera',
                MediaQuery.of(context).size.width / 3,
                MediaQuery.of(context).size.width / 6,
                Colors.white,
                Colors.black,
                18,
                () {
                  _getImage(ImageSource.camera);
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
                },
              ),
              CustomButtonGestureDetector(
                'Manual Input',
                MediaQuery.of(context).size.width / 3,
                MediaQuery.of(context).size.width / 6,
                Colors.white,
                Colors.black,
                18,
                () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CBCinputScreen(new CBC(
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "",
                  //         "")),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
