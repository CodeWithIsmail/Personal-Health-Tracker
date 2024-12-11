import '../ImportAll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageNumber = 0;
  String uname = "";
  String imgLink = "";
  Color selectColor = Colors.green;
  Color unselectColor = Colors.lightBlueAccent;

  @override
  void initState() {
    super.initState();
    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      uname = email.substring(0, email.indexOf('@'));
      DocumentSnapshot docSnapshot = FirebaseFirestore.instance
          .collection('users')
          .doc(uname)
          .get() as DocumentSnapshot<Object?>;
      if (docSnapshot.exists) {
        imgLink = docSnapshot.get('image');
      } else {
        imgLink =
            "https://res.cloudinary.com/ismailcloud/image/upload/v1733837944/photo_2024-12-10_11-35-11_vqwhvj.jpg";
      }
    } else {
      uname = "ismail99";
      imgLink =
          "https://res.cloudinary.com/ismailcloud/image/upload/v1733837944/photo_2024-12-10_11-35-11_vqwhvj.jpg";
    }
  }

  Widget changePage() {
    if (pageNumber == 0)
      return HomeScreen();
    else if (pageNumber == 1)
      return HistoryScreen();
    else if (pageNumber == 2)
      return AddReport();

    // return AddReportScreen();
    else
      return ProfileScreen("ismail99");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              onPressed:(){
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
                Icons.assignment_outlined,
                color: pageNumber == 2 ? selectColor : unselectColor,
              ),
              label: 'Add record',
              tooltip: 'Add new medical report record',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.event_available_outlined,
                color: pageNumber == 3 ? selectColor : unselectColor,
              ),
              label: 'Profile',
              tooltip: 'Profile page',
            ),
          ],
        ),
        body: changePage(),
      ),
    );
  }
}
