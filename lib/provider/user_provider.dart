import '../ImportAll.dart';

class UserInfoProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserData? _selectedUser;
  bool isLoading = false;
  bool hasFetched = false; // New flag to track fetch status

  UserData? get selectedUser => _selectedUser;

  /// Fetch user info by username (document ID)
  Future<void> fetchUserInfo(String username) async {
    if (hasFetched) return; // Prevent redundant fetch calls
    isLoading = true;
    notifyListeners();

    try {
      final docSnapshot =
      await _firestore.collection('users').doc(username).get();

      if (docSnapshot.exists) {
        _selectedUser = UserData.fromMap(
            docSnapshot.data() as Map<String, dynamic>, username);
      } else {
        _selectedUser = null;
      }
      hasFetched = true; // Mark data as fetched
    } catch (error) {
      print('Error fetching user info: $error');
      _selectedUser = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _selectedUser = null;
    isLoading = false;
    hasFetched = false;
    notifyListeners();
  }
}
