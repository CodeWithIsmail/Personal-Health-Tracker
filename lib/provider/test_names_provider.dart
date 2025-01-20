import '../ImportAll.dart';

class TestNamesProvider with ChangeNotifier {
  final List<String> _testNames = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> get testNames => _testNames;

  Future<void> fetchTestNames() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('test_collection')
          .doc('sample')
          .get();

      if (documentSnapshot.exists) {
        List<dynamic> data = documentSnapshot.get('test_names');
        _testNames.clear();
        _testNames.addAll(data.cast<String>());
        notifyListeners();
      }
    } catch (e) {
      // Handle errors appropriately
      debugPrint('Error fetching test names: $e');
    }
  }
}
