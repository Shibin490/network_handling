import 'package:flutter/material.dart';
import 'package:leveleight/signupapi.dart';
import 'package:email_validator/email_validator.dart';
import 'signmodel.dart';

class SignupScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildTextField(
                  controller: firstNameController,
                  labelText: 'Full Name',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                SizedBox(height: 20),
                buildTextField(
                  controller: emailController,
                  labelText: 'Email',
                  validator: (value) => !EmailValidator.validate(value ?? '')
                      ? 'Please enter a valid email'
                      : null,
                ),
                SizedBox(height: 20),
                buildTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  obscureText: true,
                  validator: validatePassword,
                ),
                SizedBox(height: 20),
                buildTextField(
                  controller: phoneController,
                  labelText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      !RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value ?? '')
                          ? 'Please enter a valid phone number'
                          : null,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => handleSignup(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  child: Text(
                    'Back to Home',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
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
      ),
      validator: validator,
    );
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  Future<void> handleSignup(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        String? responseMessage = await signupUser(User(
          fullname: firstNameController.text,
          email: emailController.text,
          password: passwordController.text,
          phone: phoneController.text,
        ));

        final isPhoneExists = responseMessage == "Number already exists";
        showSnackBar(
          context,
          isPhoneExists
              ? "Phone number already exists. Please use a different number."
              : responseMessage!,
          isPhoneExists ? Colors.red : Colors.green,
        );

        if (!isPhoneExists) {
          Navigator.pushNamed(
            context,
            '/verify',
            arguments: emailController.text,
          );
        }
      } catch (e) {
        showSnackBar(context, 'Signup failed: $e', Colors.red);
      }
    }
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
