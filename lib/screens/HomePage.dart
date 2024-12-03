import '../ImportAll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageNumber = 0;
  String? userName = FirebaseAuth.instance.currentUser?.email;
  Color selectColor = Colors.green;
  Color unselectColor = Colors.lightBlueAccent;

  Widget changePage() {
    if (pageNumber == 0)
      return HomeScreen();
    else if (pageNumber == 1)
      return HistoryScreen();
    else if (pageNumber == 2)
      return AddReport();

      // return AddReportScreen();
    else
      return ProfileScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HealthTracker\n$userName',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, right: 0, top: 0, bottom: 0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purpleAccent,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.info_outline_rounded),
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
                Color(0xffaa4b6b),
                Color(0xff6b6b83),
                Color(0xff3b8d99),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
              Icons.list,
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
    );
  }
}
