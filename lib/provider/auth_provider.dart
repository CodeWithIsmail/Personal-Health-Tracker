import '../ImportAll.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;

  User? get user => _user;
  User? _currentUser;

  User? get currentUser => _currentUser;
  String? _currentUserName;

  String? get currentUserName => _currentUserName;

  bool get isAuthenticated => _user != null;

  AuthenticationProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      _currentUser = user; // Update currentUser whenever auth state changes
      _updateUserName(); // Update username whenever authentication state changes
      notifyListeners();
    });
  }

  // Update the current user's username
  void _updateUserName() {
    if (_currentUser?.email != null) {
      final email = _currentUser!.email!;
      _currentUserName = email.substring(0, email.indexOf('@'));
    } else {
      _currentUserName = null;
    }
  }

  // Sign up a new user
  Future<void> signUp(String email, String password, String conPassword,
      BuildContext context) async {
    try {
      if (password != conPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password mismatched')),
        );
        return;
      }
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _currentUser = userCredential.user;
      _updateUserName();
      notifyListeners();

      // Send verification email
      await _currentUser?.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Account created! A verification email has been sent.')),
      );

      // Navigate to VerificationPendingScreen
      Navigator.pushReplacementNamed(context, AppRoutes.verify);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Log in with email and password
  Future<void> logIn(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _currentUser = userCredential.user;
      _updateUserName();

      // Check if the email is verified
      if (_currentUser != null && !_currentUser!.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please verify your email before logging in.')),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.verify);
        return;
      }

      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );

      // Navigate to HomePage
      Navigator.pushReplacementNamed(context, AppRoutes.mainNavigationPage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // google sign in
  Future<void> googleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      _currentUser = userCredential.user; // Set the current user
      _updateUserName(); // Update the username after Google sign-in
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In successful!')),
      );
      // Navigate to HomePage
      Navigator.pushReplacementNamed(context, AppRoutes.mainNavigationPage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Send a password reset email
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Resend email verification
  Future<void> resendEmailVerification(BuildContext context) async {
    try {
      await _currentUser?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Refresh the user's state
  Future<void> refreshUser() async {
    if (_currentUser != null) {
      await _currentUser?.reload();
      _currentUser = _auth.currentUser;
      notifyListeners();
    }
  }

  // Check if the user's email is verified
  bool get isEmailVerified {
    return _currentUser?.emailVerified ?? false;
  }

  // Sign out the current user
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      final userInfoProvider =
          Provider.of<UserInfoProvider>(context, listen: false);
      userInfoProvider.reset();
      _currentUser = null; // Clear the current user
      _currentUserName = null; // Clear the username
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out successfully!')),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
