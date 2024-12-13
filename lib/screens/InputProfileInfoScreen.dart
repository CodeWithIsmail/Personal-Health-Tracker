// import '../ImportAll.dart';
//
// class ProfileInput extends StatefulWidget {
//   ProfileInfo profileInfo;
//
//   ProfileInput(this.profileInfo);
//
//   @override
//   State<ProfileInput> createState() => _ProfileInputState();
// }
//
// class _ProfileInputState extends State<ProfileInput> {
//   Timestamp? timestamp;
//   late DateTime selected;
//   List<TextEditingController> editingControllers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     selected = DateTime.now();
//     for (int i = 0; i <= 10; i++) {
//       editingControllers.add(TextEditingController());
//     }
//     editingControllers[0].text = widget.profileInfo.fname;
//     editingControllers[1].text = widget.profileInfo.lname;
//     editingControllers[2].text = widget.profileInfo.city;
//     editingControllers[3].text = widget.profileInfo.country;
//     editingControllers[4].text = widget.profileInfo.email;
//     editingControllers[5].text = widget.profileInfo.phone;
//     editingControllers[7].text = widget.profileInfo.gender;
//     editingControllers[8].text = widget.profileInfo.weight.toString();
//     editingControllers[9].text = widget.profileInfo.height.toString();
//     editingControllers[10].text = widget.profileInfo.bg;
//   }
//
//   @override
//   void dispose() {
//     for (var controller in editingControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   Future<void> saveInfoToDB() async {
//     String? email = FirebaseAuth.instance.currentUser?.email;
//     String uname = "";
//     if (email != null) {
//       uname = email.substring(0, email.indexOf('@'));
//     } else {
//       uname = "ismail99";
//     }
//     QRCodeGenerator qrCodeGenerator = QRCodeGenerator(uname);
//     String qrcode = await qrCodeGenerator.generateAndUploadQRCode();
//
//     ProfileInfo profileInfo = new ProfileInfo(
//         uname,
//         "https://res.cloudinary.com/ismailcloud/image/upload/v1733837944/photo_2024-12-10_11-35-11_vqwhvj.jpg",
//         qrcode,
//         editingControllers[0].text,
//         editingControllers[1].text,
//         editingControllers[2].text,
//         editingControllers[3].text,
//         editingControllers[4].text,
//         editingControllers[5].text,
//         timestamp!,
//         editingControllers[7].text,
//         editingControllers[10].text,
//         double.tryParse(editingControllers[8].text) ?? 0.0,
//         double.tryParse(editingControllers[9].text) ?? 0.0);
//
//     FirestoreService firestoreService = new FirestoreService();
//     await firestoreService.profileInfoSave(profileInfo);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: Column(
//               children: [
//                 CustomTextField("First Name", false, editingControllers[0],
//                     TextInputType.name),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextField("Last Name", false, editingControllers[1],
//                     TextInputType.name),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextField(
//                     "City", false, editingControllers[2], TextInputType.name),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextField("Country", false, editingControllers[3],
//                     TextInputType.name),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextField("Email", false, editingControllers[4],
//                     TextInputType.emailAddress),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextField(
//                     "Phone", false, editingControllers[5], TextInputType.phone),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 TextFormField(
//                   controller: editingControllers[6],
//                   textAlignVertical: TextAlignVertical.center,
//                   readOnly: true,
//                   onTap: () async {
//                     DateTime? current = await showDatePicker(
//                       context: context,
//                       initialDate: selected,
//                       firstDate: DateTime.now().subtract(Duration(days: 36500)),
//                       // 100 years ago
//                       lastDate: DateTime.now(),
//                     );
//
//                     if (current != null) {
//                       selected = current;
//                       timestamp = Timestamp.fromDate(selected);
//                       editingControllers[6].text =
//                           DateFormat('dd-MMM-yy').format(current);
//                       print('Timestamp: $timestamp');
//                     }
//                   },
//                   decoration: InputDecoration(
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                     hintText: 'Date of Birth',
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.8),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide:
//                           BorderSide(color: Colors.deepPurple, width: 0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide:
//                           BorderSide(color: Colors.purpleAccent, width: 1),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextField(
//                     "Gender", false, editingControllers[7], TextInputType.name),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextField("Weight (kg)", false, editingControllers[8],
//                     TextInputType.number),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextField("Height (cm)", false, editingControllers[9],
//                     TextInputType.number),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextField("Blood group", false, editingControllers[10],
//                     TextInputType.text),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CustomButtonGestureDetector(
//                   "Save info",
//                   100,
//                   50,
//                   Color(0xFF355C7D),
//                   Colors.white,
//                   20,
//                   () {
//                     saveInfoToDB();
//                     // Navigator.pushReplacement(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (context) => HomePage(),
//                     //   ),
//                     // );
//                      Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import '../ImportAll.dart';

class ProfileInput extends StatefulWidget {
  ProfileInfo profileInfo;

  ProfileInput(this.profileInfo);

  @override
  State<ProfileInput> createState() => _ProfileInputState();
}

