import '../../ImportAll.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();

  SignupPage();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController conPassword = TextEditingController();

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
                              () async {
                                await authProvider.signUp(
                                  email.text.trim(),
                                  password.text.trim(),
                                  conPassword.text.trim(),
                                  context,
                                );
                              },
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.width / 20),
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
                          onTap: () async {
                            await authProvider.googleSignIn(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconName(
                                  'images/googleLogo.png',
                                  MediaQuery.of(context).size.width / 10,
                                  MediaQuery.of(context).size.height / 14),
                              SizedBox(width: 10),
                              Text(
                                "Sign up with Google",
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
                        "Already a member? Login now!",
                        Colors.white60,
                        15,
                        true,
                        () {
                          Navigator.pushReplacementNamed(context,AppRoutes.login);
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
