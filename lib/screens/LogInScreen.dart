import '../ImportAll.dart';

class LogInScreen extends StatefulWidget {
  void Function()? togglefunction;

  LogInScreen(this.togglefunction);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void googleSignIn() async {
    try {
      await AuthService().SignInWithGoogle();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void forgotPassword() {}

  void logIn() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      print(credential);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "invalid-credential") {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlert(
                "Invalid credential.", Colors.deepPurple, Colors.white);
          },
        );
      }
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
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: CustomTextGestureDetector(
                                  "Forgot Password?",
                                  Colors.white60,
                                  15,
                                  true,
                                  forgotPassword),
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.width / 10),
                            CustomButtonGestureDetector(
                              "Login",
                              double.infinity,
                              kToolbarHeight,
                              Colors.white.withOpacity(0.8),
                              Colors.black,
                              20,
                              logIn,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width / 20),
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
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.shade400,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 7),
                            child: GestureDetector(
                              onTap: googleSignIn,
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
                      CustomTextGestureDetector("Not a member? Register now!",
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