class _ProfileInputState extends State<ProfileInput> {
  Timestamp? timestamp;
  late DateTime selected;
  List<TextEditingController> editingControllers = [];
  File? _profileImage;
  String imgUrl =
      "https://res.cloudinary.com/ismailcloud/image/upload/v1733837944/photo_2024-12-10_11-35-11_vqwhvj.jpg";
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    selected = DateTime.now();
    for (int i = 0; i <= 10; i++) {
      editingControllers.add(TextEditingController());
    }
    editingControllers[0].text = widget.profileInfo.fname;
    editingControllers[1].text = widget.profileInfo.lname;
    editingControllers[2].text = widget.profileInfo.city;
    editingControllers[3].text = widget.profileInfo.country;
    editingControllers[4].text = widget.profileInfo.email;
    editingControllers[5].text = widget.profileInfo.phone;
    editingControllers[7].text = widget.profileInfo.gender;
    editingControllers[8].text = widget.profileInfo.weight.toString();
    editingControllers[9].text = widget.profileInfo.height.toString();
    editingControllers[10].text = widget.profileInfo.bg;
  }

  @override
  void dispose() {
    for (var controller in editingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
    CloudinaryImageUpload cloudinaryImageUpload = new CloudinaryImageUpload();
    imgUrl = await cloudinaryImageUpload.uploadImage(_profileImage!);
  }

  Future<void> saveInfoToDB() async {
    String? email = FirebaseAuth.instance.currentUser?.email;
    String uname = "";
    if (email != null) {
      uname = email.substring(0, email.indexOf('@'));
    } else {
      uname = "ismail99";
    }
    QRCodeGenerator qrCodeGenerator = QRCodeGenerator(uname);
    String qrcode = await qrCodeGenerator.generateAndUploadQRCode();

    ProfileInfo profileInfo = new ProfileInfo(
        uname,
        imgUrl,
        qrcode,
        editingControllers[0].text,
        editingControllers[1].text,
        editingControllers[2].text,
        editingControllers[3].text,
        editingControllers[4].text,
        editingControllers[5].text,
        timestamp!,
        editingControllers[7].text,
        editingControllers[10].text,
        double.tryParse(editingControllers[8].text) ?? 0.0,
        double.tryParse(editingControllers[9].text) ?? 0.0);

    FirestoreService firestoreService = new FirestoreService();
    await firestoreService.profileInfoSave(profileInfo);
  }

  void showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple.shade300,
          title: Text("Verification Email Sent"),
          titleTextStyle: TextStyle(color: Colors.white),
          content: Text(
              "A verification email has been sent to ${ editingControllers[4].text}. Please check your email to verify your account."),
          contentTextStyle: TextStyle(color: Colors.grey),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input your personal info"),
        titleTextStyle: TextStyle(
          color: Colors.green.shade900,
          fontSize: 17,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                // Display the selected profile image
                if (_profileImage != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(_profileImage!),
                  )
                else
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      label: Text("Gallery"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () => pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text("Camera"),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                CustomTextField("First Name", false, editingControllers[0],
                    TextInputType.name),
                SizedBox(
                  height: 15,
                ),
                CustomTextField("Last Name", false, editingControllers[1],
                    TextInputType.name),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    "City", false, editingControllers[2], TextInputType.name),
                SizedBox(
                  height: 15,
                ),
                CustomTextField("Country", false, editingControllers[3],
                    TextInputType.name),
                SizedBox(
                  height: 15,
                ),
                CustomTextField("Email", false, editingControllers[4],
                    TextInputType.emailAddress),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    "Phone", false, editingControllers[5], TextInputType.phone),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: editingControllers[6],
                  textAlignVertical: TextAlignVertical.center,
                  readOnly: true,
                  onTap: () async {
                    DateTime? current = await showDatePicker(
                      context: context,
                      initialDate: selected,
                      firstDate: DateTime.now().subtract(Duration(days: 36500)),
                      // 100 years ago
                      lastDate: DateTime.now(),
                    );

                    if (current != null) {
                      selected = current;
                      timestamp = Timestamp.fromDate(selected);
                      editingControllers[6].text =
                          DateFormat('dd-MMM-yy').format(current);
                      print('Timestamp: $timestamp');
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    hintText: 'Date of Birth',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.deepPurple, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Colors.purpleAccent, width: 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    "Gender", false, editingControllers[7], TextInputType.name),
                SizedBox(
                  height: 15,
                ),
                CustomTextField("Weight (kg)", false, editingControllers[8],
                    TextInputType.number),
                SizedBox(
                  height: 15,
                ),
                CustomTextField("Height (cm)", false, editingControllers[9],
                    TextInputType.number),
                SizedBox(
                  height: 15,
                ),
                CustomTextField("Blood group", false, editingControllers[10],
                    TextInputType.text),
                SizedBox(
                  height: 15,
                ),
                CustomButtonGestureDetector(
                  "Save info",
                  100,
                  50,
                  Color(0xFF355C7D),
                  Colors.white,
                  20,
                  () {
                    saveInfoToDB();
                    showVerificationDialog();
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => HomePage()),
                    // );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
