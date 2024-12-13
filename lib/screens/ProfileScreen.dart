import '../ImportAll.dart';

class ProfileScreen extends StatefulWidget {
  String uname;

  ProfileScreen(this.uname);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirestoreService firestoreService = new FirestoreService();

  double calculateBMI(double weight, double height) {
    print(weight);
    print(height);
    height /= 100.0;
    return (weight / (height * height));
  }

  String calculateAge(Timestamp birthDate) {
    DateTime birthDateTime = birthDate.toDate();
    DateTime currentDate = DateTime.now();

    int years = currentDate.year - birthDateTime.year;
    int months = currentDate.month - birthDateTime.month;
    int days = currentDate.day - birthDateTime.day;
    if (months < 0) {
      months += 12;
      years--;
    }
    if (days < 0) {
      months--;
      days += DateTime(currentDate.year, currentDate.month, 0).day;
    }
    String yearsText = years <= 1 ? "Year" : "Years";
    String monthsText = months <= 1 ? "Month" : "Months";
    String daysText = days <= 1 ? "Day" : "Days";

    List<String> parts = [];

    if (years > 0) {
      parts.add("$years $yearsText");
    }
    if (months > 0) {
      parts.add("$months $monthsText");
    }
    if (days > 0) {
      parts.add("$days $daysText");
    }
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uname)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('An error occurred!'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Center(child: Text('No records found.'));
            }

            DocumentSnapshot documentSnapshot = snapshot.data!;
            Map<dynamic, dynamic> data =
                documentSnapshot.data() as Map<dynamic, dynamic>;
            //print(data);
            String imgLink = data['image'];
            String qrLink = data['qr'];
            String full_name = data['fname'] + " " + data['lname'];
            String location = data['city'] + ", " + data['country'];
            String email = data['email'];
            String phone = data['phone'];
            String dob = calculateAge(data['dob']);
            String gender = data['gender'];
            String weight = data['weight'].toString() + " Kg";
            String height = data['height'].toString() + " cm";
            String bg = data['bg'];
            return SingleChildScrollView(
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
                  ProfileInfoItem(
                      Icons.health_and_safety_sharp,
                      "BMI",
                      calculateBMI(data['weight'].toDouble(),
                              data['height'].toDouble())
                          .toStringAsFixed(2)),
                  ProfileInfoItem(Icons.bloodtype, "Blood Type", bg),
                  Image.network(
                    qrLink,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  IconData icon;
  String title;
  String value;

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
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
              color: Color(0xFFD1E6DF)),
        ],
      ),
    );
  }
}
