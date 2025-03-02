import '../../ImportAll.dart';

class VerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Your Email'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mail_outline,
                size: 100,
                color: Colors.teal.shade700,
              ),
              SizedBox(height: 20),
              Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'A verification email has been sent to your registered email address. Please check your inbox and follow the link to activate your account.',
                style: TextStyle(fontSize: 16, color: Colors.teal.shade700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await authProvider.resendEmailVerification(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Verification email sent!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                label: Text(
                  'Resend Verification Email',
                  style: TextStyle(color: Colors.white),
                ),
                style: buildVerifyButton(),
              ),
              SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await authProvider.refreshUser(); // Reload user state
                    if (authProvider.isEmailVerified) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email verified!')),
                      );
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.mainNavigationPage);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email not verified yet.')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                },
                icon: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                label: Text(
                  'I\'ve Verified My Email',
                  style: TextStyle(color: Colors.white),
                ),
                style: buildVerifyButton(),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                icon: Icon(
                  Icons.login,
                  color: Colors.white,
                ),
                label: Text(
                  'Go to Login page',
                  style: TextStyle(color: Colors.white),
                ),
                style: buildVerifyButton(),
              ),
              SizedBox(height: 20),
              Text(
                'Didn\'t receive the email? Check your spam folder or try resending.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.teal.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle buildVerifyButton() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      backgroundColor: Colors.teal.shade600,
      textStyle: TextStyle(fontSize: 18),
    );
  }
}
