import '../ImportAll.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int pageNumber = 0;
  Color selectColor = Colors.green;
  Color unselectColor = Colors.lightBlueAccent;

  Widget changePage() {
    if (pageNumber == 0)
      return HomePage();
    else if (pageNumber == 1)
      return ReportListScreen(FirebaseAuth.instance.currentUser!.email!.split('@')[0]);
    else if (pageNumber == 2)
      return HistoryVisualization(FirebaseAuth.instance.currentUser!.email!.split('@')[0]);
    // return ReportHistoryVisualization();
    else if (pageNumber == 3)
      return AddReport();
    else if (pageNumber == 4)
      return ProfileScreen(FirebaseAuth.instance.currentUser!.email!.split('@')[0]);
    else
      return ConnectionPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[50],
        onPressed: () {
          setState(() {
            pageNumber = 3;
          });
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color(0xFF93F9B9),
        child: IconTheme(
            data: IconThemeData(),
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        pageNumber = 0;
                      });
                    },
                    icon: Icon(
                      Icons.home,
                      color: pageNumber == 0 ? selectColor : unselectColor,
                      size: 30,
                    ),
                    tooltip: 'Home',
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        pageNumber = 1; // Favorites
                      });
                    },
                    icon: Icon(
                      Icons.history,
                      color: pageNumber == 1 ? selectColor : unselectColor,
                      size: 30,
                    ),
                    tooltip: 'Health report history',
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        pageNumber = 2; // Profile
                      });
                    },
                    icon: Icon(
                      Icons.bar_chart,
                      color: pageNumber == 2 ? selectColor : unselectColor,
                      size: 30,
                    ),
                    tooltip: 'Report History Visualization',
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        pageNumber = 4; // Profile
                      });
                    },
                    icon: Icon(
                      Icons.person,
                      color: pageNumber == 4 ? selectColor : unselectColor,
                      size: 30,
                    ),
                    tooltip: 'Profile page',
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        pageNumber = 5; // Profile
                      });
                    },
                    icon: Icon(
                      Icons.people_rounded,
                      color: pageNumber == 5 ? selectColor : unselectColor,
                      size: 30,
                    ),
                    tooltip: 'Connections',
                  ),
                ],
              ),
            )),
      ),
      body: changePage(),
    );
  }
}
