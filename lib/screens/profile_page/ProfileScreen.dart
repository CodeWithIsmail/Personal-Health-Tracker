import '../../ImportAll.dart';

class ProfileScreen extends StatefulWidget {
  String? uname;

  ProfileScreen(this.uname);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserInfoProvider userInfoProvider;
  late AuthenticationProvider authProvider;

  @override
  void initState() {
    super.initState();

    if(widget.uname != null){
      userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
      userInfoProvider.fetchUserInfo(widget.uname ?? "");
      print("name found");
    }
    else{
      print("else name found");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

        authProvider =
            Provider.of<AuthenticationProvider>(context, listen: false);

        // Fetch user data after the first build
        if (!userInfoProvider.hasFetched) {
          userInfoProvider.fetchUserInfo(authProvider.currentUserName ?? "");
          print(authProvider.currentUserName);
        }
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    // final userInfoProvider =
    //     Provider.of<UserInfoProvider>(context, listen: false);
    final authProvider = Provider.of<AuthenticationProvider>(context);

    // Show loading spinner if data is still loading
    if (userInfoProvider.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Loading spinner
      );
    }

    // Get the current user data
    UserData? currentUser = userInfoProvider.selectedUser;
    String imgLink = currentUser == null ? defaultImageLink : currentUser.image;
    String qrLink = currentUser == null ? defaultImageLink : currentUser.qr;
    String full_name =
        currentUser == null ? "" : currentUser.fname + " " + currentUser.lname;
    String location = currentUser == null
        ? ""
        : currentUser.city + ", " + currentUser.country;
    String email = authProvider.currentUser?.email ?? "";
    String phone = currentUser == null ? "" : currentUser.phone;
    String dob = currentUser == null ? "" : calculateAge(currentUser.dob);
    String gender = currentUser == null ? "" : currentUser.gender;
    String weight =
        currentUser == null ? "" : currentUser.weight.toString() + " Kg";
    String height =
        currentUser == null ? "" : currentUser.height.toString() + " cm";
    String bg = currentUser == null ? "" : currentUser.bg;
    String bmi = currentUser == null
        ? ""
        : calculateBMI(currentUser.weight, currentUser.height)
            .toStringAsFixed(2);

    return Scaffold(
      body: SingleChildScrollView(
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
            ProfileInfoItem(Icons.person, "Full Name", full_name),
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
                    ProfileInfo profileInfo;
                    if (currentUser == null)
                      profileInfo = ProfileInfo("", "", "", "", "", "", "",
                          email, "", Timestamp.now(), "", "", 0.0, 0.0);
                    else
                      profileInfo = ProfileInfo(
                          currentUser.uname,
                          imgLink,
                          qrLink,
                          currentUser.fname,
                          currentUser.lname,
                          currentUser.city,
                          currentUser.country,
                          email,
                          phone,
                          currentUser.dob,
                          gender,
                          bg,
                          currentUser.weight,
                          currentUser.height);

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
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 30),
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
                      builder: (context) => ReportListScreen(null),
                    ),
                  );
                },
              ),
            ),
          ],
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
              Icon(
                icon,
                size: 35,
                color: Colors.lightGreen,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.teal.shade800),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            height: 35,
            thickness: 2,
            indent: 5,
            endIndent: 5,
            color: Color(0xFFD1E6DF),
          ),
        ],
      ),
    );
  }
}
