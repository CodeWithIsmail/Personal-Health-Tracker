import '../ImportAll.dart';

class ReportProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Report> _reports = [];
  bool _isLoading = false;

  List<Report> get reports => _reports;

  bool get isLoading => _isLoading;

  String _selectedDateOption = "All";

  String get selectedDateOption => _selectedDateOption;

  void setSelectedDateOption(String option) {
    _selectedDateOption = option;
    notifyListeners();
  }

  /// Fetch all reports for a username
  Future<void> fetchReports(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("target user: " + username);
      _reports = await _firestoreService.fetchReports(username);
    } catch (error) {
      print('Error fetching reports: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Filter reports by date range
  Future<void> filterReportsByDateRange(
      String username, DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reports = await _firestoreService.fetchReportsByDateRange(
          username, startDate, endDate);
    } catch (error) {
      print('Error filtering reports: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Add a new report
  Future<void> addReport(Report report) async {
    try {
      await _firestoreService.addReport(report);
      _reports.add(report);
      notifyListeners();
    } catch (error) {
      print('Error adding report: $error');
    }
  }

  /// Add a viewer to the report's viewer list
  Future<void> addViewer(String docId, String addViewerUsername) async {
    try {
      await _firestoreService.addViewer(docId, addViewerUsername);

      final index = _reports.indexWhere((report) => report.username == docId);
      if (index != -1) {
        _reports[index].viewer.add(addViewerUsername);
        notifyListeners();
      }
    } catch (error) {
      print('Error adding viewer: $error');
    }
  }

  /// Remove a viewer from the report's viewer list
  Future<void> removeViewer(String docId, String removeViewerUsername) async {
    try {
      await _firestoreService.removeViewer(docId, removeViewerUsername);

      final index = _reports.indexWhere((report) => report.username == docId);
      if (index != -1) {
        _reports[index].viewer.remove(removeViewerUsername);
        notifyListeners();
      }
    } catch (error) {
      print('Error removing viewer: $error');
    }
  }

  /// Delete a report
  Future<void> deleteReport(String docId) async {
    try {
      await _firestoreService.deleteReport(docId);
      _reports.removeWhere((report) => report.username == docId);
      notifyListeners();
    } catch (error) {
      print('Error deleting report: $error');
    }
  }
}
