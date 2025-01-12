import '../ImportAll.dart';

class ReportProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  // Fetch reports from Firestore
  Future<void> fetchReports(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('report')
          .where('username', isEqualTo: username)
          .get();

      _reports = snapshot.docs
          .map(
              (doc) => Report.fromFirestore(doc.data()))
          .toList();
    } catch (error) {
      print('Error fetching reports: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> filterReportsByDateRange(
      String username, DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('report')
          .where('username', isEqualTo: username)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();

      _reports =
          snapshot.docs.map((doc) => Report.fromFirestore(doc.data())).toList();
    } catch (error) {
      print('Error filtering reports: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a new report
  Future<void> addReport(Report report) async {
    try {
      await _firestore.collection('report').add(report.toFirestore());
      _reports.add(report);
      notifyListeners();
    } catch (error) {
      print('Error adding report: $error');
    }
  }

  // Add a viewer to the report's viewer list
  Future<void> addViewer(String docId, String addViewerUsername) async {
    try {
      await _firestore.collection('report').doc(docId).update({
        'viewer': FieldValue.arrayUnion([addViewerUsername]),
      });

      final index = _reports.indexWhere((report) => report.username == docId);
      if (index != -1) {
        _reports[index].viewer.add(addViewerUsername);
        notifyListeners();
      }
    } catch (error) {
      print('Error adding viewer: $error');
    }
  }

  // Remove a viewer from the report's viewer list
  Future<void> removeViewer(String docId, String removeViewerUsername) async {
    try {
      await _firestore.collection('report').doc(docId).update({
        'viewer': FieldValue.arrayRemove([removeViewerUsername]),
      });

      final index = _reports.indexWhere((report) => report.username == docId);
      if (index != -1) {
        _reports[index].viewer.remove(removeViewerUsername);
        notifyListeners();
      }
    } catch (error) {
      print('Error removing viewer: $error');
    }
  }

  // Delete a report (by document ID)
  Future<void> deleteReport(String docId) async {
    try {
      await _firestore.collection('report').doc(docId).delete();
      _reports.removeWhere((report) => report.username == docId);
      notifyListeners();
    } catch (error) {
      print('Error deleting report: $error');
    }
  }
}
