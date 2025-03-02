import '../ImportAll.dart';
import 'package:http/http.dart' as http;

class ReportAttributeProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ChartDataTimewise> _chartData = [];
  bool _isLoading = false;

  List<ChartDataTimewise> get chartData => _chartData;

  bool get isLoading => _isLoading;

  Future<void> fetchReportData(String username, String testName,
      String dateRange, DateTime? startDate, DateTime? endDate) async {
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

      _chartData = await _firestoreService.fetchReportData(
          username, testName, startingDate, endingDate);

      _chartData.sort((a, b) => a.time.compareTo(b.time));
      notifyListeners();
    } catch (e) {
      debugPrint('Error in ReportAttributeProvider.fetchReportData: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> storeReportData(String username, DateTime date,
      String attributeName, double value) async {
    final url = Uri.parse("http://10.100.201.172:5000/api/reports/addReportAttribute");
    try {
      await _firestoreService.storeReportData(username, date, attributeName, value);

      //backend add

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userName": username,
          "date": date.toIso8601String(),
          "testName": attributeName,
          "value": value
        }),
      );

      if (response.statusCode == 201) {
        debugPrint("Report attribute added successfully.");
      } else {
        debugPrint("Failed to add report attribute: ${response.body}");
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error in ReportAttributeProvider.storeReportData: $e');
    }
  }
}
