import '../ImportAll.dart';

class TestNamesProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  final List<String> _testNames = [];

  List<String> get testNames => _testNames;

  // Fetch test names from Firestore
  Future<void> fetchTestNames() async {
    try {
      final fetchedTestNames = await _firestoreService.fetchTestNames();
      _testNames.clear();
      _testNames.addAll(fetchedTestNames);
      notifyListeners();
    } catch (e) {
      debugPrint('Error processing test names: $e');
    }
  }

  // Add a new test name to Firestore and update local state
  Future<void> addTestName(String testName) async {
    try {
      await _firestoreService.addTestName(testName);
      _testNames.add(testName);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding test name: $e');
    }
  }
}
