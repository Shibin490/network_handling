// ignore_for_file: prefer_const_constructors, unused_local_variable, use_key_in_widget_constructors, library_private_types_in_public_api, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your first name'
                    : value.length < 2
                        ? 'Name must be at least 2 characters'
                        : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your email'
                    : !EmailValidator.validate(value)
                        ? 'Please enter a valid email'
                        : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter your password';
                  if (value.length < 8)
                    return 'Password must be at least 8 characters';
                  if (!value.contains(RegExp(r'[A-Z]')))
                    return 'Must contain an uppercase letter';
                  if (!value.contains(RegExp(r'[0-9]')))
                    return 'Must contain a number';
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your phone number'
                    : !RegExp(r'^\+?[\d\s-]{10,}\$').hasMatch(value)
                        ? 'Please enter a valid phone number'
                        : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle signup logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign Up Successful')),
                    );
                  }
                },
                child: Text('Sign Up'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
