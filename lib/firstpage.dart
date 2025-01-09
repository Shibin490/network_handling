// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _fadeInLogo();
  }

  void _fadeInLogo() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLogo(),
              SizedBox(height: 60),
              buildAuthButtons(context),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogo() {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(seconds: 2),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart,
              size: 80,
              color: Colors.blue[700],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'SHOPPING CART',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Your one-stop shop for everything',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAuthButtons(BuildContext context) {
    return Column(
      children: [
        buildPrimaryButton(
          'Create Account',
          () => Navigator.pushNamed(context, '/signup'),
        ),
        SizedBox(height: 16),
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
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        elevation: 2,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget buildSecondaryButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        side: BorderSide(color: Colors.blue[700]!, width: 1.5),
        foregroundColor: Colors.blue[700],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Widget buildFooterText() {
  //   // return Text(
  //   //   'By continuing, you agree to our Terms & Privacy Policy',
  //   //   textAlign: TextAlign.center,
  //   //   style: TextStyle(
  //   //     color: Colors.grey[600],
  //   //     fontSize: 14,
  //   //   ),
  //   // );
  // }
}
