import '../ImportAll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageNumber = 0;
  String uname = "";
  String imgLink = "https://res.cloudinary.com/ismailcloud/image/upload/v1734184215/defaultProfilePic_vtfdj1.png";
  Color selectColor = Colors.green;
  Color unselectColor = Colors.lightBlueAccent;

  Future<void> setImageLink() async {
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uname).get();

      if (docSnapshot.exists) {
        imgLink = docSnapshot.get('image');
      } else {
        imgLink =
            "https://res.cloudinary.com/ismailcloud/image/upload/v1734184215/defaultProfilePic_vtfdj1.png";
      }
    } catch (e) {
      print("Error fetching image link: $e");
      imgLink =
          "https://res.cloudinary.com/ismailcloud/image/upload/v1734184215/defaultProfilePic_vtfdj1.png"; // Default image in case of error
    }
  }

  @override
  void initState() {
    super.initState();
    String? email = FirebaseAuth.instance.currentUser?.email;
    uname = email!.substring(0, email.indexOf('@'));
      setImageLink();
  }

  Widget changePage() {
    if (pageNumber == 0)
      return HomeScreen();
    else if (pageNumber == 1)
      return HistoryAnalysisScreen();
    else if (pageNumber == 2)
      return ReportHistoryVisualization();
    else if (pageNumber == 3)
      return AddReport();
    else
      return ProfileScreen(uname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HealthTracker\n$uname',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        // centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(5),
          child: ClipOval(
            child: Image.network(
              imgLink,
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanCodePage(),
                ),
              );
            },
            icon: Icon(Icons.qr_code_scanner),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginOrRegistration(),
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFA1FFCE),
                Color(0xFFFAFFD1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int number) {
          setState(() {
            print(number);
            pageNumber = number;
          });
        },
        type: BottomNavigationBarType.fixed,
        elevation: 5,

        // backgroundColor: Colors.grey.shade400,
        // showUnselectedLabels: false,
        // showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: pageNumber == 0 ? selectColor : unselectColor,
            ),
            label: 'Home',
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              color: pageNumber == 1 ? selectColor : unselectColor,
            ),
            label: 'History',
            tooltip: 'Health report history',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.stacked_line_chart,
              color: pageNumber == 2 ? selectColor : unselectColor,
            ),
            label: 'Visualization',
            tooltip: 'Report History Visualization',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment_outlined,
              color: pageNumber == 3 ? selectColor : unselectColor,
            ),
            label: 'Add record',
            tooltip: 'Add new medical report record',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_available_outlined,
              color: pageNumber == 4 ? selectColor : unselectColor,
            ),
            label: 'Profile',
            tooltip: 'Profile page',
          ),
        ],
      ),
      body: changePage(),
    );
  }
}
