import '../ImportAll.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          String? email = FirebaseAuth.instance.currentUser?.email;
          print(email);
          return HomePage();
        } else {
          return LoginOrRegistration();
        }
      },
    );
  }
}
