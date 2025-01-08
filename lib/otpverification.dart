import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

class OTPScreen extends StatelessWidget {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  OTPScreen({Key? key}) : super(key: key);

  String get otp => controllers.map((c) => c.text).join();

  void verifyOtp(BuildContext context, String email) async {
    if (otp.length != 4) {
      _showErrorSnackBar(context, 'Please enter complete OTP');
      return;
    }

    isLoadingNotifier.value = true;

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.verifyOtp(otp, email);

      if (authProvider.isOtpVerified) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        _showErrorSnackBar(context, 'Invalid OTP. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Verification failed. Please try again.');
    } finally {
      isLoadingNotifier.value = false;
    }
  }

  void resendOtp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP resent successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildOTPField(BuildContext context, int index) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextFormField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue),
          ),
          counterText: '',
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 3) {
            focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;

    if (email == null || email.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Verification')),
        body: const Center(child: Text('Invalid email address')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Verification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'We sent a code to\n$email',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => _buildOTPField(context, index),
                ),
              ),
              const SizedBox(height: 40),
              ValueListenableBuilder<bool>(
                valueListenable: isLoadingNotifier,
                builder: (context, isLoading, _) {
                  return SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : () => verifyOtp(context, email),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Verify',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => resendOtp(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                ),
                child: Text(
                  'Resend Code',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
