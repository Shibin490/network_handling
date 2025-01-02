// ignore_for_file: use_key_in_widget_constructors

import 'homepage.dart';
import 'login.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return auth.isLoggedIn ? HomeScreen() : LoginScreen();
      },
    );
  }
}
