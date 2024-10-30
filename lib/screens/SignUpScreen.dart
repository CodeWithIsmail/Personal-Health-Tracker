import '../ImportAll.dart';

class SignUpScreen extends StatefulWidget {
  void Function()? togglefunction;

  SignUpScreen(this.togglefunction);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  TextEditingController uname = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conPassword = TextEditingController();

  void forgotPassword() {}

  void logIn() {}

  void register() {}

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
                  height: MediaQuery.of(context).size.height ,
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
                            CustomTextField(
                                "Email", false, uname, TextInputType.emailAddress),
                            SizedBox(height: MediaQuery.of(context).size.width / 30),
                            CustomTextField(
                                "Password", true, password, TextInputType.text),
                            SizedBox(height: MediaQuery.of(context).size.width / 20),
                            CustomTextField(
                                "Confirm Password", true, conPassword, TextInputType.text),
                            SizedBox(height: MediaQuery.of(context).size.width / 20),
                            // Padding(
                            //   padding: EdgeInsets.only(right: 10),
                            //   child: CustomTextGestureDetector("Forgot Password?",
                            //       Colors.white60, 15, true, forgotPassword),
                            // ),
                            // SizedBox(height: MediaQuery.of(context).size.width / 10),
                            CustomButtonGestureDetector(
                              "Continue",
                              double.infinity,
                              kToolbarHeight,
                              Colors.white.withOpacity(0.8),
                              Colors.black,
                              20,
                              logIn,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.width / 20),
                          ],
                        ),
                      ),
                      // Text(
                      //   "Or continue with",
                      //   style: TextStyle(
                      //       fontSize: 15,
                      //       color: Colors.white.withOpacity(0.8),
                      //       fontWeight: FontWeight.w600),
                      // ),
                      // SizedBox(height: MediaQuery.of(context).size.width / 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(15),
                      //         color: Colors.grey.shade400,
                      //       ),
                      //       padding: EdgeInsets.symmetric(vertical: 1, horizontal: 7),
                      //       child: CustomIconName(
                      //           'images/googleLogo.png',
                      //           MediaQuery.of(context).size.width / 10,
                      //           MediaQuery.of(context).size.height / 14),
                      //     ),
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width / 15,
                      //     ),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(15),
                      //         color: Colors.grey.shade400,
                      //       ),
                      //       padding: EdgeInsets.symmetric(vertical: 1, horizontal: 7),
                      //       child: CustomIconName(
                      //           'images/appleLogo.png',
                      //           MediaQuery.of(context).size.width / 10,
                      //           MediaQuery.of(context).size.height / 14),
                      //     ),
                      //   ],
                      // ),
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
