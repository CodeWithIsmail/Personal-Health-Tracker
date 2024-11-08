// import '../ImportAll.dart';
//
// class LogInScreen extends StatefulWidget {
//   void Function()? togglefunction;
//
//   LogInScreen(this.togglefunction);
//
//   @override
//   State<LogInScreen> createState() => _LogInScreenState();
// }
//
// class _LogInScreenState extends State<LogInScreen> {
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//
//   void googleSignIn() async {
//     try {
//       await AuthService().SignInWithGoogle();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(),
//         ),
//       );
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void forgotPassword() {}
//
//   void logIn() async {
//     try {
//       final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: email.text, password: password.text);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(),
//         ),
//       );
//       print(credential);
//     } on FirebaseAuthException catch (e) {
//       print(e.code);
//       if (e.code == "invalid-credential") {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return CustomAlert(
//                 "Invalid credential.", Colors.deepPurple, Colors.white);
//           },
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: gradientMain,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomIconName(
//                           'images/appLogo.png',
//                           MediaQuery.of(context).size.width / 3,
//                           MediaQuery.of(context).size.height / 5),
//                       SizedBox(height: MediaQuery.of(context).size.width / 50),
//                       Text(
//                         'Personal Health Tracker',
//                         style: appNameTextStyle,
//                       ),
//                       SizedBox(height: MediaQuery.of(context).size.width / 10),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             CustomTextField("Email", false, email,
//                                 TextInputType.emailAddress),
//                             SizedBox(
//                                 height: MediaQuery.of(context).size.width / 30),
//                             CustomTextField(
//                                 "Password", true, password, TextInputType.text),
//                             SizedBox(
//                                 height: MediaQuery.of(context).size.width / 20),
//                             Padding(
//                               padding: EdgeInsets.only(right: 10),
//                               child: CustomTextGestureDetector(
//                                   "Forgot Password?",
//                                   Colors.white60,
//                                   15,
//                                   true,
//                                   forgotPassword),
//                             ),
//                             SizedBox(
//                                 height: MediaQuery.of(context).size.width / 10),
//                             CustomButtonGestureDetector(
//                               "Login",
//                               double.infinity,
//                               kToolbarHeight,
//                               Colors.white.withOpacity(0.8),
//                               Colors.black,
//                               20,
//                               logIn,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: MediaQuery.of(context).size.width / 20),
//                       Text(
//                         "Or continue with",
//                         style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white.withOpacity(0.8),
//                             fontWeight: FontWeight.w600),
//                       ),
//                       SizedBox(height: MediaQuery.of(context).size.width / 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.grey.shade400,
//                             ),
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 1, horizontal: 7),
//                             child: GestureDetector(
//                               onTap: googleSignIn,
//                               child: CustomIconName(
//                                   'images/googleLogo.png',
//                                   MediaQuery.of(context).size.width / 10,
//                                   MediaQuery.of(context).size.height / 14),
//                             ),
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width / 15,
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.grey.shade400,
//                             ),
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 1, horizontal: 7),
//                             child: CustomIconName(
//                                 'images/appleLogo.png',
//                                 MediaQuery.of(context).size.width / 10,
//                                 MediaQuery.of(context).size.height / 14),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: MediaQuery.of(context).size.width / 20),
//                       CustomTextGestureDetector("Not a member? Register now!",
//                           Colors.white60, 15, true, widget.togglefunction),
//                       SizedBox(height: MediaQuery.of(context).size.width / 20),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  // void facebookSignIn() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       final AccessToken accessToken = result.accessToken!;
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => HomePage(),
  //         ),
  //       );
  //     } else {
  //       print("Facebook login failed: ${result.message}");
  //     }
  //   } catch (e) {
  //     print("Facebook login error: $e");
  //   }
  // }

  void forgotPassword() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Text("Reset Password"),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          content: Text("Select a verification method"),
          contentTextStyle: TextStyle(fontSize: 15, color: Colors.grey),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _sendPasswordResetEmail();
                  },
                  child: Text("Verify by Email"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _sendPhoneOTP();
                  },
                  child: Text("Verify by Phone"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      if (email.text.isEmpty) {
        _showErrorDialog("Please enter your email to proceed.");
        return;
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      _showMessageDialog("Password reset email sent to ${email.text}");
    } catch (e) {
      _showErrorDialog("Error: ${e.toString()}");
    }
  }

  Future<void> _sendPhoneOTP() async {
    try {
      if (email.text.isEmpty) {
        _showErrorDialog("Please enter your phone number to proceed.");
        return;
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: email.text,
        // Assume email field holds phone number
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _showErrorDialog("Verification failed. Error: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          _showOTPDialog(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      _showErrorDialog("Error: ${e.toString()}");
    }
  }

  void _showOTPDialog(String verificationId) {
    TextEditingController otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter OTP"),
          content: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter OTP"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String otp = otpController.text.trim();
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: otp,
                );

                try {
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  Navigator.pop(context); // Close the OTP dialog
                  _showMessageDialog("Phone number verified successfully.");
                } catch (e) {
                  _showErrorDialog("Invalid OTP. Please try again.");
                }
              },
              child: Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Info"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void logIn() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      User? user = credential.user;
      if (user != null && user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        print(credential);
      } else {
        showDialog(
          context: context,
          builder: (contest) {
            return CustomAlert(
                "Your email is not verified. Please verify your account using the link sent to your email.",
                Colors.deepPurple,
                Colors.white);
          },
        );
      }
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
                                'images/fbLogo.png',
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
