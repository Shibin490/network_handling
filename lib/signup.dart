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
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              buildTextField(
                controller: firstNameController,
                labelText: 'First Name',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your first name'
                    : value.length < 2
                        ? 'Name must be at least 2 characters'
                        : null,
              ),
              SizedBox(height: 16),
              buildTextField(
                controller: emailController,
                labelText: 'Email',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your email'
                    : !EmailValidator.validate(value)
                        ? 'Please enter a valid email'
                        : null,
              ),
              SizedBox(height: 16),
              buildTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter your password';
                  if (value.length < 8)
                    return 'Password must be at least 8 characters';
                  if (!value.contains(RegExp(r'[A-Z]')))
                    return 'Password must contain at least one uppercase letter';
                  if (!value.contains(RegExp(r'[0-9]')))
                    return 'Password must contain at least one number';
                  return null;
                },
              ),
              SizedBox(height: 16),
              buildTextField(
                controller: phoneController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your phone number'
                    : !RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)
                        ? 'Please enter a valid phone number'
                        : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      String? responseMessage = await signupUser(User(
                        fullname: firstNameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        phone: phoneController.text,
                      ));

                      if (responseMessage == "Number already exists") {
                        showSnackBar(
                            context,
                            "Phone number already exists. Please use a different number.",
                            Colors.red);
                      } else {
                        showSnackBar(context, responseMessage!, Colors.green);
                        Navigator.pushNamed(context, '/otp',
                            arguments: emailController.text);
                      }
                    } catch (e) {
                      showSnackBar(context, 'Signup failed: $e', Colors.red);
                    }
                  } else {
                    showSnackBar(context,
                        'Please correct the errors in the form.', Colors.red);
                  }
                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                child: Text('Back to Home'),
              ),
            ],
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
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
