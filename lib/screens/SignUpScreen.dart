import '../ImportAll.dart';

class SignUpScreen extends StatefulWidget {
  final void Function()? togglefunction;

  SignUpScreen(this.togglefunction);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conPassword = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? tempEmail;
  String? tempPassword;

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

      tempEmail = email.text;
      tempPassword = password.text;

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: tempEmail!,
        password: tempPassword!,
      );
      User? user = credential.user;

      if (user != null) {
        await user.sendEmailVerification();
        _showVerificationDialog();
        bool isVerified = await checkEmailVerification(user);
        if (isVerified) {
          await _auth.signInWithEmailAndPassword(
            email: tempEmail!,
            password: tempPassword!,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          await user.delete();
          CustomToast('Email verification required. Please sign up again.',
                  Colors.blueGrey, Colors.white, 16)
              .showToast();
        }
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseError(e);
    } catch (e) {
      print(e);
    }
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Text("Verification Email Sent"),
          titleTextStyle: TextStyle(color: Colors.white),
          content: Text(
              "A verification email has been sent to ${tempEmail}. Please check your email to verify your account."),
          contentTextStyle: TextStyle(color: Colors.grey),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkEmailVerification(User user) async {
    while (!user.emailVerified) {
      await Future.delayed(Duration(seconds: 5));
      await user.reload();
    }
    return true;
  }

  void handleFirebaseError(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      CustomToast('The password provided is too weak.', Colors.blueGrey,
              Colors.white, 16)
          .showToast();
    } else if (e.code == 'email-already-in-use') {
      CustomToast('The account already exists for that email.', Colors.blueGrey,
              Colors.white, 16)
          .showToast();
    } else if (e.code == 'invalid-email') {
      CustomToast('Please enter a valid email address.', Colors.blueGrey,
              Colors.white, 16)
          .showToast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconName(
                          'images/appLogo.png',
                          MediaQuery.of(context).size.width / 3,
                          MediaQuery.of(context).size.height / 5),
                      SizedBox(height: MediaQuery.of(context).size.width / 50),
                      Text('Personal Health Tracker', style: appNameTextStyle),
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
                      Text("Or continue with",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: MediaQuery.of(context).size.width / 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            // onTap: signInWithGoogle, // Uncomment when Google sign-in is implemented
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
                              width: MediaQuery.of(context).size.width / 15),
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
