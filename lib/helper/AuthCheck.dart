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
          User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null && currentUser.emailVerified) {
            String? email = FirebaseAuth.instance.currentUser?.email;
            if (email != null) {
              String uname = email.substring(0, email.indexOf('@'));
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uname)
                    .get(),
                builder: (context, docSnapshot) {
                  if (docSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (docSnapshot.hasData && docSnapshot.data!.exists) {
                    return HomePage();
                  } else {
                    ProfileInfo profileInfo = new ProfileInfo(
                        uname,
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        email,
                        "",
                        Timestamp.fromDate(DateTime.now()),
                        "",
                        "",
                        0.0,
                        0.0);
                    // return ProfileInput(profileInfo);
                    return LoginOrRegistration();
                  }
                },
              );
            } else
              return LoginOrRegistration();
          } else {
            return LoginOrRegistration();
          }
        } else {
          return LoginOrRegistration();
        }
      },
    );
  }
}
