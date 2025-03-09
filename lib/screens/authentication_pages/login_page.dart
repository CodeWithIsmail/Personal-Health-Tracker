import 'package:personal_health_tracker/screens/authentication_pages/signup_page.dart';

import '../../ImportAll.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();

  LoginPage();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
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
                            // Padding(
                            //   padding: EdgeInsets.only(right: 10),
                            //   child: CustomTextGestureDetector(
                            //     "Forgot Password?",
                            //     Colors.white60,
                            //     15,
                            //     true,
                            //     () {
                            //       if (email.text.isEmpty) {
                            //         ScaffoldMessenger.of(context).showSnackBar(
                            //           const SnackBar(
                            //               content: Text(
                            //                   'Enter your email to reset password.')),
                            //         );
                            //         return;
                            //       }
                            //       authProvider.resetPassword(
                            //           email.text, context);
                            //     },
                            //   ),
                            // ),
                            SizedBox(
                                height: MediaQuery.of(context).size.width / 10),
                            CustomButtonGestureDetector(
                              "Login",
                              double.infinity,
                              kToolbarHeight,
                              Colors.white.withOpacity(0.8),
                              Colors.black,
                              20,
                              () {
                                if (email.text.isEmpty ||
                                    password.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Email and Password are required!')),
                                  );
                                  return;
                                }
                                authProvider.logIn(
                                    email.text, password.text, context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width / 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade400,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: GestureDetector(
                          onTap: () => authProvider.googleSignIn(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconName(
                                  'images/googleLogo.png',
                                  MediaQuery.of(context).size.width / 10,
                                  MediaQuery.of(context).size.height / 14),
                              SizedBox(width: 10),
                              Text(
                                "Log in with Google",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width / 20),
                      CustomTextGestureDetector(
                        "Not a member? Register now!",
                        Colors.white60,
                        15,
                        true,
                        () {
                          Navigator.pushReplacementNamed(context, AppRoutes.signup);
                        },
                      ),
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
