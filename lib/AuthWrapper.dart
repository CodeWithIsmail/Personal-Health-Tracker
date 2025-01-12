import 'ImportAll.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    // if (authProvider.currentUser == null) {
    //   // No user logged in
    //   return LoginOrRegistration();
    // } else if (!authProvider.isEmailVerified) {
    //   // User email not verified
    //   return VerificationPendingScreen();
    // } else if (!authProvider.isProfileComplete) {
    //   // Email verified but Profile incomplete
    //   return LoginOrRegistration();
    // } else {
    //   // User fully authenticated
      return HomePage();
    // }
  }
}
