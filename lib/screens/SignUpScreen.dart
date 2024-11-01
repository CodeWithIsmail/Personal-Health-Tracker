import '../ImportAll.dart';

class SignUpScreen extends StatefulWidget {
  void Function()? togglefunction;

  SignUpScreen(this.togglefunction);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conPassword = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void register() async {
    try {
      if (email.text.isEmpty ||
          password.text.isEmpty ||
          conPassword.text.isEmpty) {
        CustomToast(
                'All fields must be filled', Colors.blueGrey, Colors.white, 16)
            .showToast();
        return;
      }

      if (password.text != conPassword.text) {
        CustomToast('Passwords don\'t match', Colors.blueGrey, Colors.white, 16)
            .showToast();
        return;
      }

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      print(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'weak-password') {
        CustomToast('The password provided is too weak.', Colors.blueGrey,
                Colors.white, 16)
            .showToast();
      } else if (e.code == 'email-already-in-use') {
        CustomToast('The account already exists for that email.',
                Colors.blueGrey, Colors.white, 16)
            .showToast();
      }
    } catch (e) {
      print(e);
    }
  }

  // final GoogleSignIn googleSignIn = GoogleSignIn();

  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  //     final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
  //
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );
  //
  //     final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //     final User? user = userCredential.user;
  //
  //     // Use the user object for further operations or navigate to a new screen.
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     // Sign in with Google
  //     final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(
  //       GoogleAuthProvider.credential(
  //         accessToken: await GoogleAuthProvider.getCredential(),
  //       ),
  //     );
  //     // Handle successful sign-in here
  //     print("Google Sign-In Successful: ${userCredential.user?.email}");
  //   } catch (e) {
  //     print("Error signing in with Google: $e");
  //   }
  // }
  //
  // Future<void> signInWithApple() async {
  //   try {
  //     // Sign in with Apple
  //     final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(
  //       OAuthProvider("apple.com").credential(),
  //     );
  //     // Handle successful sign-in here
  //     print("Apple Sign-In Successful: ${userCredential.user?.email}");
  //   } catch (e) {
  //     print("Error signing in with Apple: $e");
  //   }
  // }

  void forgotPassword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding:EdgeInsets.symmetric(vertical: 5,horizontal: 15),
          decoration: BoxDecoration(
            gradient: gradientMain,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconName(
                          'images/appLogo.png',
                          MediaQuery.of(context).size.width / 3,
                          MediaQuery.of(context).size.height / 5),
                      SizedBox(height: MediaQuery.of(context).size.width / 50),
                      Text(
                        'Personal Health Tracker',
                        style: appNameTextStyle,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width / 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomTextField("Email", false, email,
                                TextInputType.emailAddress),
                            SizedBox(
                                height: MediaQuery.of(context).size.width / 30),
                            CustomTextField(
                                "Password", true, password, TextInputType.text),
                            SizedBox(
                                height: MediaQuery.of(context).size.width / 20),
                            CustomTextField("Confirm Password", true,
                                conPassword, TextInputType.text),
                            SizedBox(
                                height: MediaQuery.of(context).size.width / 20),
                            // Padding(
                            //   padding: EdgeInsets.only(right: 10),
                            //   child: CustomTextGestureDetector("Forgot Password?",
                            //       Colors.white60, 15, true, forgotPassword),
                            // ),
                            // SizedBox(height: MediaQuery.of(context).size.width / 10),
                            CustomButtonGestureDetector(
                              "Sign Up",
                              double.infinity,
                              kToolbarHeight,
                              Colors.white.withOpacity(0.8),
                              Colors.black,
                              20,
                              register,
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.width / 20),
                          ],
                        ),
                      ),
                      Text(
                        "Or continue with",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width / 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            // onTap: signInWithGoogle,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade400,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 7),
                              child: CustomIconName(
                                  'images/googleLogo.png',
                                  MediaQuery.of(context).size.width / 10,
                                  MediaQuery.of(context).size.height / 14),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.shade400,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 7),
                            child: CustomIconName(
                                'images/appleLogo.png',
                                MediaQuery.of(context).size.width / 10,
                                MediaQuery.of(context).size.height / 14),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width / 20),
                      CustomTextGestureDetector("Already a member? Login now!",
                          Colors.white60, 15, true, widget.togglefunction),
                      SizedBox(height: MediaQuery.of(context).size.width / 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
