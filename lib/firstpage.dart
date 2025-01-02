// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLogo(),
              SizedBox(height: 40),
              buildAuthButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogo() {
    return Column(
      children: [
        Icon(
          Icons.shopping_cart,
          size: 80,
          color: Colors.black,
        ),
        SizedBox(height: 20),
        Text(
          'SHOPPING CART',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildAuthButtons(BuildContext context) {
    return Column(
      children: [
        buildPrimaryButton(
          'Create Account',
          () => Navigator.pushNamed(context, '/signup'),
        ),
        SizedBox(height: 15),
        buildSecondaryButton(
          'Login',
          () => Navigator.pushNamed(context, '/login'),
        ),
      ],
    );
  }

  Widget buildPrimaryButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        iconColor: Colors.blue,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildSecondaryButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        side: BorderSide(color: Colors.black),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}
