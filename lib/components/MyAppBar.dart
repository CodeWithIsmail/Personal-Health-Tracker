
import '../ImportAll.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {

        // Fetching the providers after the widget is built using addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch user info only if necessary
      final userInfoProvider =
          Provider.of<UserInfoProvider>(context, listen: false);
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);

      // Fetch user data if it's not available yet
      if (userInfoProvider.selectedUser == null &&
          authProvider.currentUserName != null) {
        userInfoProvider.fetchUserInfo(authProvider.currentUserName ?? "");
      }
    });

    // Call providers only for rendering UI
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final userInfoProvider = Provider.of<UserInfoProvider>(context);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final userInfoProvider =
    //       Provider.of<UserInfoProvider>(context, listen: false);
    //   final authProvider =
    //       Provider.of<AuthenticationProvider>(context, listen: false);
    //
    //   if (userInfoProvider.selectedUser == null &&
    //       authProvider.currentUserName != null) {
    //     userInfoProvider.fetchUserInfo(authProvider.currentUserName ?? "");
    //   }
    // });
    //
    // final authProvider = Provider.of<AuthenticationProvider>(context);
    // final userInfoProvider = Provider.of<UserInfoProvider>(context);

    return AppBar(
      title: Text(
        'HealthMate\n${authProvider.currentUserName}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.all(5),
        child: ClipOval(
          child: Image.network(
            userInfoProvider.selectedUser?.image ?? defaultImageLink,
            fit: BoxFit.cover,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            searchUser(context);
          },
          icon: Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/scanCodePage');
          },
          icon: Icon(Icons.qr_code_scanner),
        ),
        IconButton(
          onPressed: () {
            authProvider.signOut(context);
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          },
          icon: Icon(Icons.logout),
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1D976C),
              Color(0xFF93F9B9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Future<String?> showUsernameInputDialog(BuildContext context) async {
    TextEditingController _usernameController = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Search user",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "Enter username",
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        String enteredUsername =
                            _usernameController.text.trim();
                        if (enteredUsername.isNotEmpty) {
                          Navigator.pop(context, enteredUsername);
                        }
                      },
                      child: Text("Search"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void searchUser(BuildContext context) async {
    String? newUsername = await showUsernameInputDialog(context);

    if (newUsername != null && newUsername.isNotEmpty) {
      checkPermissionAndNavigate(context, newUsername);
    }
  }

  void checkPermissionAndNavigate(
      BuildContext context, String targetUsername) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    String currentUser = authProvider.currentUserName ?? "";

    // Fetch the current user's document from the 'connection' collection
    final DocumentSnapshot<Map<String, dynamic>> currentUserDoc =
        await FirebaseFirestore.instance
            .collection("connection")
            .doc(currentUser)
            .get();

    // Fetch the target user's document from the 'connection' collection
    final DocumentSnapshot<Map<String, dynamic>> targetUserDoc =
        await FirebaseFirestore.instance
            .collection("connection")
            .doc(targetUsername)
            .get();

    if (targetUserDoc.exists && currentUserDoc.exists) {
      // Get the viewers and connections array for both users
      List<dynamic> targetViewers = targetUserDoc.data()?["viewers"] ?? [];
      List<dynamic> currentConnections =
          currentUserDoc.data()?["connections"] ?? [];

      // Check if current user is in the target user's viewers array and if target user is in current user's connections
      if (targetViewers.contains(currentUser) &&
          currentConnections.contains(targetUsername)) {
        // Permission granted: Navigate to the profile screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(targetUsername),
          ),
        );
      } else {
        // No permission: Show a dialog
        showNoPermissionDialog(context);
      }
    } else {
      // Either current user or target user doesn't exist in the database
      showErrorDialog(context, "User not found or missing connection data.");
    }
  }

  void showNoPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Access Denied"),
        content: Text("You do not have permission to view this profile."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const MyAppBar({super.key});
}
