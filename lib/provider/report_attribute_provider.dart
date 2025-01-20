import '../ImportAll.dart';

class ReportAttributeProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ChartDataTimewise> _chartData = [];
  bool _isLoading = false;

  List<ChartDataTimewise> get chartData => _chartData;

  bool get isLoading => _isLoading;

  Future<void> fetchReportData({
    required String username,
    required String testName,
    required String dateRange,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    notifyListeners();
    DateTime startingDate;
    DateTime endingDate = DateTime.now();
    try {
      if (dateRange == 'Custom' && startDate != null && endDate != null) {
        startingDate = startDate;
        endingDate = endDate;
      } else {
        switch (dateRange) {
          case 'Last Week':
            startingDate = endingDate.subtract(Duration(days: 7));
            break;
          case 'Last 15 Days':
            startingDate = endingDate.subtract(Duration(days: 15));
            break;
          case 'Last Month':
            startingDate = endingDate.subtract(Duration(days: 30));
            break;
          case 'Last Year':
            startingDate = endingDate.subtract(Duration(days: 365));
            break;
          case 'All':
            startingDate = endingDate.subtract(Duration(days: 36500));
            break;
          default:
            startingDate = endingDate.subtract(Duration(days: 36500));
        }
      }

      print(formatDate(startingDate));
      print(formatDate(endingDate));
      print(testName);
      print(username);

      QuerySnapshot snapshot = await _firestore
          .collection('report_attribute')
          .where('username', isEqualTo: username)
          .where('attribute_name', isEqualTo: testName)
          .where('date', isGreaterThanOrEqualTo: startingDate)
          .where('date', isLessThanOrEqualTo: endingDate)
          .get();

      _chartData.clear();
      snapshot.docs.forEach((doc) {
        final report =
            ReportAttribute.fromMap(doc.data() as Map<String, dynamic>);
        _chartData.add(ChartDataTimewise(
          report.date.millisecondsSinceEpoch,
          report.value,
        ));
      });

      _chartData.sort((a, b) => a.time.compareTo(b.time));

      for(var ev in _chartData) {
        print('${ev.time} : ${ev.value}');
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching report data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
