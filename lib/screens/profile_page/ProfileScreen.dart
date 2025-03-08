import '../../ImportAll.dart';

class ProfileScreen extends StatefulWidget {
  final String? uname;

  ProfileScreen(this.uname);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthenticationProvider authProvider = AuthenticationProvider();

  UserData? _userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String targetUser = widget.uname ?? authProvider.currentUserName ?? "";
    if (targetUser.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    try {
      print("Fetching user info: $targetUser");
      final userDataMap = await _firestoreService.fetchUserDocument(targetUser);
      if (userDataMap != null) {
        setState(() {
          _userData = UserData.fromMap(userDataMap, targetUser);
          isLoading = false;
        });
        print("User info fetched: ${_userData!.uname}");
      } else {
        setState(() => isLoading = false);
      }
    } catch (error) {
      print("Error fetching user info: $error");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Loading spinner
      );
    }

    if (_userData == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 30),
        child: CustomButtonGestureDetector(
          "Update Profile",
          double.infinity,
          kToolbarHeight,
          Colors.blue.withOpacity(0.3),
          Colors.black,
          20,
          () {
            ProfileInfo profileInfo = ProfileInfo(
              "",
              "",
              "",
              "",
              '',
              '',
              '',
              "",
              "",
              Timestamp.now(),
              "",
              "",
              0.0,
              0.0,
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileInput(profileInfo),
              ),
            );
          },
        ),
      );
    }

    String imgLink = _userData!.image;
    String qrLink = _userData!.qr;
    String fullName = "${_userData!.fname} ${_userData!.lname}";
    String location = "${_userData!.city}, ${_userData!.country}";
    String email = _userData!.email;
    String phone = _userData!.phone;
    String dob = calculateAge(_userData!.dob);
    String gender = _userData!.gender;
    String weight = "${_userData!.weight} Kg";
    String height = "${_userData!.height} cm";
    String bg = _userData!.bg;
    String bmi =
        calculateBMI(_userData!.weight, _userData!.height).toStringAsFixed(2);

    return Scaffold(
      appBar: FirebaseAuth.instance.currentUser!.email!.split('@')[0] ==
              widget.uname
          ? AppBar(toolbarHeight: 0,)
          : AppBar(
              title: Text( "${widget.uname}'s Profile"),
              centerTitle: true,
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: ClipOval(
                  child: Image.network(
                    imgLink,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ProfileInfoItem(Icons.person, "Full Name", fullName),
              ProfileInfoItem(Icons.location_on, "Location", location),
              ProfileInfoItem(Icons.email, "Email", email),
              ProfileInfoItem(Icons.phone, "Phone", phone),
              ProfileInfoItem(Icons.date_range_outlined, "Age", dob),
              ProfileInfoItem(Icons.male, "Gender", gender),
              ProfileInfoItem(Icons.monitor_weight, "Weight", weight),
              ProfileInfoItem(Icons.height, "Height", height),
              ProfileInfoItem(Icons.health_and_safety_sharp, "BMI", bmi),
              ProfileInfoItem(Icons.bloodtype, "Blood Type", bg),
              qrLink == defaultImageLink
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 10),
                      child: CustomButtonGestureDetector(
                        "Add profile info to get QR code",
                        double.infinity,
                        kToolbarHeight,
                        Colors.green.withOpacity(0.3),
                        Colors.black,
                        20,
                        () {},
                      ),
                    )
                  : Image.network(
                      qrLink,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                    ),
              if (widget.uname == null)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 5, bottom: 30),
                  child: CustomButtonGestureDetector(
                    "Edit Profile",
                    double.infinity,
                    kToolbarHeight,
                    Colors.blue.withOpacity(0.3),
                    Colors.black,
                    20,
                    () {
                      ProfileInfo profileInfo = ProfileInfo(
                        _userData!.uname,
                        imgLink,
                        qrLink,
                        _userData!.fname,
                        _userData!.lname,
                        _userData!.city,
                        _userData!.country,
                        email,
                        phone,
                        _userData!.dob,
                        gender,
                        bg,
                        _userData!.weight,
                        _userData!.height,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileInput(profileInfo),
                        ),
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 5, bottom: 30),
                child: CustomButtonGestureDetector(
                  "Health Record History",
                  double.infinity,
                  kToolbarHeight,
                  Colors.blue.withOpacity(0.3),
                  Colors.black,
                  20,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportListScreen(widget.uname),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 5, bottom: 30),
                child: CustomButtonGestureDetector(
                  "Health Record Visualization",
                  double.infinity,
                  kToolbarHeight,
                  Colors.blue.withOpacity(0.3),
                  Colors.black,
                  20,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HistoryVisualization(widget.uname),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  ProfileInfoItem(this.icon, this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 35, color: Colors.lightGreen),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontSize: 12, color: Colors.teal.shade800)),
                  Text(value,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          Divider(
              height: 35,
              thickness: 2,
              indent: 5,
              endIndent: 5,
              color: Color(0xFFD1E6DF)),
        ],
      ),
    );
  }
}
