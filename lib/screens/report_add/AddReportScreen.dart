import '../../ImportAll.dart';
import 'ManualReport.dart';

class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  File? selectedMedia;
  final ImagePicker _picker = ImagePicker();
  DateTime? selectedDate;
  FirestoreService firestoreService = new FirestoreService();
  GeminiService geminiService = new GeminiService();
  String imageURL = "";
  bool isLoading = false;
  bool isManualInputVisible = false;

  List<Map<String, TextEditingController>> manualFields = [];

  void initState() {
    super.initState();
    getLostData();
    selectedDate = DateTime.now();
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
        String values = await geminiService.sendImagePromptToGemini(
            generalPrompt, croppedFile, null);
        print(values);
        await _processImage(values);
        //  await _gotoAnalysisScreen(croppedFile);
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
            isLoading = true;
          });

          String values = await geminiService.sendImagePromptToGemini(
              generalPrompt, croppedFile, null);
          print(values);
          await _uploadImage(croppedFile);
          await _processImage(values);

          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    CloudinaryService cloudinaryImageUpload = new CloudinaryService();
    String imgUrl = await cloudinaryImageUpload.uploadImage(imageFile);
    setState(() {
      imageURL = imgUrl;
    });
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

  Future<void> _processImage(String response) async {
    Map<String, String> reportMap = {};
    List<dynamic>? tnames = [];
    String stnames = "";
    String found = "";

    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('test_collection')
        .doc('sample')
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
        key =
            key.replaceAll('/', ' ').replaceAll('-', ' ').replaceAll(' ', ' ');
        found += key + ",";
      }
    } // created a comma seperated string of founded test names from user input

    String similarCheck = await geminiService.similar(stnames, found);
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

        if (!tnames!.contains(value)) {
          await FirebaseFirestore.instance
              .collection('test_collection')
              .doc('sample')
              .update({
            'test_names': FieldValue.arrayUnion([value]),
          });
        }
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
            key.replaceAll('/', ' ').replaceAll('-', ' ').replaceAll(' ', ' ');
        reportMap[testNameMap[key]!] = value;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportAnalysis(selectedMedia!, imageURL,selectedDate ?? DateTime.now()),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReportInputScreen(reportMap, selectedDate ?? DateTime.now()),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     child: Center(
  //       child: isLoading
  //           ? Center(
  //               child: defaultSpinKitWave,
  //             )
  //           : Container(
  //               decoration: BoxDecoration(
  //                 gradient: gradientMain,
  //                 // color: Color(0xFF6C5B7B),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
  //               height: MediaQuery.of(context).size.height / 2,
  //               width: MediaQuery.of(context).size.width,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     'Give report data using',
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 20,
  //                         color: Colors.white),
  //                   ),
  //                   CustomButtonGestureDetector(
  //                     'Camera',
  //                     MediaQuery.of(context).size.width / 3,
  //                     MediaQuery.of(context).size.width / 6,
  //                     Colors.white,
  //                     Colors.black,
  //                     18,
  //                     () {
  //                       _getImage(ImageSource.camera);
  //                     },
  //                   ),
  //                   CustomButtonGestureDetector(
  //                     'Gallery',
  //                     MediaQuery.of(context).size.width / 3,
  //                     MediaQuery.of(context).size.width / 6,
  //                     Colors.white,
  //                     Colors.black,
  //                     18,
  //                     () {
  //                       _getImage(ImageSource.gallery);
  //                     },
  //                   ),
  //                   CustomButtonGestureDetector(
  //                     'Manual Input',
  //                     MediaQuery.of(context).size.width / 3,
  //                     MediaQuery.of(context).size.width / 6,
  //                     Colors.white,
  //                     Colors.black,
  //                     18,
  //                     () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => Manualreport()),
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: isLoading
            ? Center(
                child: defaultSpinKitWave,
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: gradientMain,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date Picker Button
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              selectedDate == null
                                  ? "Select Report Date"
                                  : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Text(
                      'Give report data using',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Manualreport()),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
