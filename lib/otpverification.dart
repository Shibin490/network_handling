import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

class OTPScreen extends StatelessWidget {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  String getOtp() {
    return otpControllers.map((controller) => controller.text).join();
  }

  void verifyOtp(BuildContext context, String email) {
    final otp = getOtp();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.verifyOtp(otp);

    if (authProvider.isOtpVerified) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP. '),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  void resendOtp(BuildContext context, String email) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.resendOtp(email);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('A new OTP has been sent to $email')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to your email',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 50,
                  child: TextField(
                    controller: otpControllers[index],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.length == 1 && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => verifyOtp(context, email),
              child: Text('Verify & Proceed'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => resendOtp(context, email),
              child: Text(
                'Resend OTP',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
