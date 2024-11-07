import '../ImportAll.dart';

class Constants{
  static const String homeRoute='/';
  static const String signUpRoute='/sign-up';
  static const String emailVerificationRoute='/verify-email';
  static const String smsVerificationRoute='/verify-sms';
  static const String forgotPasswordRoute='/forgot-password';
  static const String logInRoute='/log-in';
  static const String landingRoute='/landing';

}

final gradientMain = LinearGradient(
  colors: [
    Color(0xFF355C7D),
    Color(0xFF6C5B7B),
    Color(0xFFC06C84),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final appNameTextStyle=TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  shadows: [
    Shadow(
      blurRadius: 10.0,
      color: Colors.black26,
      offset: Offset(3.0, 3.0),
    ),
  ],
);

