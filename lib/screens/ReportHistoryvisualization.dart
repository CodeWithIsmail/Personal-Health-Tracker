import 'package:personal_health_tracker/components/ReportFilterWidget.dart';
import 'package:personal_health_tracker/custom/CustomDropDown.dart';

import '../ImportAll.dart';

class DateWiseTestData {
  final String date;
  final double value;

  DateWiseTestData(this.date, this.value);
}

class ReportHistoryVisualization extends StatefulWidget {
  const ReportHistoryVisualization({Key? key}) : super(key: key);

  @override
  _ReportHistoryVisualizationState createState() =>
      _ReportHistoryVisualizationState();
}

class _ReportHistoryVisualizationState
    extends State<ReportHistoryVisualization> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> _testNames = [];
  String? _selectedTestName;
  List<DateWiseTestData> _chartData = [];
  String uname = "";
  bool _isLoading = false;
  //filter date and time selector

  @override
  void initState() {
    super.initState();
    _fetchTestNames();
    String? email = FirebaseAuth.instance.currentUser?.email;
    uname = email!.substring(0, email.indexOf('@'));
  }

  Future<void> _fetchTestNames() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('test_collection').doc('sample').get();
      List<dynamic> testNames = snapshot['test_names'];
      setState(() {
        _testNames = List<String>.from(testNames);
      });
    } catch (e) {
      print('Error fetching test names: $e');
    }
  }

  Future<void> _fetchTestValues(String testName) async {
    setState(() {
      _isLoading = true;
      _chartData = [];
    });

    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('report_data').doc(uname).get();
      List<dynamic> testData = snapshot[testName];
      List<DateWiseTestData> chartData = testData.map((data) {
        DateTime dateTime = data['timestamp'].toDate();
        String formattedDate = DateFormat('dd-MMM-yy').format(dateTime);
        double value = double.parse(data['value']);
        return DateWiseTestData(formattedDate, value);
      }).toList();

      setState(() {
        _chartData = chartData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching test values: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.indigo.shade300,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButton<String>(
        hint: Text(
          "Select Test Name",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        value: _selectedTestName,
        items: _testNames.map((testName) {
          return DropdownMenuItem<String>(
            value: testName,
            child: Text(testName),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedTestName = value;
          });
          if (value != null) {
            print(value);
            _fetchTestValues(value);
          }
        },
        isExpanded: true,
        underline: SizedBox(),
      ),
    );
  }

  //dialog start
  //dialog end

  Widget _buildDateWiseCharts() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SfCartesianChart(
              backgroundColor: Colors.brown.shade100,
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                majorGridLines: MajorGridLines(width: 0),
              ),
              title: ChartTitle(
                text: _selectedTestName! + " Value Line chart",
                textStyle: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                enablePinching: true,
                enableDoubleTapZooming: true,
                enableSelectionZooming: true,
              ),
              crosshairBehavior: CrosshairBehavior(
                activationMode: ActivationMode.doubleTap,
                enable: true,
                lineColor: Colors.green,
                lineWidth: 1,
              ),
              series: <CartesianSeries>[
                LineSeries<DateWiseTestData, String>(
                  width: 3,
                  color: Color(0xFF6C5B7B),
                  name: "Date : " + _selectedTestName! + " Value",
                  dataSource: _chartData,
                  xValueMapper: (DateWiseTestData data, _) => data.date,
                  yValueMapper: (DateWiseTestData data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SfCartesianChart(
              backgroundColor: Colors.brown.shade100,
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                majorGridLines: MajorGridLines(width: 0),
              ),
              title: ChartTitle(
                text: _selectedTestName! + " Value Column chart",
                textStyle: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                enablePinching: true,
                enableDoubleTapZooming: true,
                enableSelectionZooming: true,
              ),
              crosshairBehavior: CrosshairBehavior(
                activationMode: ActivationMode.doubleTap,
                enable: true,
                lineColor: Colors.green,
                lineWidth: 1,
              ),
              series: <CartesianSeries>[
                ColumnSeries<DateWiseTestData, String>(
                  gradient: gradientMain,
                  // color: Color(0xFF6C5B7B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  name: "Date : " + _selectedTestName! + " Value",
                  dataSource: _chartData,
                  xValueMapper: (DateWiseTestData data, _) => data.date,
                  yValueMapper: (DateWiseTestData data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildDropdown(),
            //filter start
            Reportfilterwidget(),
            //filter end
            _isLoading
                ? SpinKitFadingCircle(
                    size: 50,
                    color: Colors.deepPurple,
                  )
                : _chartData.isEmpty
                    ? Text('No data available')
                    : Expanded(
                        child: SingleChildScrollView(
                          child: _buildDateWiseCharts(),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
