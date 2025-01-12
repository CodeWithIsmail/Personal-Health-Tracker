import '../ImportAll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageNumber = 0;
  String uname = "";
  String imgLink =
      "https://res.cloudinary.com/ismailcloud/image/upload/v1734184215/defaultProfilePic_vtfdj1.png";
  Color selectColor = Colors.green;
  Color unselectColor = Colors.lightBlueAccent;


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
      return ProfileScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int number) {
          setState(() {
            print(number);
            pageNumber = number;
          });
        },
        type: BottomNavigationBarType.fixed,
        elevation: 5,
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


