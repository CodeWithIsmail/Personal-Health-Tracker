import '../ImportAll.dart';

class UserInfoProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  UserData? _selectedUser;
  bool isLoading = false;
  bool hasFetched = false;

  UserData? get selectedUser => _selectedUser;

  /// Fetch user info by username (document ID)
  Future<void> fetchUserInfo(String username) async {
    if (hasFetched) return;
    isLoading = true;
    notifyListeners();

    try {
      final userDataMap = await _firestoreService.fetchUserDocument(username);

      if (userDataMap != null) {
        _selectedUser = UserData.fromMap(userDataMap, username);
      } else {
        _selectedUser = null;
      }
      hasFetched = true;
    } catch (error) {
      print('Error processing user info: $error');
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
