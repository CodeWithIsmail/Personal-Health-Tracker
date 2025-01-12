import 'ImportAll.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: true);

    if (authProvider.currentUser == null) {
      // No user logged in
      return LoginPage();
    } else if (!authProvider.isEmailVerified) {
      // User email not verified
      return VerificationPage();
    } else {
      // User fully authenticated
      return NavigationPage();
    }
  }
}
