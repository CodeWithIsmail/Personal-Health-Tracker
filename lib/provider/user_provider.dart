import '../ImportAll.dart';

class UserInfoProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  UserData? _selectedUser;
  bool isLoading = false;
  bool hasFetched = false;

  UserData? get selectedUser => _selectedUser;

  /// Fetch user info by username (document ID)
  Future<void> fetchUserInfo(String username) async {
    // reset();
    if (hasFetched) return;
    isLoading = true;
    notifyListeners();
    //

    try {
      print("fetching user info: " + username);
      final userDataMap = await _firestoreService.fetchUserDocument(username);

      if (userDataMap != null) {
        _selectedUser = UserData.fromMap(userDataMap, username);
       print("user info fetched: " + _selectedUser!.uname);
      } else {
        _selectedUser = null;
      }
      hasFetched = true;
    } catch (error) {
      print('Error processing user info: $error');
      _selectedUser = null;
    } finally {
      hasFetched = true;
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
